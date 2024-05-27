package com.se.demo.dto;

import com.se.demo.entity.MemberEntityOfSY;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import org.antlr.v4.runtime.misc.NotNull;

public class MemberDTOOfSY {

    public String getNickname() {
        return null;
    }

    public String getPassword() {
        return null;
    }

    public String getId() {
        return null;
    }

    @Getter
    @Setter
    @Data

    public static class MemberDTO {

        @NotBlank(message = "아이디는 필수 입력 값입니다.")
        private Integer id;

        @NotBlank(message = "닉네임은 필수 입력 값입니다.")
        private String nickname;

        @NotBlank(message = "비밀번호는 필수 입력 값입니다.")
        private String password;



        public MemberEntityOfSY toEntity() {
            return MemberEntityOfSY.builder()

                    .id(id)
                    .nickname(nickname)
                    .password(password)
                    .build();
        }

    }
}
