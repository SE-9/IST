import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:se_frontend/create_project.dart';
import 'package:se_frontend/files/issueClass.dart';
import 'package:se_frontend/files/projectClass.dart';
import 'package:se_frontend/box/issueBox.dart';
import 'package:se_frontend/box/projectBox.dart';
import 'package:se_frontend/issue_list.dart';
import 'package:http/http.dart' as http;

Future<List<Project>> fetchProjects(int userId) async {
  try {
    final response = await http.get(
      Uri.parse('http://localhost:8081/project/my/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    //print('HTTP response status: ${response.statusCode}');
    //print('HTTP response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> projectJson =
          json.decode(response.body) as List<dynamic>;
      print('Decoded JSON length: ${projectJson.length}'); // 리스트 길이 출력
      if (projectJson.isEmpty) {
        print('No projects found in the database for user: $userId');
      }

      return projectJson.map((json) {
        try {
          print('Project JSON: $json\n');
          return Project.fromJson(json as Map<String, dynamic>);
        } catch (e) {
          print('Error parsing project JSON: $e\n');
          print('Invalid Project JSON: $json\n'); // 잘못된 JSON 데이터 출력
          throw Exception('Error parsing project JSON: $e');
        }
      }).toList();
    } else {
      throw Exception('Failed to load projects');
    }
  } catch (e) {
    throw Exception('Error fetching projects: $e');
  }
}

// 백엔드에서 이슈 리스트를 받아오는 함수
Future<List<Issue>> fetchIssues(int userId) async {
  try {
    final response = await http.get(
      Uri.parse('http://localhost:8081/issue/my/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print('HTTP response status: ${response.statusCode}');
    print('HTTP response body: ${response.body}');

    if (response.statusCode == 200) {
      // JSON 응답을 파싱하여 이슈 리스트로 변환
      final List<dynamic> jsonResponse =
          json.decode(response.body) as List<dynamic>;
      print('Decoded JSON length: ${jsonResponse.length}'); // 리스트 길이 출력
      if (jsonResponse.isEmpty) {
        print('No issues found in the database for user: $userId');
      }

      return jsonResponse.map((issueJson) {
        try {
          print('Issue JSON: $issueJson\n');
          return Issue.fromJson(issueJson as Map<String, dynamic>);
        } catch (e) {
          print('Error parsing issue JSON: $e\n');
          print('Invalid Issue JSON: $issueJson\n'); // 잘못된 JSON 데이터 출력
          throw Exception('Error parsing issue JSON: $e');
        }
      }).toList();
    } else {
      throw Exception('Failed to load issues');
    }
  } catch (e) {
    throw Exception('Error fetching issues: $e');
  }
}

class MyDashboard extends StatefulWidget {
  final int userId;
  const MyDashboard({super.key, required this.userId});

  @override
  _MyDashboardState createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {
  late Future<List<Project>> _projectsFuture;
  late Future<List<Issue>> _issuesFuture;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    setState(() {
      _projectsFuture = fetchProjects(widget.userId);
      _issuesFuture = fetchIssues(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            title: Row(
              children: <Widget>[
                const Text(
                  'MY DASHBOARD ',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(
                  child: TextButton(
                    // 이슈 검색 버튼
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      backgroundColor: const Color.fromARGB(255, 241, 241, 241),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                IssueListPage(userId: widget.userId //
                                    )), // userId
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '찾으시는 이슈를 검색해보세요!',
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                        Icon(Icons.search, color: Colors.black),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (widget.userId == 1)
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CreateProject(userId: widget.userId),
                            ));
                      },
                      child: const Text('Create Project'),
                    ),
                  const SizedBox(height: 10),
                  const Text('MY PROJECTS',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      )),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: const Color.fromARGB(255, 146, 146, 146),
                    ),
                    height: 230,
                    width: double.infinity,
                    child: FutureBuilder<List<Project>>(
                      future: _projectsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          print('Snapshot error: ${snapshot.error}');
                          return Center(
                            child: Text(
                                'Error loading projects: ${snapshot.error}'),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(child: Text('No projects found'));
                        }
                        final projects = snapshot.data!;
                        return Scrollbar(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: projects.map((project) {
                                print(
                                    'Project title: ${project.title}'); // 디버깅 메시지
                                return ProjectBox(
                                    project: project, userId: widget.userId);
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'MY ISSUES',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: const Color.fromARGB(255, 146, 146, 146),
                    ),
                    height: 230,
                    width: double.infinity,
                    child: FutureBuilder<List<Issue>>(
                      future: fetchIssues(widget.userId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text('Error loading issues'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(child: Text('No issues found'));
                        }

                        final issues = snapshot.data!;
                        return Scrollbar(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: issues.map((issue) {
                                return IssueBox(
                                  issue: issue,
                                  userId: widget.userId,
                                ); //류: 여기도 닉네임 나중에 뺴야함, 소 : userId로 이름 변경
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
