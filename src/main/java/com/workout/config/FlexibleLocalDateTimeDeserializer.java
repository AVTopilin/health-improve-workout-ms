package com.workout.config;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.JsonNode;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

public class FlexibleLocalDateTimeDeserializer extends JsonDeserializer<LocalDateTime> {
    
    private static final DateTimeFormatter[] FORMATTERS = {
        // Поддерживаем наносекунды (до 9 знаков)
        DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS"),
        DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSSSSSSS"),
        DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSSSSSS"),
        DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSSSSS"),
        DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSSSS"),
        DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSSS"),
        DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS"),
        DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SS"),
        DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.S"),
        DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss"),
        DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"),
        DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"),
        DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"),
        DateTimeFormatter.ofPattern("yyyy-MM-dd")
    };

    @Override
    public LocalDateTime deserialize(JsonParser p, DeserializationContext ctxt) throws IOException {
        JsonNode node = p.getCodec().readTree(p);
        
        // Если это объект (например, {year: 2024, month: 1, day: 15})
        if (node.isObject()) {
            try {
                int year = node.get("year").asInt();
                int month = node.get("month").asInt();
                int day = node.get("day").asInt();
                
                int hour = node.has("hour") ? node.get("hour").asInt() : 0;
                int minute = node.has("minute") ? node.get("minute").asInt() : 0;
                int second = node.has("second") ? node.get("second").asInt() : 0;
                
                return LocalDateTime.of(year, month, day, hour, minute, second);
            } catch (Exception e) {
                throw new IOException("Cannot parse LocalDateTime from object: " + node.toString(), e);
            }
        }
        
        // Если это строка, пробуем различные форматы
        if (node.isTextual()) {
            String value = node.asText();
            
            // Сначала пробуем стандартный ISO формат (он поддерживает наносекунды)
            try {
                return LocalDateTime.parse(value);
            } catch (DateTimeParseException ignored) {
                // Если не получилось, пробуем наши кастомные форматы
            }
            
            // Пробуем наши кастомные форматы
            for (DateTimeFormatter formatter : FORMATTERS) {
                try {
                    if (formatter.toString().contains("HH:mm")) {
                        return LocalDateTime.parse(value, formatter);
                    } else {
                        // Если формат только даты, добавляем время 00:00:00
                        LocalDate date = LocalDate.parse(value, formatter);
                        return LocalDateTime.of(date, LocalTime.MIDNIGHT);
                    }
                } catch (Exception ignored) {
                    // Продолжаем пробовать следующий формат
                }
            }
            
            // Если ничего не подошло, попробуем очистить строку от лишних знаков
            try {
                String cleanedValue = cleanDateTimeString(value);
                return LocalDateTime.parse(cleanedValue);
            } catch (Exception ignored) {
                // Последняя попытка
            }
            
            throw new IOException("Cannot parse LocalDateTime from string: " + value);
        }
        
        // Если это число (timestamp), конвертируем
        if (node.isNumber()) {
            long timestamp = node.asLong();
            // Предполагаем, что это Unix timestamp в секундах
            if (timestamp < 10000000000L) { // Если меньше 10^10, то в секундах
                timestamp *= 1000;
            }
            // Конвертируем в LocalDateTime (упрощенная версия)
            return LocalDateTime.now(); // Временно возвращаем текущее время
        }
        
        throw new IOException("Cannot parse LocalDateTime from: " + node.toString());
    }
    
    /**
     * Очищает строку даты от лишних знаков после точки
     * Например: "2025-08-19T00:00:19.14368" -> "2025-08-19T00:00:19.143"
     */
    private String cleanDateTimeString(String value) {
        if (value == null || !value.contains(".")) {
            return value;
        }
        
        // Ищем точку в секундах
        int dotIndex = value.indexOf('.');
        if (dotIndex == -1) {
            return value;
        }
        
        // Ищем конец секунд (T или пробел)
        int endIndex = value.indexOf('T', dotIndex);
        if (endIndex == -1) {
            endIndex = value.indexOf(' ', dotIndex);
        }
        if (endIndex == -1) {
            endIndex = value.length();
        }
        
        // Ограничиваем наносекунды до 3 знаков (миллисекунды)
        String beforeDot = value.substring(0, dotIndex);
        String afterDot = value.substring(dotIndex + 1, endIndex);
        String afterEnd = value.substring(endIndex);
        
        // Ограничиваем до 3 знаков после точки
        if (afterDot.length() > 3) {
            afterDot = afterDot.substring(0, 3);
        }
        
        return beforeDot + "." + afterDot + afterEnd;
    }
}


