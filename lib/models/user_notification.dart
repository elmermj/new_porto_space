class UserNotification {
  String? title;
  String? body;
  String? notificationId;
  String? timestamp;
  String? category;

  UserNotification({
    this.title,
    this.body,
    this.notificationId,
    this.timestamp,
    this.category,
  });

  UserNotification.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    notificationId = json['notificationId'];
    timestamp = json['timestamp'];
    category = json['category'];
  }
}