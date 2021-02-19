import 'package:credit_rating/credit_rating.dart';
import 'package:flutter/material.dart';

class RatingWidget extends StatefulWidget {
  final int progress;
  RatingWidget(this.progress);
  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> with SingleTickerProviderStateMixin {
  AnimationController _progressController;
  List<Color> colors = [];
  int progress = 90;
  String progressLevel;
  int level = 3;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));

    progress = widget.progress;
    paintReady();
  }

  void paintReady() {
    ///目前满分最大值为120
    if (progress <= 40) {
      ///信用极差
      progressLevel = '信用极差';
      level = 1;
      colors = [Color(0xFFE94C4C), Color(0xFFFF6565)];
    } else if (progress > 40 && progress <= 90) {
      ///信用中等
      progressLevel = '信用中等';
      level = 2;
      colors = [Color(0xFFFF9404), Color(0xFFFFB34D)];
    } else {
      ///信用良好
      progressLevel = '信用良好';
      level = 3;
      colors = [Color(0xFF42BD56), Color(0xFF31D340)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          width: 172,
          height: 172,
          color: Colors.white,
          child: AnimatedBuilder(
            animation: _progressController,
            builder: (_, w) {
              return CustomPaint(
                painter: RatingProgressBarPainter(
                    progress,
                    progressLevel,
                    colors,
                    _progressController.value),
                size: Size(172, 172),
              );
            },
          ),
        ));
  }
}
