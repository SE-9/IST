import 'package:flutter/material.dart';

class DetailBox extends StatelessWidget {
  final String item;
  final String content;

  final greybackground = const Color(0xff3E3E3E);

  const DetailBox({
    super.key,
    required this.item,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          item,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: greybackground,
            borderRadius: BorderRadius.circular(15.0), // 원하는 둥근 모서리 반경 설정
          ),
          padding: const EdgeInsets.all(20.0), // 내용과의 간격을 위한 패딩 설정 (선택 사항)
          child: Column(
            children: [
              Text(
                content,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
