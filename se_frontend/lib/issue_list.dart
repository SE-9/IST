import 'package:flutter/material.dart';
import 'issue_input_field.dart';
import 'widgets/issue_card.dart';
import 'package:se_frontend/files/issueClass.dart'; // 필요한 파일 경로에 맞게 수정하세요

class IssueListPage extends StatefulWidget {
  const IssueListPage({super.key});

  @override
  IssueListPageState createState() => IssueListPageState();
}

class IssueListPageState extends State<IssueListPage> {
  List<Issue> issues = [];
  List<Issue> filteredIssues = [];
  String selectedStatus = 'All'; // 현재 선택된 상태를 저장

  @override
  void initState() {
    super.initState();
    _fetchIssues();
  }

  void _fetchIssues() async {
    // 여기서 백엔드에서 데이터를 가져오는 로직을 구현하세요.
    // 예를 들어, API 요청을 통해 데이터를 받아올 수 있습니다.
    // 받아온 데이터를 issues 리스트에 저장하고, 초기 필터링을 수행합니다.
    setState(() {
      issues = [
        Issue(
          id: 1,
          title: 'Issue 1',
          description: 'Description for Issue 1',
          reporter: 1,
          date: DateTime.now(),
          priority: IPriority.MAJOR,
          projectId: 101,
          fixer: 2,
          assignee: 3,
          state: IState.NEW,
        ),
        Issue(
          id: 2,
          title: 'Issue 2',
          description: 'Description for Issue 2',
          reporter: 2,
          date: DateTime.now(),
          priority: IPriority.MINOR,
          projectId: 102,
          fixer: 3,
          assignee: 4,
          state: IState.RESOLVED,
        ),
        // 추가로 더 많은 이슈를 여기에 추가하세요.
      ];
      filteredIssues = issues;
    });
  }

  void _filterIssues(String query) {
    final filtered = issues.where((issue) {
      final matchesTitle =
          issue.title.toLowerCase().contains(query.toLowerCase());
      final matchesReporter = issue.reporter.toString().contains(query);
      final matchesAssignee =
          issue.assignee?.toString().contains(query) ?? false;
      final matchesStatus = selectedStatus == 'All' ||
          issue.state.toString().split('.').last == selectedStatus;
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
                    'OPEN',
                    'IN_PROGRESS',
                    'RESOLVED',
                    'CLOSED'
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
                  status: issue.state.toString().split('.').last,
                  reporter: issue.reporter.toString(),
                  assignee: issue.assignee?.toString() ?? 'Unassigned',
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
