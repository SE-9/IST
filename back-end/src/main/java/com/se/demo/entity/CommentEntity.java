package com.se.demo.entity;

import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;

import java.time.LocalDateTime;
import java.util.List;

@Builder
@AllArgsConstructor
@Getter
@Table(name = "comment")
@Entity
@NoArgsConstructor


public class CommentEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "created_date")
    @CreatedDate
    private LocalDateTime createdDate;

    @Setter
    @ManyToOne
    @JoinColumn(name = "creater_id")
    private MemberEntity createrId;

    @Column(name = "description", nullable = false)
    private String description;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "issue_id")
    private Issue issue;  // Issue 필드를 추가하여 매핑 설정

    public void setCreaterId(MemberEntity createrId) {
        this.createrId = createrId;
    }

    public void setIssue(Issue issue) {
        this.issue = issue;
    }
}
