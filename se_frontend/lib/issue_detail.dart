import 'package:flutter/material.dart';
import 'package:se_frontend/files/issueClass.dart';
import 'package:se_frontend/widgets/detail_box.dart';

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
              content: issue.description,
            ),
            DetailBox(
              item: 'Status',
              content: issue.state.toString().split('.').last,
            ),
            DetailBox(
              item: 'Priority',
              content: issue.priority.toString().split('.').last,
            ),
            DetailBox(
              item: 'Fixer',
              content: issue.fixer?.toString() ?? 'Unassigned',
            ),
            DetailBox(
              item: 'Assignee',
              content: issue.assignee?.toString() ?? 'Unassigned',
            ),
            // Add more DetailBox widgets as needed
          ],
        ),
      ),
    );
  }
}
