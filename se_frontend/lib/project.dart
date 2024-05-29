import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 245, 245, 245),
          title: const Row(children: [
            Text(
              "MY PROJECT",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            )
          ]),
          titleSpacing: 20),
      body: Padding(
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
            const Text(
              "Description",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Color.fromARGB(255, 31, 31, 31),
              ),
              child: Text(
                description,
                style: const TextStyle(
                    fontSize: 16, color: Color.fromARGB(199, 255, 255, 255)),
              ),
            ),
            Text(
              leader,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
