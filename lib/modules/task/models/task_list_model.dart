class TaskListModel {
  String id;
  String status;
  String projectName;
  int attachmentCount;
  int messageCount;
  String caption;
  String description;
  DateTime dueDate;
  DateTime createdOn;
  String priority;
  String taskCategory;
  int participantCount;

  TaskListModel({
    required this.id,
    required this.status,
    required this.projectName,
    required this.attachmentCount,
    required this.messageCount,
    required this.caption,
    required this.description,
    required this.dueDate,
    required this.createdOn,
    required this.priority,
    required this.taskCategory,
    required this.participantCount,
  });

  factory TaskListModel.fromJson(Map<String, dynamic> json) => TaskListModel(
        id: json["id"] ?? "",
        status: json["status"] ?? "",
        projectName: json["project_name"] ?? "project-name",
        attachmentCount: json["attachment_count"] ?? 0,
        messageCount: json["message_count"] ?? 0,
        caption: json["caption"] ?? "",
        description: json["description"] ?? "",
        dueDate: DateTime.parse(json["due_date"] ?? DateTime.now().toString()),
        createdOn: DateTime.parse(json["createdon"] ?? DateTime.now().toString()),
        priority: json["priority"] ?? "",
        taskCategory: json["taskcategory"] ?? json["task_category"] ?? "",
        participantCount: json["participant_count"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "project_name": projectName,
        "attachment_count": attachmentCount,
        "message_count": messageCount,
        "caption": caption,
        "description": description,
        "due_date":
            "${dueDate.year.toString().padLeft(4, '0')}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}",
        "priority": priority,
        "taskcategory": taskCategory, // <- fixed
        "participant_count": participantCount,
      };

  static final tempList = tempJsonList.map((e) => TaskListModel.fromJson(e)).toList();

  static var tempJsonList = [
    {
      "id": "13434",
      "status": "pending",
      "project_name": "Axpert Dashboard",
      "attachment_count": 2,
      "message_count": 8,
      "caption": "Build header section",
      "description": "Create the top section with logo and user menu.",
      "due_date": "2025-07-28",
      "createdon": "2025-07-28",
      "priority": "high",
      "task_category": "UI/UX",
      "progress": 25,
      "participant_count": 3
    },
    {
      "id": "21343",
      "status": "in_progress",
      "project_name": "Auth API Integration",
      "attachment_count": 1,
      "message_count": 3,
      "caption": "Login/Logout",
      "description": "Integrate login and logout API with session management.",
      "due_date": "2025-07-29",
      "createdon": "2025-07-28",
      "priority": "medium",
      "task_category": "app-development",
      "progress": 40,
      "participant_count": 2
    },
    {
      "id": "32134",
      "status": "completed",
      "project_name": "Task Management",
      "attachment_count": 0,
      "message_count": 10,
      "caption": "Create task model",
      "description": "Define backend schema and frontend model class.",
      "due_date": "2025-07-30",
      "createdon": "2025-07-28",
      "priority": "low",
      "task_category": "API",
      "progress": 100,
      "participant_count": 1
    },
    {
      "id": "42134",
      "status": "pending",
      "project_name": "Notification Module",
      "attachment_count": 2,
      "message_count": 4,
      "caption": "Push setup",
      "description": "Enable push notifications for mobile app.",
      "due_date": "2025-07-31",
      "priority": "high",
      "createdon": "2025-07-28",
      "task_category": "app-development",
      "progress": 0,
      "participant_count": 2
    },
    {
      "id": "52134",
      "status": "in_progress",
      "project_name": "Analytics Setup",
      "attachment_count": 1,
      "message_count": 6,
      "caption": "Dashboard metrics",
      "description": "Add charts and data summaries in dashboard.",
      "due_date": "2025-08-01",
      "priority": "medium",
      "createdon": "2025-07-28",
      "task_category": "UI/UX",
      "progress": 55,
      "participant_count": 4
    },
    {
      "id": "65213",
      "status": "pending",
      "project_name": "User Profile",
      "attachment_count": 0,
      "message_count": 1,
      "caption": "Edit profile screen",
      "description": "Allow users to update name, avatar and email.",
      "due_date": "2025-08-02",
      "createdon": "2025-07-28",
      "priority": "low",
      "task_category": "UI/UX",
      "progress": 0,
      "participant_count": 2
    },
    {
      "id": "21347",
      "status": "in_progress",
      "project_name": "File Uploads",
      "attachment_count": 4,
      "message_count": 7,
      "caption": "Attach files to task",
      "description": "Enable document attachment in task view.",
      "due_date": "2025-08-03",
      "createdon": "2025-07-28",
      "priority": "high",
      "task_category": "app-development",
      "progress": 70,
      "participant_count": 3
    },
    {
      "id": "82134",
      "status": "pending",
      "project_name": "Search Functionality",
      "attachment_count": 1,
      "message_count": 2,
      "caption": "Implement search logic",
      "description": "Full-text search across tasks and messages.",
      "due_date": "2025-08-04",
      "createdon": "2025-07-28",
      "priority": "medium",
      "task_category": "API",
      "progress": 10,
      "participant_count": 1
    },
    {
      "id": "92134",
      "status": "completed",
      "project_name": "Project Overview",
      "attachment_count": 2,
      "message_count": 6,
      "caption": "Summary card",
      "description": "Build summary overview card UI.",
      "due_date": "2025-08-05",
      "createdon": "2025-07-28",
      "priority": "low",
      "task_category": "UI/UX",
      "progress": 100,
      "participant_count": 2
    },
    {
      "id": "10213",
      "status": "in_progress",
      "project_name": "Bug Fixes",
      "attachment_count": 0,
      "message_count": 5,
      "caption": "Fix crash on login",
      "description": "Resolve the app crash seen during authentication.",
      "due_date": "2025-08-06",
      "createdon": "2025-07-28",
      "priority": "high",
      "task_category": "app-development",
      "progress": 80,
      "participant_count": 1
    },
    {
      "id": "34711",
      "status": "pending",
      "project_name": "Calendar View",
      "attachment_count": 2,
      "message_count": 9,
      "caption": "Create calendar UI",
      "description": "Implement calendar to show upcoming tasks.",
      "due_date": "2025-08-07",
      "createdon": "2025-07-28",
      "priority": "medium",
      "task_category": "UI/UX",
      "progress": 0,
      "participant_count": 3
    },
    {
      "id": "71112",
      "status": "in_progress",
      "project_name": "Login API Upgrade",
      "attachment_count": 0,
      "message_count": 3,
      "caption": "OAuth integration",
      "description": "Add support for Google OAuth login.",
      "due_date": "2025-08-08",
      "createdon": "2025-07-28",
      "priority": "medium",
      "task_category": "API",
      "progress": 35,
      "participant_count": 2
    },
    {
      "id": "13711",
      "status": "pending",
      "project_name": "Permissions",
      "attachment_count": 1,
      "message_count": 2,
      "caption": "Add admin roles",
      "description": "Manage access levels for different users.",
      "due_date": "2025-08-09",
      "createdon": "2025-07-28",
      "priority": "high",
      "task_category": "app-development",
      "progress": 20,
      "participant_count": 3
    },
    {
      "id": "17114",
      "status": "completed",
      "project_name": "Onboarding Flow",
      "attachment_count": 3,
      "message_count": 8,
      "caption": "Intro screens",
      "description": "Create and animate onboarding slides.",
      "due_date": "2025-08-10",
      "createdon": "2025-07-28",
      "priority": "low",
      "task_category": "UI/UX",
      "progress": 100,
      "participant_count": 2
    },
    {
      "id": "11125",
      "status": "in_progress",
      "project_name": "Task Filtering",
      "attachment_count": 0,
      "message_count": 4,
      "caption": "Add filter options",
      "description": "Enable filtering by priority and status.",
      "due_date": "2025-08-11",
      "createdon": "2025-07-28",
      "priority": "medium",
      "task_category": "app-development",
      "progress": 60,
      "participant_count": 1
    }
  ];
}
