class AnnouncementModel {
  final String caption;
  final String op;
  final String opDesignation;
  final String date;
  final String place;
  final String image;
  final String description;

  AnnouncementModel({
    required this.caption,
    required this.op,
    required this.opDesignation,
    required this.date,
    required this.place,
    required this.image,
    required this.description,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      caption: json['caption'] ?? '',
      op: json['op'] ?? '',
      opDesignation: json['op_designation'] ?? '',
      date: json['date'] ?? '',
      place: json['place'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'caption': caption,
      'op': op,
      'op_designation': opDesignation,
      'date': date,
      'place': place,
      'image': image,
      'description': description,
    };
  }

  /// Generate 5 temporary announcements
  static List<AnnouncementModel> tempData() {
    return [
      AnnouncementModel(
        caption: "Announcement",
        op: "Pooja Wadhwani",
        opDesignation: "Head of HR",
        date: "16/10/2025",
        place: "Office - Bangalore",
        image: "assets/images/common/news1.jpg",
        description:
            "Notice of position for “Marsha Leanetha” promoted from Jr. Backend Developer to Sr. Backend Developer.",
      ),
      AnnouncementModel(
        caption: "Holiday Notice",
        op: "Admin Office",
        opDesignation: "Administration",
        date: "02/11/2025",
        place: "All Offices",
        image: "assets/images/common/bday2.jpg",
        description: "Diwali holidays announced from 2nd Nov to 5th Nov.",
      ),
      AnnouncementModel(
        caption: "Team Outing",
        op: "Rajesh Kumar",
        opDesignation: "Project Manager",
        date: "22/11/2025",
        place: "Wonderla, Bangalore",
        image: "assets/images/common/bday1.jpg",
        description: "Annual team outing planned, attendance is mandatory.",
      ),
      AnnouncementModel(
        caption: "New Policy",
        op: "Shreya Menon",
        opDesignation: "HR Manager",
        date: "05/12/2025",
        place: "Office - Mumbai",
        image: "assets/images/common/news2.jpg",
        description:
            "Introduction of new work-from-home policy effective from December.",
      ),
      AnnouncementModel(
        caption: "Farewell",
        op: "Sandeep R",
        opDesignation: "CTO",
        date: "15/12/2025",
        place: "Office - Bangalore",
        image: "assets/images/common/wrk_ann2.jpg",
        description: "Farewell to Mr. Ramesh Kumar after 10 years of service.",
      ),
    ];
  }
}
