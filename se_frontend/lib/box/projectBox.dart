import 'package:flutter/material.dart';
import 'package:se_frontend/projectPage.dart'; //플젝 페이지로 이동해야되서 불러옴

// 박스로 플젝표현
class ProjectBox extends StatelessWidget {
  final String title; // 제목 저장 변수
  final String description; // 설명 저장 변수
  final String leader;

  const ProjectBox({
    required this.title,
    required this.description,
    required this.leader,
  }); // 생성자로 title과 description을 받아옴

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 누르면 프로젝트 페이지로 이동하게 제스쳐
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProjectPage(
              title: title,
              description: description,
              leader: leader,
            ),
          ),
        );
      },
      child: Container(
        width: 250,
        height: 150,
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(right: 16.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 250, 219, 234),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(description),
          ],
        ),
      ),
    );
  }
}
