class FirebaseMessageModel {
  String title;
  String body;
  String type;
  DateTime timestamp;

  FirebaseMessageModel.fromJson(Map json)
      : title = json['notify_title'].toString(),
        body = json['notify_body'].toString(),
        type = json['type'] ?? "default",
        timestamp =
            DateTime.tryParse(json['timestamp'] ?? "") ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'notify_title': title,
        'notify_body': body,
        'type': type,
        'timestamp': timestamp.toIso8601String(),
      };

  FirebaseMessageModel(this.title, this.body, this.type, this.timestamp);
}
