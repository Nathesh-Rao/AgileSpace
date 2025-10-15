import 'package:axpert_space/common/common.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class TaskDetailsDescriptionWidget extends StatefulWidget {
  const TaskDetailsDescriptionWidget({super.key, required this.description});
  final String description;

  @override
  State<TaskDetailsDescriptionWidget> createState() =>
      _TaskDetailsDescriptionWidgetState();
}

class _TaskDetailsDescriptionWidgetState
    extends State<TaskDetailsDescriptionWidget> {
  bool _isExpanded = false;
  bool _isOverflowing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverflow());
  }

  void _checkOverflow() {
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.description,
        style: GoogleFonts.poppins(
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.secondarySubTitleTextColorGreyLight,
        ),
      ),
      maxLines: 3,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: context.size?.width ?? double.infinity);

    setState(() {
      _isOverflowing = textPainter.didExceedMaxLines;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedCrossFade(
              firstChild: Text(
                widget.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondarySubTitleTextColorGreyLight,
                ),
              ),
              secondChild: Text(
                widget.description,
                style: GoogleFonts.poppins(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondarySubTitleTextColorGreyLight,
                ),
              ),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
            if (_isOverflowing)
              GestureDetector(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                child: Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: Text(
                    _isExpanded ? 'See less' : 'See more',
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryActionColorDarkBlue,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
