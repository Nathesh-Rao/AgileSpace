import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/core.dart';
import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

class ReadMoreTooltipText extends StatefulWidget {
  final String text;
  const ReadMoreTooltipText({super.key, required this.text});

  @override
  State<ReadMoreTooltipText> createState() => _ReadMoreTooltipTextState();
}

class _ReadMoreTooltipTextState extends State<ReadMoreTooltipText> {
  late String _text;
  final int _maxLines = 4;
  final GlobalKey _textKey = GlobalKey();
  final _controller = SuperTooltipController();
  @override
  void initState() {
    _text = widget.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(text: _text, style: Theme.of(context).textTheme.bodyMedium);
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
                  constraints: BoxConstraints(
                    maxWidth: 1.sw,
                    maxHeight: 1.sh,
                  ),
                  popupDirection: TooltipDirection.up,
                  controller: _controller,
                  content: Material(
                    color: Colors.transparent,
                    child: Text(
                      _text,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Color(0xffA2A2A2),
                        fontSize: 10.sp,
                      ),
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
