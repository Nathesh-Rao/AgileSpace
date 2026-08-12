class TaskAttachmentModel {
  final List<TaskAttachmentData> data;

  TaskAttachmentModel({required this.data});

  factory TaskAttachmentModel.fromJson(List<dynamic> json) {
    return TaskAttachmentModel(
      data: json.map((e) => TaskAttachmentData.fromJson(e)).toList(),
    );
  }

  List<Map<String, dynamic>> toJson() {
    return data.map((e) => e.toJson()).toList();
  }
}

class TaskAttachmentData {
  final String file;
  final String fileLink;

  TaskAttachmentData({
    required this.file,
    required this.fileLink,
  });

  factory TaskAttachmentData.fromJson(Map<String, dynamic> json) {
    return TaskAttachmentData(
      file: json['file'] ?? '',
      fileLink: json['file_link'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'file': file,
      'file_link': fileLink,
    };
  }
}
