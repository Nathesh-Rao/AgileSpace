class TaskHistoryModel {
  final String fromUser;
  final String toUser;
  final String date;
  final String actionTook;
  final String message;

  TaskHistoryModel({
    required this.fromUser,
    required this.toUser,
    required this.date,
    required this.actionTook,
    required this.message,
  });

  factory TaskHistoryModel.fromJson(Map<String, dynamic> json) {
    return TaskHistoryModel(
      fromUser: json['from_user'],
      toUser: json['to_user'],
      date: json['date'],
      actionTook: json['action_took'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from_user': fromUser,
      'to_user': toUser,
      'date': date,
      'action_took': actionTook,
      'message': message,
    };
  }

  static final tempData = tempJsonData.map((key, value) {
    return MapEntry(key, value.map((e) => TaskHistoryModel.fromJson(e)).toList());
  });
  static final tempJsonData = {
    "13434": [
      {
        "from_user": "Arjun",
        "to_user": "Meera",
        "date": "2025-07-20",
        "action_took": "created",
        "message": "Initial task created for landing page and mobile app."
      },
      {
        "from_user": "Meera",
        "to_user": "Ravi",
        "date": "2025-07-22",
        "action_took": "reassigned",
        "message": "Reassigned task to Ravi for mobile UI adjustments."
      }
    ],
    "21343": [
      {
        "from_user": "Kiran",
        "to_user": "Anjali",
        "date": "2025-07-23",
        "action_took": "created",
        "message": "Kickstarted login/logout integration."
      },
      {
        "from_user": "Anjali",
        "to_user": "Vikram",
        "date": "2025-07-24",
        "action_took": "reassigned",
        "message": "Passing session management to Vikram."
      }
    ],
    "32134": [
      {
        "from_user": "Riya",
        "to_user": "Sameer",
        "date": "2025-07-21",
        "action_took": "created",
        "message": "Backend schema defined for task model."
      },
      {
        "from_user": "Sameer",
        "to_user": "Riya",
        "date": "2025-07-26",
        "action_took": "completed",
        "message": "Final version of model pushed to production."
      }
    ],
    "42134": [
      {
        "from_user": "Pooja",
        "to_user": "Ravi",
        "date": "2025-07-22",
        "action_took": "created",
        "message": "Initial notification setup task started."
      },
      {
        "from_user": "Ravi",
        "to_user": "Pooja",
        "date": "2025-07-23",
        "action_took": "reassigned",
        "message": "Pushed to Pooja for FCM debugging."
      },
      {
        "from_user": "Pooja",
        "to_user": "Ravi",
        "date": "2025-07-24",
        "action_took": "reassigned",
        "message": "Sending back to Ravi for payload formatting."
      }
    ],
    "52134": [
      {
        "from_user": "Varun",
        "to_user": "Isha",
        "date": "2025-07-21",
        "action_took": "created",
        "message": "Begin work on dashboard metrics layout."
      },
      {
        "from_user": "Isha",
        "to_user": "Neha",
        "date": "2025-07-25",
        "action_took": "reassigned",
        "message": "Neha will finish chart UI."
      }
    ],
    "65213": [
      {
        "from_user": "Raj",
        "to_user": "Kriti",
        "date": "2025-07-23",
        "action_took": "created",
        "message": "Edit profile module initiated."
      }
    ],
    "21347": [
      {
        "from_user": "Meera",
        "to_user": "Karan",
        "date": "2025-07-24",
        "action_took": "created",
        "message": "New task for document upload."
      },
      {
        "from_user": "Karan",
        "to_user": "Meera",
        "date": "2025-07-27",
        "action_took": "reassigned",
        "message": "Needs file preview logic—sending to Meera."
      },
      {
        "from_user": "Meera",
        "to_user": "Karan",
        "date": "2025-07-28",
        "action_took": "reassigned",
        "message": "Added preview logic, back to Karan."
      }
    ],
    "82134": [
      {
        "from_user": "Sameer",
        "to_user": "Dev",
        "date": "2025-07-21",
        "action_took": "created",
        "message": "Search logic initialized for task queries."
      },
      {
        "from_user": "Dev",
        "to_user": "Sameer",
        "date": "2025-07-22",
        "action_took": "reassigned",
        "message": "Needs deeper indexing logic."
      }
    ],
    "92134": [
      {
        "from_user": "Priya",
        "to_user": "Tina",
        "date": "2025-07-21",
        "action_took": "created",
        "message": "Start UI for summary card."
      },
      {
        "from_user": "Tina",
        "to_user": "Priya",
        "date": "2025-07-28",
        "action_took": "completed",
        "message": "Finished with overview design."
      }
    ],
    "10213": [
      {
        "from_user": "Amit",
        "to_user": "Dinesh",
        "date": "2025-07-24",
        "action_took": "created",
        "message": "Fix urgent crash in login flow."
      },
      {
        "from_user": "Dinesh",
        "to_user": "Amit",
        "date": "2025-07-25",
        "action_took": "reassigned",
        "message": "Crash resolved, review needed."
      }
    ],
    "34711": [
      {
        "from_user": "Nikhil",
        "to_user": "Puja",
        "date": "2025-07-20",
        "action_took": "created",
        "message": "Task created for calendar UI."
      },
      {
        "from_user": "Puja",
        "to_user": "Nikhil",
        "date": "2025-07-21",
        "action_took": "reassigned",
        "message": "Sending for final tweaks."
      },
      {
        "from_user": "Nikhil",
        "to_user": "Puja",
        "date": "2025-07-23",
        "action_took": "reassigned",
        "message": "Fonts and icons updated."
      },
      {
        "from_user": "Puja",
        "to_user": "Nikhil",
        "date": "2025-07-24",
        "action_took": "reassigned",
        "message": "Added calendar day selector logic."
      }
    ],
    "71112": [
      {
        "from_user": "Farhan",
        "to_user": "Shreya",
        "date": "2025-07-26",
        "action_took": "created",
        "message": "Start work on OAuth integration."
      },
      {
        "from_user": "Shreya",
        "to_user": "Farhan",
        "date": "2025-07-27",
        "action_took": "reassigned",
        "message": "Need token handling logic."
      }
    ],
    "13711": [
      {
        "from_user": "Rakesh",
        "to_user": "Jaya",
        "date": "2025-07-28",
        "action_took": "created",
        "message": "Permissions and roles logic assigned."
      },
      {
        "from_user": "Jaya",
        "to_user": "Rakesh",
        "date": "2025-07-29",
        "action_took": "reassigned",
        "message": "Sent back for admin UI update."
      },
      {
        "from_user": "Rakesh",
        "to_user": "Jaya",
        "date": "2025-07-30",
        "action_took": "reassigned",
        "message": "Final role mapping done."
      }
    ],
    "17114": [
      {
        "from_user": "Tara",
        "to_user": "Imran",
        "date": "2025-07-20",
        "action_took": "created",
        "message": "Start onboarding animation."
      },
      {
        "from_user": "Imran",
        "to_user": "Tara",
        "date": "2025-07-25",
        "action_took": "completed",
        "message": "Intro screens are ready and animated."
      }
    ],
    "11125": [
      {
        "from_user": "Veer",
        "to_user": "Sanya",
        "date": "2025-07-20",
        "action_took": "created",
        "message": "Filter system planned for task list."
      },
      {
        "from_user": "Sanya",
        "to_user": "Veer",
        "date": "2025-07-24",
        "action_took": "reassigned",
        "message": "Refined priority filter logic."
      }
    ]
  };
}
