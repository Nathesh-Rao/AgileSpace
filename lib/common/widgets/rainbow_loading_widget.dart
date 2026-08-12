import 'package:axpert_space/common/common.dart';
import 'package:flutter/material.dart';

class RainbowLoadingWidget extends StatefulWidget {
  const RainbowLoadingWidget({super.key});

  @override
  State<RainbowLoadingWidget> createState() => _RainbowLoadingWidgetState();
}

class _RainbowLoadingWidgetState extends State<RainbowLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Color> rainbowColors = const [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 2.5.h,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            height: 2.5.h,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-1 + 2 * _controller.value, 0),
                end: Alignment(1 + 2 * _controller.value, 0),
                colors: rainbowColors,
                tileMode: TileMode.repeated, // ensures no gap
              ),
            ),
          );
        },
      ),
    );
  }
}
