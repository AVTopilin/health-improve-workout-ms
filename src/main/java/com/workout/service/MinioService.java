package com.workout.service;

import io.minio.*;
import io.minio.http.Method;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;
import java.net.URL;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

@Service
@Slf4j
public class MinioService {
    
    @Value("${minio.endpoint}")
    private String endpoint;
    
    @Value("${minio.accessKey}")
    private String accessKey;
    
    @Value("${minio.secretKey}")
    private String secretKey;
    
    @Value("${minio.bucket}")
    private String bucket;
    
    private MinioClient getMinioClient() {
        return MinioClient.builder()
                .endpoint(endpoint)
                .credentials(accessKey, secretKey)
                .build();
    }
    
    /**
     * Загрузить файл в MinIO
     */
    public String uploadFile(MultipartFile file) {
        try {
            MinioClient minioClient = getMinioClient();
            
            // Проверяем существование bucket
            boolean bucketExists = minioClient.bucketExists(BucketExistsArgs.builder().bucket(bucket).build());
            if (!bucketExists) {
                minioClient.makeBucket(MakeBucketArgs.builder().bucket(bucket).build());
            }
            
            // Генерируем уникальное имя файла
            String fileName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
            
            // Загружаем файл
            minioClient.putObject(
                    PutObjectArgs.builder()
                            .bucket(bucket)
                            .object(fileName)
                            .stream(file.getInputStream(), file.getSize(), -1)
                            .contentType(file.getContentType())
                            .build()
            );
            
            log.info("Файл {} успешно загружен в MinIO", fileName);
            return fileName;
            
        } catch (Exception e) {
            log.error("Ошибка при загрузке файла в MinIO", e);
            throw new RuntimeException("Не удалось загрузить файл", e);
        }
    }
    
    /**
     * Получить URL для доступа к файлу
     */
    public String getFileUrl(String fileName) {
        try {
            MinioClient minioClient = getMinioClient();
            
            // Генерируем временный URL для доступа к файлу (действует 1 час)
            String url = minioClient.getPresignedObjectUrl(
                    GetPresignedObjectUrlArgs.builder()
                            .method(Method.GET)
                            .bucket(bucket)
                            .object(fileName)
                            .expiry(1, TimeUnit.HOURS)
                            .build()
            );
            
            return url;
            
        } catch (Exception e) {
            log.error("Ошибка при получении URL для файла {}", fileName, e);
            throw new RuntimeException("Не удалось получить URL для файла", e);
        }
    }
    
    /**
     * Скачать файл из MinIO
     */
    public Resource downloadFile(String fileName) {
        try {
            MinioClient minioClient = getMinioClient();
            
            // Получаем объект
            GetObjectResponse response = minioClient.getObject(
                    GetObjectArgs.builder()
                            .bucket(bucket)
                            .object(fileName)
                            .build()
            );
            
            // Создаем временный файл
            InputStream inputStream = response;
            // Здесь должна быть логика создания временного файла
            // Пока возвращаем null, так как нужно реализовать создание Resource
            
            log.info("Файл {} успешно скачан из MinIO", fileName);
            return null; // TODO: Реализовать создание Resource
            
        } catch (Exception e) {
            log.error("Ошибка при скачивании файла {} из MinIO", fileName, e);
            throw new RuntimeException("Не удалось скачать файл", e);
        }
    }
    
    /**
     * Удалить файл из MinIO
     */
    public void deleteFile(String fileName) {
        try {
            MinioClient minioClient = getMinioClient();
            
            minioClient.removeObject(
                    RemoveObjectArgs.builder()
                            .bucket(bucket)
                            .object(fileName)
                            .build()
            );
            
            log.info("Файл {} успешно удален из MinIO", fileName);
            
        } catch (Exception e) {
            log.error("Ошибка при удалении файла {} из MinIO", fileName, e);
            throw new RuntimeException("Не удалось удалить файл", e);
        }
    }
    
    /**
     * Проверить существование файла
     */
    public boolean fileExists(String fileName) {
        try {
            MinioClient minioClient = getMinioClient();
            
            minioClient.statObject(
                    StatObjectArgs.builder()
                            .bucket(bucket)
                            .object(fileName)
                            .build()
            );
            
            return true;
            
        } catch (Exception e) {
            return false;
        }
    }
}
