class FirebaseMessageModel {
  String title;
  String body;
  String type;
  DateTime timestamp;
  bool isOpened;

  Map<String, dynamic> raw;
  
  FirebaseMessageModel.fromJson(Map json)
      : title = json['notify_title'] ?? "",
        body = json['notify_body'] ?? "",
        type = json['type'] ?? "default",
        timestamp =
            DateTime.tryParse(json['timestamp'] ?? "") ?? DateTime.now(),
        isOpened = (json["is_opened"] is bool) ? json["is_opened"] : false,
        raw = Map<String, dynamic>.from(json) {
    raw["timestamp"] = timestamp.toIso8601String();
    raw["is_opened"] = isOpened;
  }

  Map<String, dynamic> toJson() {
    raw["notify_title"] = title;
    raw["notify_body"] = body;
    raw["type"] = type;
    raw["timestamp"] = timestamp.toIso8601String();
    raw["is_opened"] = isOpened;
    return raw;
  }

  FirebaseMessageModel(
      this.title, this.body, this.type, this.timestamp, this.isOpened)
      : raw = {
          "notify_title": title,
          "notify_body": body,
          "type": type,
          "timestamp": timestamp.toIso8601String(),
          "is_opened": isOpened,
        };
}
