import 'package:flutter/material.dart';
import 'package:se_frontend/issue_list.dart';

// 개별 프로젝트 페이지
class IssuePage extends StatelessWidget {
  final String title; // 제목 저장 변수
  final String description;
  final String assignee;
  final String reporter;
  final String status;

  const IssuePage({
    super.key,
    required this.title,
    required this.description,
    required this.assignee,
    required this.reporter,
    required this.status,
    required leader,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; //넓이

    // 화면 크기에 따라 폰트 크기와 패딩을 동적으로 설정

    double fontSize = screenWidth < 850 ? 18 : 18;
    double formFieldWidth =
        screenWidth < 800 ? screenWidth * 0.8 : screenWidth * 0.3;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 244, 244, 244),
          title: const Row(children: [
            Text(
              "MY ISSUE",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            )
          ]),
          titleSpacing: 20),
      body: Padding(
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
              "assignee",
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
                assignee,
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
                          builder: (context) => const IssueListPage()),
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
          ],
        ),
      ),
    );
  }
}
