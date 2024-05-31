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
  });

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      reporter: json['reporter'] ?? 0,
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      priority: IPriority.values[json['priority'] ?? 0],
      projectId: json['project_id'] ?? 0,
      fixer: json['fixer'],
      assignee: json['assignee'],
      state: IState.values[json['state'] ?? 0],
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
    };
  }
}
