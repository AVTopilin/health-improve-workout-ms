package com.workout.config;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.JsonNode;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

public class FlexibleLocalDateDeserializer extends JsonDeserializer<LocalDate> {
    
    private static final DateTimeFormatter[] FORMATTERS = {
        DateTimeFormatter.ofPattern("yyyy-MM-dd"),
        DateTimeFormatter.ofPattern("dd.MM.yyyy"),
        DateTimeFormatter.ofPattern("MM/dd/yyyy"),
        DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss"),
        DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm")
    };

    @Override
    public LocalDate deserialize(JsonParser p, DeserializationContext ctxt) throws IOException {
        JsonNode node = p.getCodec().readTree(p);
        
        // Если это объект (например, {year: 2024, month: 1, day: 15})
        if (node.isObject()) {
            try {
                int year = node.get("year").asInt();
                int month = node.get("month").asInt();
                int day = node.get("day").asInt();
                
                return LocalDate.of(year, month, day);
            } catch (Exception e) {
                throw new IOException("Cannot parse LocalDate from object: " + node.toString(), e);
            }
        }
        
        // Если это строка, пробуем различные форматы
        if (node.isTextual()) {
            String value = node.asText();
            
            // Сначала пробуем стандартный ISO формат
            try {
                return LocalDate.parse(value);
            } catch (DateTimeParseException ignored) {
                // Если не получилось, пробуем наши кастомные форматы
            }
            
            // Пробуем наши кастомные форматы
            for (DateTimeFormatter formatter : FORMATTERS) {
                try {
                    if (formatter.toString().contains("HH:mm")) {
                        // Если формат содержит время, извлекаем только дату
                        return LocalDate.parse(value.substring(0, 10), 
                            DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                    } else {
                        return LocalDate.parse(value, formatter);
                    }
                } catch (Exception ignored) {
                    // Продолжаем пробовать следующий формат
                }
            }
            
            // Если ничего не подошло, попробуем извлечь дату из строки с временем
            try {
                if (value.contains("T")) {
                    String datePart = value.substring(0, value.indexOf('T'));
                    return LocalDate.parse(datePart);
                }
            } catch (Exception ignored) {
                // Последняя попытка
            }
            
            throw new IOException("Cannot parse LocalDate from string: " + value);
        }
        
        // Если это число (timestamp), конвертируем
        if (node.isNumber()) {
            long timestamp = node.asLong();
            // Предполагаем, что это Unix timestamp в секундах
            if (timestamp < 10000000000L) { // Если меньше 10^10, то в секундах
                timestamp *= 1000;
            }
            // Конвертируем в LocalDate (упрощенная версия)
            return LocalDate.now(); // Временно возвращаем текущую дату
        }
        
        throw new IOException("Cannot parse LocalDate from: " + node.toString());
    }
}


