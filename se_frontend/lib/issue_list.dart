import 'package:flutter/material.dart';
import 'package:se_frontend/files/issueClass.dart';
import 'issue_input_field.dart';
import 'widgets/issue_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<void> _fetchIssues() async {
    final userId = 'your_user_id'; // 실제 사용자 ID로 변경하세요
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8081/issue/my/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // API 응답 상태 코드 출력
      print('HTTP response status from issue list: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> issueJson = json.decode(response.body);

        // API 응답 내용 출력
        print('HTTP response body: ${response.body}');

        if (issueJson.isEmpty) {
          print('No issues found for user ID: $userId');
        } else {
          print('Fetched issues: $issueJson');
        }
        setState(() {
          issues = issueJson.map((json) => Issue.fromJson(json)).toList();
          filteredIssues = issues;
        });
      } else {
        throw Exception(
            'Failed to load issues. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching issues: $e');
    }
  }

  void _filterIssues(String query) {
    final filtered = issues.where((issue) {
      final matchesTitle =
          issue.title.toLowerCase().contains(query.toLowerCase());
      final matchesReporter =
          issue.reporterNickname.toLowerCase().contains(query.toLowerCase());
      final matchesAssignee =
          issue.assigneeNickname.toLowerCase().contains(query.toLowerCase());
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
                    'NEW',
                    'ASSIGNED',
                    'FIXED',
                    'RESOLVED',
                    'CLOSED',
                    'REOPENED'
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
                  reporter: issue.reporterNickname,
                  assignee: issue.assigneeNickname.isNotEmpty
                      ? issue.assigneeNickname
                      : 'Unassigned',
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
