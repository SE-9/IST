package com.se.demo.dto;

import com.se.demo.entity.Issue;
import lombok.Getter;

import java.util.List;
import java.util.stream.Collectors;

@Getter

public class IssueResponseDTO {

    private Long id;
    private String title;
    //private Long userId;
    private List<CommentResponse> comments;

    public IssueResponseDTO(Issue issue) {
        this.id = (long) issue.getId();
        this.title = issue.getTitle();
        //this.userId = issue.getUserId(); // Assuming Issue has a userId field
        this.comments = issue.getComments().stream()
                .map(CommentResponse::new)
                .collect(Collectors.toList());
    }


}
