import 'package:flutter/material.dart';

class RainbowLoadingWidget extends StatefulWidget {
  const RainbowLoadingWidget({super.key});

  @override
  State<RainbowLoadingWidget> createState() => _RainbowLoadingWidgetState();
}

class _RainbowLoadingWidgetState extends State<RainbowLoadingWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
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
    return Container(
      height: 2.5,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: rainbowColors,
                begin: Alignment(-1 + 2 * _controller.value, 0),
                end: Alignment(1 + 2 * _controller.value, 0),
                tileMode: TileMode.mirror,
              ).createShader(bounds);
            },
            child: LinearProgressIndicator(
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 2.5,
            ),
            blendMode: BlendMode.srcIn,
          );
        },
      ),
    );
  }
}
