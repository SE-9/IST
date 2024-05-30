import 'package:flutter/material.dart';
import 'package:se_frontend/issue_list.dart';

// 개별 프로젝트 페이지
class ProjectPage extends StatelessWidget {
  final String title;
  final String description;
  final String leader;

  const ProjectPage({
    required this.title,
    required this.description,
    required this.leader,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; //넓이
    double screenHeight = MediaQuery.of(context).size.height; //높이 가져옴

    // 화면 크기에 따라 폰트 크기와 패딩을 동적으로 설정

    double fontSize = screenWidth < 850 ? 18 : 18;
    double formFieldWidth =
        screenWidth < 800 ? screenWidth * 0.8 : screenWidth * 0.3;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 244, 244, 244),
          title: const Row(children: [
            Text(
              "MY PROJECT",
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
                      MaterialPageRoute(builder: (context) => IssueListPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 255, 205, 220),
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
            )
          ],
        ),
      ),
    );
  }
}
