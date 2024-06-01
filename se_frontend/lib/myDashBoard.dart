import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:se_frontend/create_project.dart';
import 'package:se_frontend/files/issueClass.dart';
import 'package:se_frontend/files/projectClass.dart';
import 'package:se_frontend/box/issueBox.dart';
import 'package:se_frontend/box/projectBox.dart';
import 'package:se_frontend/issue_list.dart';
import 'package:http/http.dart' as http;

Future<List<Project>> fetchProjects(String userId) async {
  //주어진 유저 아이디로 프로젝트 가져오기

  try {
    //예외처리
    final response = await http.get(
      Uri.parse('http://localhost:8081/project/my/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print('HTTP response status: ${response.statusCode}');
    print('HTTP response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> projectJson = json.decode(response.body);
      if (projectJson.isEmpty) {
        print('No projects found in the database for user: $userId');
      }
      return projectJson.map((json) {
        //프로젝트 JSON을 프로젝트로 변환
        try {
          print('Project JSON: $json'); // 디버깅 메시지
          return Project.fromJson(json);
        } catch (e) {
          print('Error parsing project JSON: $e');
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

// 이슈 fetch
Future<List<Issue>> fetchIssues(String userId) async {
  final response = await http.get(
    Uri.parse('http://localhost:8081/issue/my/$userId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> issueJson =
        json.decode(response.body); // JSON 데이터를 Issue 객체로 변환하여 리스트로 반환
    return issueJson.map((json) => Issue.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load issues');
  }
}

class MyDashboard extends StatelessWidget {
  final String userId;
  const MyDashboard({super.key, required this.userId});

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
                            builder: (context) => IssueListPage(
                                userNickname: userId)), // userNickname임
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
                  if (userId == '1')
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CreateProject(userId: userId),
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
                      future: fetchProjects(userId),
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
                                    project: project, userId: userId);
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
                      future: fetchIssues(userId),
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
                                    issue: issue, userNickname: userId);
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
