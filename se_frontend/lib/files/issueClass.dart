// issueClass.dart
class Issue {
  final String title;
  final String assignee;
  final String reporter;
  final String status;
  final int commentCount;

  Issue({
    required this.title,
    required this.assignee,
    required this.reporter,
    required this.status,
    required this.commentCount,
  });
}
