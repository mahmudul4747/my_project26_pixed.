class DashboardModel {
  final int id;
  final String title;
  final bool completed;

  DashboardModel({
    required this.id,
    required this.title,
    required this.completed,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      completed: json['completed'] ?? false,
    );
  }
}