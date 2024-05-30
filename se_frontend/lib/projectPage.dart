import 'package:flutter/material.dart';
import 'package:se_frontend/box/issueBox.dart';
import 'package:se_frontend/files/issueClass.dart';
import 'package:se_frontend/issue_input_field.dart';

// 개별 프로젝트 페이지
class ProjectPage extends StatelessWidget {
  final String title;
  final String description;
  final String leader;

  const ProjectPage({
    super.key,
    required this.title,
    required this.description,
    required this.leader,
  });

// 이슈 fetch
  Future<List<Issue>> fetchIssues() async {
    return List.generate(
      9,
      (index) => Issue(
        title: 'Issue ${index + 1}',
        assignee: 'Assignee ${index + 1}',
        reporter: 'Reporter ${index + 1}',
        status: 'new',
        commentCount: 2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; //넓이

    // 화면 크기에 따라 폰트 크기와 패딩을 동적으로 설정

    double fontSize = screenWidth < 850 ? 18 : 18;
    double formFieldWidth =
        screenWidth < 800 ? screenWidth * 0.8 : screenWidth * 0.3;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          title: const Row(children: [
            Text(
              "MY PROJECT",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            )
          ]),
          titleSpacing: 20),
      body: SingleChildScrollView(
        //프로젝트 제목 표시
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 20),
            //*************** 설명란  */
            const Text(
              "Description",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Container(
              constraints: const BoxConstraints(minHeight: 50),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: const Color.fromARGB(255, 37, 37, 37),
              ),
              alignment: Alignment.center,
              child: Text(
                description,
                style: const TextStyle(
                    fontSize: 16, color: Color.fromARGB(199, 255, 255, 255)),
              ),
            ), //************************리더란 */
            const SizedBox(height: 20),
            const Text(
              "Leader",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Container(
              constraints: const BoxConstraints(minHeight: 50),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: const Color.fromARGB(255, 37, 37, 37),
              ),
              alignment: Alignment.center,
              child: Text(
                leader,
                style: const TextStyle(
                    fontSize: 16, color: Color.fromARGB(199, 255, 255, 255)),
              ),
            ),
            //************************* 이슈 생성란 이동버튼 */

            const SizedBox(height: 50),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: formFieldWidth,
                height: 70,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const IssueInputField(
                                isPL: true, // isPL 처리 필요.
                              )),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 205, 220),
                      fixedSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: Text(
                    'Click here to\ncreate Issue',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: fontSize * 0.8,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            //************************** 플젝에 대한 이슈 보기란 */
            const SizedBox(height: 30),
            const Text(
              "Current Issue",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading issues'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
    );
  }
}
