class FirebaseMessageModel {
  String title;
  String body;
  String type;
  DateTime timestamp;

  Map<String, dynamic> raw;

  FirebaseMessageModel.fromJson(Map json)
      : title = json['notify_title'] ?? "",
        body = json['notify_body'] ?? "",
        type = json['type'] ?? "default",
        timestamp =
            DateTime.tryParse(json['timestamp'] ?? "") ?? DateTime.now(),
        raw = Map<String, dynamic>.from(json);

  Map<String, dynamic> toJson() => raw;

  FirebaseMessageModel(this.title, this.body, this.type, this.timestamp)
      : raw = {
          "notify_title": title,
          "notify_body": body,
          "type": type,
          "timestamp": timestamp.toIso8601String(),
        };
}
