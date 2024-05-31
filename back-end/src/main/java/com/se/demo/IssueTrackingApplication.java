package com.se.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@SpringBootApplication
public class IssueTrackingApplication {

	public static void main(String[] args) {
		SpringApplication.run(IssueTrackingApplication.class, args);
		System.out.println("FIGHTING BACKEND~~~");
	}
	@Bean
	public WebMvcConfigurer corsConfigurer() {
		return new WebMvcConfigurer() {
			@Override
			public void addCorsMappings(CorsRegistry registry) {
<<<<<<< HEAD
				registry.addMapping("/**").allowedOrigins("http://localhost:61411/");
=======
				registry.addMapping("/**").allowedOrigins("http://localhost:57355/");
>>>>>>> 9d388ef0553dfaa4a98294fa682249b733d3f2e3
			}
		};
	}

}
