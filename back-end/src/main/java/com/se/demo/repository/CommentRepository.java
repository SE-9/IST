package com.se.demo.repository;

import com.se.demo.entity.CommentEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CommentRepository<Comment> extends JpaRepository<CommentEntity, Long> {
    List<CommentEntity> findByIssueId(Long id);

    // List<issue> findByIStateContatining(String Istate);


}
