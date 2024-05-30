import 'package:flutter/material.dart';
import 'package:se_frontend/files/issueClass.dart';
import 'package:se_frontend/files/projectClass.dart';
import 'package:se_frontend/box/issueBox.dart';
import 'package:se_frontend/box/projectBox.dart';
import 'package:se_frontend/issue_list.dart';

// 프로젝트 fetch
Future<List<Project>> fetchProjects() async {
  return List.generate(
    //일단 20개 만듬
    20,
    (index) => Project(
      title: 'Project ${index + 1}',
      description: 'Description of project ${index + 1}',
    ),
  );
}

// 이슈 fetch
Future<List<Issue>> fetchIssues() async {
  return List.generate(
    9,
    (index) => Issue(
      title: 'Issue ${index + 1}',
      assignee: 'Assignee ${index + 1}',
      reporter: 'Reporter ${index + 1}',
      status: 'new',
    ),
  );
}

class MyDashboard extends StatelessWidget {
  const MyDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // 세로 배치
        children: [
          // 제목, 검색창
          AppBar(
            title: Row(
              children: <Widget>[
                const Text(
                  'MY DASHBOARD',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(
                  child: TextButton(
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
                            builder: (context) => const IssueListPage()),
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
          // 시작 부분
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                // 자식 왼쪽 정렬
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // 내 프로젝트 상자 ***************************
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
                    // 흰색 박스
                    height: 230,
                    width: double.infinity,
                    child: FutureBuilder<List<Project>>(
                      //
                      future: fetchProjects(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text('Error loading projects'));
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
                                return ProjectBox(
                                  title: project.title,
                                  description: project.description,
                                  leader: 'shu030929',
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  //내 이슈들 상자*******************************
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
                      future: fetchIssues(),
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
                                  title: issue.title,
                                  assignee: issue.assignee,
                                  reporter: issue.reporter,
                                  status: issue.status,
                                  description: '',
                                );
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
