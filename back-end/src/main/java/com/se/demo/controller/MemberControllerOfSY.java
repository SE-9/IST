package com.se.demo.controller;

import com.se.demo.dto.MemberDTOOfSY;
import com.se.demo.service.MemberServiceOfSY;
import com.se.demo.util.ApiUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@RestController
@RequestMapping("/members")
public class MemberControllerOfSY {

    private final MemberServiceOfSY memberServiceOfSY;

    @PostMapping("/signup")
    public ResponseEntity<?> join(@RequestBody MemberDTOOfSY request) {
        memberServiceOfSY.join(request);
        return ResponseEntity.ok(ApiUtils.success(null));
    }

    @PostMapping("/check")
    public ResponseEntity<?> check(@RequestBody MemberDTOOfSY request) {
        boolean isAvailable = memberServiceOfSY.checkId(request.getId());
        return ResponseEntity.ok(ApiUtils.success(isAvailable));
    }

    @GetMapping("/signup")
    public String signup() {
        return "Sign up";
    }
}


