import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:se_frontend/files/issueClass.dart';
import 'package:se_frontend/myDashBoard.dart';

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
  IPriority? _selectedPriority; // 우선 순위에 대한 열거형 타입 사용

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final String title = _titleController.text;
      final String description = _descriptionController.text;
      final String priority =
          _selectedPriority?.toString().split('.').last ?? '';

      final issueData = {
        'title': title,
        'description': description,
        'priority': priority,
        'reporter_id': 23,
        'pl_id': 123,
        'project_id': 1,
      };

      try {
        final response = await http.post(
          Uri.parse('http://localhost:8081/project/issue/create'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(issueData),
        );

        if (response.statusCode == 200) {
          print('Issue 등록 성공');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Issue 등록 성공'),
              duration: const Duration(seconds: 2),
              onVisible: () {
                // 스낵바가 보인 후 대시보드로 이동
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyDashboard(
                            nickname: '넘어가는 거 확인용.... 변경 필요',
                          )), // 'YourNickname'을 적절한 값으로 대체
                );
              },
            ),
          );
          _formKey.currentState!.reset();
        } else {
          print('Issue 등록 실패');
          print('Response status: ${response.statusCode}');
          print('Response body: ${response.body}');
          print('\n\n$title, $description, $priority');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Issue 등록 실패')),
          );
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
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
                controller: _titleController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: inputField,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: blank),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: inputField,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: blank),
              const Text(
                'Priority (Optional)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButton<IPriority>(
                value: _selectedPriority,
                onChanged: (IPriority? newValue) {
                  setState(() {
                    _selectedPriority = newValue;
                  });
                },
                items: IPriority.values.map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(priority.toString().split('.').last),
                  );
                }).toList(),
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
