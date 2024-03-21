class MessageModel {
  String? messageId;
  String? senderId;
  String? content;
  List<String>? recipients;
  List<String>? attachementUrl;
  DateTime? sentAt;

  MessageModel({
    required this.messageId,
    required this.senderId,
    required this.content,
    required this.recipients,
    this.attachementUrl,
    required this.sentAt,
  });

  MessageModel.fromJson(Map<String, dynamic> json){
    messageId = json['messageId'];
    senderId = json['senderId'];
    content = json['content'];
    recipients = json['recipients'];
    attachementUrl = json['attachementUrl'];
    sentAt = json['sentAt'];
  }
}