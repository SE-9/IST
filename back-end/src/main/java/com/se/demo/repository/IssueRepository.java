package com.se.demo.repository;

import com.se.demo.entity.Issue;
import jakarta.persistence.metamodel.SingularAttribute;
import org.springframework.data.jpa.domain.AbstractPersistable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.io.Serializable;
import java.util.Optional;

@Repository
public interface IssueRepository extends JpaRepository<Issue, Long> {
   // Optional<Issue> findById(Long issueId);

   // Optional<Issue> findById(Long issueId);// 추가적인 메서드 정의가 필요하다면 여기에 추가합니다.
}
