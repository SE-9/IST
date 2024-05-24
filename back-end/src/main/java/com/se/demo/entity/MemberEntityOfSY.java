package com.se.demo.entity;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "user")
public class MemberEntityOfSY {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id", nullable = false, unique = true)
    private Integer id;

    @Column(name = "nickname", nullable = false)
    private String nickname;

    @Column(name = "password", nullable = false)
    private String password;

    @Builder
    public MemberEntityOfSY(Integer id, String nickname, String password) {
        this.id = id;
        this.nickname = nickname;
        this.password = password;
    }

    @EqualsAndHashCode(callSuper = true)
    @Data
    public static class UserDetails extends com.se.demo.entity.UserDetails {
        private final MemberEntityOfSY member;

        public UserDetails(MemberEntityOfSY member) {
            this.member = member;
        }

        @Override
        public String getPassword() {
            return this.member.getPassword();
        }

        @Override
        public String getNickname() {
            return this.member.getNickname();
        }

        @Override
        public Integer getId() {
            return this.member.getId();
        }

        @Override
        public boolean isEnabled() {
            return true;
        }
    }
}
