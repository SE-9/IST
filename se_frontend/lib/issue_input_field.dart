import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class IssueInputField extends StatefulWidget {
  final bool isPL;

  const IssueInputField({super.key, required this.isPL});

  @override
  IssueInputFieldState createState() => IssueInputFieldState();
}

class IssueInputFieldState extends State<IssueInputField> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();
  final TextEditingController _assigneeController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final String title = _titleController.text;
      final String description = _descriptionController.text;
      final String? priority =
          _priorityController.text.isNotEmpty ? _priorityController.text : null;
      final String? assignee =
          widget.isPL && _assigneeController.text.isNotEmpty
              ? _assigneeController.text
              : null;
      const String reporter = 'system_user'; // 시스템이 자동으로 채워줌
      final String reportedDate =
          DateFormat('yyyy-MM-dd').format(DateTime.now()); // 현재 날짜

      final issueData = {
        'title': title,
        'description': description,
        'priority': priority,
        'assignee': assignee,
        'reporter': reporter,
        'reportedDate': reportedDate,
      };

      // 서버에 데이터 전송
      final response = await http.post(
        Uri.parse('https://yourapiendpoint.com/issues'), // 서버의 엔드포인트 URL로 변경
        headers: {'Content-Type': 'application/json'},
        body: json.encode(issueData),
      );

      if (response.statusCode == 200) {
        // 서버에 데이터가 정상적으로 저장된 경우
        print('Issue registered successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Issue registered successfully')),
        );
        // 폼 초기화
        _formKey.currentState!.reset();
      } else {
        // 서버에 데이터 저장 실패한 경우
        print('Failed to register issue');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to register issue')),
        );
      }
    }
  }

  final double blank = 30;
  final Color inputField = const Color(0xff3E3E3E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Issue',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Title',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                // title 입력
                controller: _titleController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: inputField,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0), // 모서리 둥글게
                    borderSide: BorderSide.none, // 테두리 없음
                  ), // 힌트 텍스트 색상
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: blank,
              ),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                // description 입력
                controller: _descriptionController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: inputField,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0), // 모서리 둥글게
                    borderSide: BorderSide.none, // 테두리 없음
                  ), // 힌트 텍스트 색상
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: blank,
              ),
              const Text(
                'Priority (Optional)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                //  priority 입력
                controller: _priorityController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: inputField,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0), // 모서리 둥글게
                    borderSide: BorderSide.none, // 테두리 없음
                  ), // 힌트 텍스트 색상
                ),
                style: const TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: blank,
              ),
              const Text(
                'Assignee (Optional for PL)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (widget.isPL)
                TextFormField(
                  // assignee 입력
                  controller: _assigneeController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: inputField,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0), // 모서리 둥글게
                      borderSide: BorderSide.none, // 테두리 없음
                    ), // 힌트 텍스트 색상
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              SizedBox(height: blank),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Register Issue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
