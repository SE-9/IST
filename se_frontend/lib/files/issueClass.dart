enum IPriority { BLOCKER, CRITICAL, MAJOR, MINOR, TRIVIAL }

enum IState { NEW, ASSIGNED, FIXED, RESOLVED, CLOSED, REOPEND }

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
}
