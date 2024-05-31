import 'package:flutter/material.dart';

enum IPriority { BLOCKER, CRITICAL, MAJOR, MINOR, TRIVIAL }

enum IState { NEW, ASSIGNED, FIXED, RESOLVED, CLOSED, REOPENED }

class Issue {
  int id;
  String title;
  String description;
  int reporter;
  DateTime date;
  IPriority priority;
  int projectId;
  int? fixer;
  int? assignee;
  IState state;
  String reporterNickname;
  String assigneeNickname;

  Issue({
    required this.id,
    required this.title,
    required this.description,
    required this.reporter,
    required this.date,
    required this.priority,
    required this.projectId,
    this.fixer,
    this.assignee,
    this.state = IState.NEW,
    required this.reporterNickname,
    required this.assigneeNickname,
  });

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      id: json['responseIssue']['id'] ?? 0,
      title: json['responseIssue']['title'] ?? '',
      description: json['responseIssue']['description'] ?? '',
      reporter: json['responseIssue']['reporter_id'] ?? 0,
      date: DateTime.tryParse(json['responseIssue']['date'] ?? '') ??
          DateTime.now(),
      priority: IPriority.values.firstWhere(
          (e) =>
              e.toString() == 'IPriority.${json['responseIssue']['priority']}',
          orElse: () => IPriority.TRIVIAL),
      projectId: json['responseIssue']['project_id'] ?? 0,
      fixer: json['responseIssue']['fixer_id'],
      assignee: json['responseIssue']['assignee_id'],
      state: IState.values.firstWhere(
          (e) => e.toString() == 'IState.${json['responseIssue']['state']}',
          orElse: () => IState.NEW),
      reporterNickname: json['reporter_nickname'] ?? '',
      assigneeNickname: json['assignee_nickname'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'reporter': reporter,
      'date': date.toIso8601String(),
      'priority': priority.index,
      'project_id': projectId,
      'fixer': fixer,
      'assignee': assignee,
      'state': state.index,
      'reporter_nickname': reporterNickname,
      'assignee_nickname': assigneeNickname,
    };
  }
}
