import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddMember extends StatefulWidget {
  final int projectId;

  const AddMember({Key? key, required this.projectId}) : super(key: key);

  @override
  _AddMemberState createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  final TextEditingController _nicknameController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _checkAndAddMember() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final nickname = _nicknameController.text;

    try {
      // 닉네임으로 사용자 ID를 가져오는 API 호출
      final response = await http.get(
        Uri.parse('http://localhost:8081/user/$nickname'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final int? userId = int.tryParse(response.body);

        if (userId != null) {
          // 프로젝트에 멤버를 추가하는 API 호출
          final addMemberResponse = await http.post(
            Uri.parse(
                'http://localhost:8081/project/${widget.projectId}/invite/$userId'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
          );

          if (addMemberResponse.statusCode == 200) {
            Navigator.pop(context, true); // 성공적으로 추가되면 이전 화면으로 이동하며 true 반환
          } else {
            setState(() {
              _errorMessage =
                  'Failed to add member: ${addMemberResponse.statusCode} ${addMemberResponse.body}';
            });
          }
        } else {
          setState(() {
            _errorMessage = 'Invalid user ID format';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'User not found';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error adding member: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Member')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(labelText: 'Member Nickname'),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkAndAddMember,
              child: const Text('Add Member'),
            ),
          ],
        ),
      ),
    );
  }
}
