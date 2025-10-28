import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/task/models/models.dart';
import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

class HistoryToolTipWidget extends StatefulWidget {
  final TaskHistoryModel history;
  const HistoryToolTipWidget({super.key, required this.history});

  @override
  State<HistoryToolTipWidget> createState() => _HistoryToolTipWidgetState();
}

class _HistoryToolTipWidgetState extends State<HistoryToolTipWidget> {
  late String _text;
  final int _maxLines = 4;
  final GlobalKey _textKey = GlobalKey();
  final _controller = SuperTooltipController();

  // final _taskController
  @override
  void initState() {
    _text = widget.history.message;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(
            text: _text, style: Theme.of(context).textTheme.bodyMedium);
        final tp = TextPainter(
          text: span,
          textDirection: TextDirection.ltr,
          maxLines: _maxLines,
        )..layout(maxWidth: constraints.maxWidth);

        final isOverflow = tp.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _text,
              key: _textKey,
              maxLines: _maxLines,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: Color(0xffA2A2A2),
                fontSize: 10.sp,
              ),
            ),
            if (isOverflow)
              // GestureDetector(
              //   onTap: _showTooltip,
              //   child: Text(
              //     'Read more',
              //     style: GoogleFonts.poppins(
              //       fontWeight: FontWeight.w500,
              //       color: Color(0xffA2A2A2),
              //       fontSize: 10.sp,
              //     ),
              //   ),
              // ),
              GestureDetector(
                onTap: () async {
                  await _controller.showTooltip();
                },
                child: SuperTooltip(
                  showBarrier: true,
                  borderColor: AppColors.getHistoryColor(widget.history.status),
                  borderWidth: 2,
                  arrowBaseWidth: 30,
                  constraints: BoxConstraints(
                    maxWidth: 1.sw,
                    maxHeight: 1.sh,
                  ),
                  popupDirection: TooltipDirection.right,
                  controller: _controller,
                  content: Material(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.history.username.toUpperCase(),
                              style: AppStyles.taskHistoryUserNameStyle,
                            ),
                          ],
                        ),
                        5.verticalSpace,
                        Row(
                          spacing: 10.w,
                          children: [
                            ChipCardWidget(
                                label: widget.history.status,
                                color: AppColors.getHistoryColor(
                                    widget.history.status)),
                            ChipCardWidget(
                                label: "Message", color: AppColors.baseYellow),
                          ],
                        ),
                        10.verticalSpace,
                        Divider(
                          color: Colors.amber,
                          height: 1,
                        ),
                        10.verticalSpace,
                        Text(
                          _text,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            color: AppColors.text1,
                            fontSize: 10.sp,
                          ),
                        ),
                        20.verticalSpace,
                      ],
                    ),
                  ),
                  child: Text(
                    'Read more >',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryActionColorDarkBlue,
                      fontSize: 10.sp,
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
