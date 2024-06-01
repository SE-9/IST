import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:se_frontend/files/issueClass.dart';
import 'package:se_frontend/myDashBoard.dart';

class IssueInputField extends StatefulWidget {
  final int projectId;
  final String reporterNickname;

  const IssueInputField({
    super.key,
    required this.projectId,
    required this.reporterNickname,
  });

  @override
  IssueInputFieldState createState() => IssueInputFieldState();
}

class IssueInputFieldState extends State<IssueInputField> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  IPriority? _selectedPriority;

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
        'reporter_id': widget.reporterNickname, // String, nickname
        'project_id': widget.projectId, // int, ID
      };

      try {
        final response = await http.post(
          Uri.parse('http://localhost:8081/project/issue/create'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(issueData),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Issue 등록 성공'),
              duration: const Duration(seconds: 2),
              onVisible: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MyDashboard(userId: widget.reporterNickname),
                  ),
                );
              },
            ),
          );
          _formKey.currentState!.reset();
        } else {
          print('Issue 등록 실패');
          print('Response status: ${response.statusCode}');
          print('Response body: ${response.body}');
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
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Text fields and dropdowns for issue creation form
            ],
          ),
        ),
      ),
    );
  }
}
