package com.se.demo.service;

import com.se.demo.dto.MemberDTOOfSY;
import com.se.demo.entity.MemberEntityOfSY;
import com.se.demo.repository.MemberRepositoryOfSY;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class MemberServiceOfSY {

    private final MemberRepositoryOfSY memberRepositoryOfSY;

    public void join(MemberDTOOfSY request) {
        MemberEntityOfSY member = MemberEntityOfSY.builder()
                .nickname(request.getNickname())
                .password(request.getPassword())
                .build();
        memberRepositoryOfSY.save(member);
    }

    public boolean checkId(String id) {
        return memberRepositoryOfSY.existsById(Integer.parseInt(id));
    }
}
