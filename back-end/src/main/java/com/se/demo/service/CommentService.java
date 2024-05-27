package com.se.demo.service;

import com.se.demo.dto.AddCommentRequest;
import com.se.demo.dto.CommentResponse;
import com.se.demo.entity.CommentEntity;
import com.se.demo.entity.Issue;
import com.se.demo.entity.MemberEntity;
import com.se.demo.repository.CommentRepository;
import com.se.demo.repository.IssueRepository;
import com.se.demo.repository.MemberRepository;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Service

public class CommentService {

    private final CommentRepository commentRepository;
    private final MemberRepository memberRepository;
    private final IssueRepository issueRepository; // IssueRepository를 주입 받아야 함

    public CommentResponse save(AddCommentRequest request, String nickName, Long issueId) {
        // Issue issue = new Issue(issueId);
        Optional<MemberEntity> member = MemberRepository.findByNickname(nickName);
        if (member.isEmpty()) {
            throw new IllegalArgumentException("Invalid user nickname");
        }

        Issue issue = issueRepository.findById(issueId)
                .orElseThrow(() -> new IllegalArgumentException("Issue not found with id: " + issueId));

        CommentEntity commentEntity = (CommentEntity) request.toEntity(issue);
        commentEntity.setCreaterId(member.get());

        issue = (Issue) issueRepository.findById(issueId)
                .orElseThrow(() -> new IllegalArgumentException("Issue not found with id: " + issueId));
        //commentEntity.setIssue(issue);
        CommentEntity savedComment = (CommentEntity) commentRepository.save(commentEntity);


        return new CommentResponse(savedComment);
    }



   /* @Transactional(readOnly = true)
    public List<CommentResponse> findAll(Long id) {
        List<CommentEntity> comments = commentRepository.findByIssueId(id);
        return comments.stream()
                .map(CommentResponse::new)
                .collect(Collectors.toList());
    }*/

    public List<Issue> search(String Istate) {
        // 검색 로직 구현
        // 예: return issueRepository.findByState(Istate);
        return List.of(); // 임시 반환 값
    }


    @Transactional(readOnly = true)
    public List<CommentResponse> findAllByIssueId(Long id) {
        List<CommentEntity> comments = commentRepository.findByIssueId(id);
        //Long issueId = null;
        return comments.stream()
                .map(CommentResponse::new)
                .collect(Collectors.toList());
    }
}
