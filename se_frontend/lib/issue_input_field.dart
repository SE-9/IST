import 'dart:convert';
import 'dart:math';
import 'package:se_frontend/files/issueClass.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:se_frontend/myDashBoard.dart';
import 'package:se_frontend/issue_detail.dart';

class IssueInputField extends StatefulWidget {
  final int projectId;
  final String reporterNickname; // 수정이한테 받아야 함.

  const IssueInputField({
    super.key,
    required this.projectId,
    required this.reporterNickname,
  });

  @override
  _IssueInputFieldState createState() => _IssueInputFieldState();
}

class _IssueInputFieldState extends State<IssueInputField> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  IPriority? _selectedPriority; // 우선 순위에 대한 열거형 타입 사용

  Future<void> _submitForm() async {
    //류: 여기 코드 자체가 유효한지 확인하고 유효하면 아래 데이터를 서버에 전송하는거같음 ..?
    if (_formKey.currentState!.validate()) {
      final String title = _titleController.text;
      final String description = _descriptionController.text;
      final String priority =
          _selectedPriority?.toString().split('.').last ?? '';

      final issueData = {
        'title': title,
        'description': description,
        'priority': priority,
        'reporter_id': widget.reporterNickname, // 류: 리포터 아이디도 잘받게 수정해써용
        'project_id': widget.projectId, // 류: 여기 프로젝트 아이디 잘받게 수정
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
                      builder: (context) => MyDashboard(
                            userId: widget.reporterNickname, //류 : 닉네임 전달
                          )),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Issue')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors
                      .grey, //류: 여기 색상 표시하려던건가요?? 원래 fillColor : inputField로 되어있었음
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
              SizedBox(height: 16),
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
                  fillColor: Colors
                      .grey, //류: 여기 색상 표시하려던건가요?? 원래 fillColor : inputField로 되어있었음
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
              SizedBox(height: 16),
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
              SizedBox(height: 16),
              ElevatedButton(
                onPressed:
                    _submitForm, //류: 아래 코드 삭제하고 submit from 함수 호출하면 서버로 전송되지 않나용?
                /*if (_formKey.currentState!.validate()) { 
                    _formKey.currentState!.save();
                    _createIssue();*
                  }*/
                child: const Text('Create Issue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
