package com.se.demo.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.xml.stream.events.Comment;
import java.util.Date;
import java.util.List;

@Entity
@Getter//모든필드에 대한 접근자 메서드 생성
@NoArgsConstructor(access = AccessLevel.PROTECTED)//기본 생성자 생성

public class Issue {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String state;
    private int projectId;

    @Column(name = "title", nullable = false)
    private String title;

    @Column(name = "description")
    private String description;

    @Column(name = "reporter_id")
    private int reporterId;

    @Column(name = "date")
    private Date date;

    @Column(name = "fixer_id")
    private int fixerId;

    @Column(name = "assignee")
    private int assignee;

    @Column(name = "priority")
    private String priority;


    @OneToMany(mappedBy = "issue", fetch = FetchType.EAGER, cascade = CascadeType.REMOVE)
    private List<CommentEntity> comments;  // mappedBy를 issue로 설정
}








