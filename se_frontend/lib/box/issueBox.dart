import 'package:flutter/material.dart';
import 'package:se_frontend/issuePage.dart';

//박스로 이슈 표현
class IssueBox extends StatelessWidget {
  final String title; // 제목 저장 변수
  final String description;
  final String assignee;
  final String reporter;
  final String status;

  const IssueBox({
    required this.title,
    required this.description,
    required this.assignee,
    required this.reporter,
    required this.status,
  }); // 생성자로 title과 description을 받아옴

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        // 누르면 프로젝트 페이지로 이동하게 제스쳐
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IssuePage(
                  title: title,
                  description: description,
                  leader: '리더류수정',
                  assignee: '하하',
                  reporter: '난 리포터다',
                  status: '우울상태',
                ),
              ));
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
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(status),
              const SizedBox(height: 10),
              Text(assignee),
              Text(reporter),
            ],
          ),
        ));
  }
}
