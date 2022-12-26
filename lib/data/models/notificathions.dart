class NotificationsModel {
  final int id;
  final int userId;
  final String message;
  final DateTime date;

  NotificationsModel(
      {required this.id,
      required this.userId,
      required this.message,
      required this.date});

  NotificationsModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['userId'],
        message = json['message'],
        date = DateTime.parse(json['date']);
}
