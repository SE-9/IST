import 'package:flutter/material.dart';
import 'issue_input_field.dart';
import 'widgets/issue_card.dart';
import 'package:se_frontend/files/issueClass.dart';

class IssueListPage extends StatefulWidget {
  const IssueListPage({super.key});

  @override
  IssueListPageState createState() => IssueListPageState();
}

class IssueListPageState extends State<IssueListPage> {
  List<Issue> issues = [
    // 백이랑 상의 필요.
    Issue(
        title: 'Issue 1',
        status: 'New',
        reporter: 'User1',
        assignee: 'User2',
        commentCount: 5),
    Issue(
        title: 'Issue 2',
        status: 'Closed',
        reporter: 'User3',
        assignee: 'User4',
        commentCount: 2),
    Issue(
        title: 'Issue 3',
        status: 'Closed',
        reporter: 'User5',
        assignee: 'User6',
        commentCount: 4),
  ];

  List<Issue> filteredIssues = [];
  String selectedStatus = 'All'; // 현재 선택된 상태를 저장

  @override
  void initState() {
    super.initState();
    filteredIssues = issues;
  }

  void _filterIssues(String query) {
    final filtered = issues.where((issue) {
      final matchesTitle =
          issue.title.toLowerCase().contains(query.toLowerCase());
      final matchesReporter =
          issue.reporter.toLowerCase().contains(query.toLowerCase());
      final matchesAssignee =
          issue.assignee.toLowerCase().contains(query.toLowerCase());
      final matchesStatus =
          selectedStatus == 'All' || issue.status == selectedStatus;
      return (matchesTitle || matchesReporter || matchesAssignee) &&
          matchesStatus;
    }).toList();

    setState(() {
      filteredIssues = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 150),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: '찾으시려는 이슈를 입력하세요!',
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onChanged: _filterIssues,
                  ),
                ),
                const SizedBox(width: 20),
                DropdownButton<String>(
                  value: selectedStatus,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedStatus = newValue!;
                      _filterIssues('');
                    });
                  },
                  items: <String>[
                    'All',
                    'New',
                    'Assigned',
                    'Fixed',
                    'Resolved',
                    'Closed',
                    'Reopened'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredIssues.length,
              itemBuilder: (context, index) {
                final issue = filteredIssues[index];
                return IssueCard(
                  title: issue.title,
                  status: issue.status,
                  reporter: issue.reporter,
                  assignee: issue.assignee,
                  commentCount: issue.commentCount,
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const IssueInputField(isPL: true)),
              );
            },
            child: const Text('이슈 등록'),
          ),
        ],
      ),
    );
  }
}
