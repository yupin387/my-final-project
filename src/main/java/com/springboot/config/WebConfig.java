package com.springboot.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Bean
    public ViewResolver viewResolver() {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setPrefix("/WEB-INF/jsp/");
        resolver.setSuffix(".jsp");
        return resolver;
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // ✅ สำหรับอัปโหลดไฟล์
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:uploads/");

        // ✅ สำหรับ static resources (CSS, JS, รูปภาพ)
        // ต้องใช้ classpath: เพราะอยู่ใน src/main/resources/
        registry.addResourceHandler("/static/**")
                .addResourceLocations("classpath:/static/");
    }
}