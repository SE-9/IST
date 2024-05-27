package com.se.demo.dto;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class MemberDTOOfBW {
    //view와 소통

 private int user_id;

 private String nickname;

 private String password;

 public String getId() {
  return String.valueOf(user_id);
 }
}

/*
class AdminDTOOfBW extends MemberDTOOfBW{
}*/