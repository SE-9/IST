package com.se.demo.controller;

import com.se.demo.service.CommentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.time.LocalDateTime;
import java.util.List;

import static org.springframework.data.jpa.domain.AbstractPersistable_.id;

@RequiredArgsConstructor
@RequestMapping("/api")
@RestController

public class Comment {

    private final CommentService commentService;

    @PostMapping("/articles/{id}/comments") //+현재 인증 정보를 가져오는 principal객체
    public ResponseEntity<Comment> save(@PathVariable Long id, @RequestBody Comment request, Principal principal) {
        Comment savedComment= (Comment) commentService.save(id,request, principal.getName());

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(savedComment);
    }

    //댓글 읽어오기
    @GetMapping("/articles/{id}/comments")
    public List<Comment> read(@PathVariable Integer id) {
        return commentService.findAll(Long.valueOf(id));
    }

    public Integer getId() {
        return id;
    }

    public String getComment() {
        return comment;
    }

    public LocalDateTime getCreatedDate() {
    }

    public Comment getUser() {
    }

    public String getNickname() {
    }
}
