import 'dart:math';
import 'package:axpert_space/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ParticipantAvatarStackWidget extends StatelessWidget {
  final List<String> avatarUrls;
  final int participantCount;
  final int maxVisible;
  final double avatarSize;
  final double overlap;

  const ParticipantAvatarStackWidget({
    super.key,
    required this.avatarUrls,
    this.participantCount = 1,
    this.maxVisible = 4,
    this.avatarSize = 30,
    this.overlap = 13,
  });

  Color _getRandomColor() {
    final colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.teal,
      Colors.brown,
      Colors.indigo,
    ];
    return colors[Random().nextInt(colors.length)];
  }

  Widget _buildAvatar({String? url}) {
    final color = _getRandomColor();

    return CircleAvatar(
      radius: avatarSize / 2,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: (avatarSize / 2) - 3.w,
        backgroundColor: color.withOpacity(0.1),
        child: (url != null && url.isNotEmpty)
            ? ClipOval(
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  width: avatarSize,
                  height: avatarSize,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.person,
                    color: color,
                    size: avatarSize * 0.6,
                  ),
                ),
              )
            : Icon(
                Icons.person,
                color: color,
                size: avatarSize * 0.6,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final useUrls = avatarUrls.isNotEmpty;

    int displayCount = useUrls
        ? (avatarUrls.length > maxVisible ? maxVisible - 1 : avatarUrls.length)
        : (participantCount > maxVisible ? maxVisible - 1 : participantCount);

    int extraCount = useUrls ? (avatarUrls.length - displayCount) : (participantCount - displayCount);

    return SizedBox(
      height: avatarSize,
      child: Stack(
        children: [
          for (int i = 0; i < displayCount; i++)
            Positioned(
              left: i * (avatarSize - overlap),
              child: _buildAvatar(
                url: useUrls ? avatarUrls[i] : null,
              ),
            ),
          if (extraCount > 0)
            Positioned(
              left: displayCount * (avatarSize - overlap),
              child: CircleAvatar(
                radius: avatarSize / 2,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: (avatarSize / 2) - 2,
                  backgroundColor: Colors.grey.shade300,
                  child: Text(
                    "+$extraCount",
                    style: TextStyle(
                      fontSize: avatarSize * 0.35,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// class ParticipantAvatarStackWidget extends StatelessWidget {
//   final List<String> avatarUrls;
//   final int participantCount;
//   final int maxVisible;
//   final double avatarSize;
//   final double overlap;
//
//   const ParticipantAvatarStackWidget({
//     super.key,
//     required this.avatarUrls,
//     this.participantCount = 1,
//     this.maxVisible = 4,
//     this.avatarSize = 30,
//     this.overlap = 13,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox.shrink();
//   }
// }
