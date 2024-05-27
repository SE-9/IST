package com.se.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.xml.stream.events.Comment;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import com.se.demo.entity.CommentEntity; // 본인의 Comment 엔티티를 임포트

@NoArgsConstructor
@Getter
@AllArgsConstructor

public class CommentDTO {
    private Integer createrId;
    private String description;
    private final String createdDate = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy.MM.dd HH:mm"));
    private Integer id;

    public Comment toEntity(){
        CommentEntity build = CommentEntity.builder()
                .createrId(createrId)
                .description(description)
                .createdDate(LocalDateTime.now())
                .id(id)
                .build();
        return (Comment) build;


    }
}
