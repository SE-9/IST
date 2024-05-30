import 'package:flutter/material.dart';
import 'package:se_frontend/files/issueClass.dart';
import 'package:se_frontend/widgets/detail_box.dart';
import 'package:se_frontend/issue_detail.dart';

class IssueBox extends StatelessWidget {
  final Issue issue;

  const IssueBox({super.key, required this.issue});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 누르면 프로젝트 페이지로 이동하게 제스쳐
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IssueDetail(issue: issue),
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
              issue.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(issue.state.toString().split('.').last),
            const SizedBox(height: 10),
            Text(issue.assignee?.toString() ?? 'Unassigned'),
            Text(issue.reporter.toString()),
          ],
        ),
      ),
    );
  }
}
