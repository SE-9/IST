import 'package:flutter/material.dart';
import 'package:se_frontend/issue_list.dart';
import 'package:se_frontend/project.dart';

// 프로젝트 fetch
Future<List<Project>> fetchProjects() async {
  await Future.delayed(const Duration(seconds: 1)); //네트워크 딜레이 효과..ㅎ
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
  await Future.delayed(const Duration(seconds: 1));
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

//프로젝트 클래스 정의
class Project {
  final String title;
  final String description;

  Project({required this.title, required this.description});
}

//이슈 클래스 정의
class Issue {
  final String title;
  final String assignee;
  final String reporter;
  final String status;

  Issue({
    required this.title,
    required this.assignee,
    required this.reporter,
    required this.status,
  });
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
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: ' 찾으시는 이슈를 검색해보세요! ',
                      hintStyle: const TextStyle(fontSize: 12), // 힌트 텍스트
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 241, 241, 241),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 0),
                      suffixIcon: const Icon(Icons.search), // 검색 아이콘
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
          ),
          // 소영언니가 만든 부분으로 이동
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IssueListPage(),
                    ),
                  );
                },
                child: const Text('소영언니 이거 누르면됩니당'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 박스로 플젝표현
class ProjectBox extends StatelessWidget {
  final String title; // 제목 저장 변수
  final String description; // 설명 저장 변수
  final String leader;

  const ProjectBox({
    required this.title,
    required this.description,
    required this.leader,
  }); // 생성자로 title과 description을 받아옴

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 누르면 프로젝트 페이지로 이동하게 제스쳐
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProjectPage(
              title: title,
              description: description,
              leader: leader,
            ),
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
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(description),
          ],
        ),
      ),
    );
  }
}

//박스로 이슈 표현
class IssueBox extends StatelessWidget {
  final String title; // 제목 저장 변수
  final String assignee;
  final String reporter;
  final String status;

  const IssueBox({
    required this.title,
    required this.assignee,
    required this.reporter,
    required this.status,
  }); // 생성자로 title과 description을 받아옴

  @override
  Widget build(BuildContext context) {
    return Container(
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
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(status),
          const SizedBox(height: 10),
          Text(assignee),
          Text(reporter),
        ],
      ),
    );
  }
}
