import 'package:flutter/material.dart';
import 'package:se_frontend/widgets/detail_box.dart';
import 'package:se_frontend/files/issueClass.dart';

class IssueDetail extends StatelessWidget {
  final Issue issue;

  const IssueDetail({super.key, required this.issue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(issue.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DetailBox(
              item: 'Description',
              content: issue.description ?? 'No description',
            ),
            DetailBox(
              item: 'Status',
              content: issue.status,
            ),
            DetailBox(
              item: 'Priority',
              content: issue.priority ?? 'No priority',
            ),
            DetailBox(
              item: 'Fixer',
              content: issue.fixer ?? 'No fixer',
            ),
            DetailBox(
              item: 'Assignee',
              content: issue.assignee,
            ),
            // Add more DetailBox widgets as needed
          ],
        ),
      ),
    );
  }
}
