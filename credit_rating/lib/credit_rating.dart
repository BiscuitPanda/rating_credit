library credit_rating;

import 'dart:math';
import 'package:flutter/material.dart';

class RatingProgressBarPainter extends CustomPainter {
  int progress;
  String progressLevel;
  List<Color> colors;
  double progressController;

  RatingProgressBarPainter(
      this.progress, this.progressLevel, this.colors, this.progressController) {
    if (colors.length > 0) {
      assert(progress != 0 && progressLevel != null);
    }
  }

  Paint _clusterPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..color = Color(0xFFDEDEDE)
    ..strokeCap = StrokeCap.round;

  Paint _levelTextPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.5;

  Paint _ratingClusterPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..strokeCap = StrokeCap.round;

  Paint _toTalProgressPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 7.7
    ..color = Color(0xFFDEDEDE)
    ..strokeCap = StrokeCap.round;

  Paint _ratingProgressPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 7.7
    ..strokeCap = StrokeCap.round;
  Paint _ratingProgressCompanyPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.6
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    int totalPoint = 120;
    if (progressController > 0||progress==null) {
      if (progress == null) {
        ///画无评分时默认样式

        ///发射簇半径
        double clusterRadius = max(size.width, size.height) / 2;

        ///外圆弧半径
        double radius = clusterRadius - 15;

        canvas.drawArc(
            Rect.fromCircle(
                center: Offset(size.width / 2, size.height / 2),
                radius: radius),
            pi * 3 / 4,
            pi * 3 / 2,
            false,
            _toTalProgressPaint);

        ///步长5° 即(1/36)pi
        ///第一个和最后一个刻度不画
        for (double angle = pi * (3 / 4) + pi * (1 / 36);
        angle <= pi * (9 / 4) - pi * (1 / 36);
        angle = angle + pi * (1 / 36)) {
          ///画发散簇
          double x1, y1, x11, y11;
          var v = (angle / pi).toStringAsFixed(2);
          var v2 = double.parse(v);
          if (v2 == 1.00 ||
              v2 == 1.25 ||
              v2 == 1.50 ||
              v2 == 1.75 ||
              v2 == 2.00) {
            x1 = clusterRadius * cos(angle);
            y1 = clusterRadius * sin(angle);
          } else {
            x1 = (clusterRadius - 2.5) * cos(angle);
            y1 = (clusterRadius - 2.5) * sin(angle);
          }
          x11 = (clusterRadius - 5) * cos(angle);
          y11 = (clusterRadius - 5) * sin(angle);

          canvas.drawLine(Offset(clusterRadius + x1, clusterRadius + y1),
              Offset(clusterRadius + x11, clusterRadius + y11), _clusterPaint);
        }

        TextSpan textSpan = TextSpan(
            text: '暂无评分',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13.5));
        TextPainter textPainter =
        TextPainter(textDirection: TextDirection.ltr, text: textSpan);
        textPainter.layout(maxWidth: clusterRadius);
        textPainter.paint(
            canvas,
            Offset(
                clusterRadius - textPainter.width / 2, clusterRadius * 1.23));

        ///画字体左边
        Gradient gradientLeftText = LinearGradient(
          colors: [Colors.white, Color(0xFFDEDEDE)],
        );
        var rectLeftText = Rect.fromLTWH(
            clusterRadius - textPainter.width / 2 - 20,
            clusterRadius * 1.23,
            14,
            6);
        _levelTextPaint.shader = gradientLeftText.createShader(rectLeftText);
        canvas.drawLine(
            Offset(clusterRadius - textPainter.width / 2 - 20,
                clusterRadius * 1.23 + textPainter.height / 2 + 1),
            Offset(clusterRadius - textPainter.width / 2 - 6,
                clusterRadius * 1.23 + textPainter.height / 2 + 1),
            _levelTextPaint);

        ///画字体右边
        Gradient gradientRightText = LinearGradient(
          colors: [
            Color(0xFFDEDEDE),
            Colors.white,
          ],
        );
        var rectRightText = Rect.fromLTWH(
            clusterRadius + textPainter.width / 2 + 6,
            clusterRadius * 1.23,
            14,
            6);
        _levelTextPaint.shader = gradientRightText.createShader(rectRightText);
        canvas.drawLine(
            Offset(clusterRadius + textPainter.width / 2 + 6,
                clusterRadius * 1.23 + textPainter.height / 2 + 1),
            Offset(clusterRadius + textPainter.width / 2 + 20,
                clusterRadius * 1.23 + textPainter.height / 2 + 1),
            _levelTextPaint);

        TextSpan progressTextSpan = TextSpan(
            text: '0',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 58));
        TextPainter progressTextPainter = TextPainter(
            textDirection: TextDirection.ltr, text: progressTextSpan);
        progressTextPainter.layout(maxWidth: clusterRadius * 2);
        progressTextPainter.paint(
            canvas,
            Offset(clusterRadius - progressTextPainter.width / 2,
                0.45 * clusterRadius));
      } else {
        _ratingClusterPaint.color = colors[1];

        ///发射簇半径
        double clusterRadius = max(size.width, size.height) / 2;

        ///外圆弧半径
        double radius = clusterRadius - 15;

        ///内圆弧半径
        double radiusCompany = radius - 7.5;
        canvas.drawArc(
            Rect.fromCircle(
                center: Offset(size.width / 2, size.height / 2),
                radius: radius),
            pi * 3 / 4,
            pi * 3 / 2,
            false,
            _toTalProgressPaint);

        Gradient gradient = SweepGradient(
          startAngle: pi * 3 / 4,
          endAngle: pi * (3 / 2),
          transform: GradientRotation(pi/4),
          colors: [colors[0], colors[1]],
        );

        var rect = Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2), radius: radius);
        _ratingProgressPaint.shader = gradient.createShader(rect);
        canvas.drawArc(
            Rect.fromCircle(
                center: Offset(size.width / 2, size.height / 2),
                radius: radius),
            pi * 3 / 4,
            pi * (3 / 2) * (progressController * (progress / totalPoint)),
            false,
            _ratingProgressPaint);

        Gradient gradientCompany = SweepGradient(
          startAngle: pi * 3 / 4,
          endAngle: pi * (3 / 2),
          transform: GradientRotation(pi/4),
          colors: [
            Colors.white,
            colors[0],
          ],
        );
        var rectCompany = Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2),
            radius: radiusCompany);
        _ratingProgressCompanyPaint.shader =
            gradientCompany.createShader(rectCompany);
        canvas.drawArc(
            Rect.fromCircle(
                center: Offset(size.width / 2, size.height / 2),
                radius: radiusCompany),
            pi * 3 / 4,
            pi * (3 / 2) * (progressController * (progress / totalPoint)),
            false,
            _ratingProgressCompanyPaint);

        ///步长5° 即(1/36)pi
        ///第一个和最后一个刻度不画
        for (double angle = pi * (3 / 4) + pi * (1 / 36);
        angle <= pi * (9 / 4) - pi * (1 / 36);
        angle = angle + pi * (1 / 36)) {
          ///画发散簇
          double x1, y1, x11, y11;
          var v = (angle / pi).toStringAsFixed(2);
          var v2 = double.parse(v);
          if (v2 == 1.00 ||
              v2 == 1.25 ||
              v2 == 1.50 ||
              v2 == 1.75 ||
              v2 == 2.00) {
            x1 = clusterRadius * cos(angle);
            y1 = clusterRadius * sin(angle);
          } else {
            x1 = (clusterRadius - 2.5) * cos(angle);
            y1 = (clusterRadius - 2.5) * sin(angle);
          }
          x11 = (clusterRadius - 5) * cos(angle);
          y11 = (clusterRadius - 5) * sin(angle);

          canvas.drawLine(Offset(clusterRadius + x1, clusterRadius + y1),
              Offset(clusterRadius + x11, clusterRadius + y11), _clusterPaint);
        }

        ///步长5° 即(1/36)pi
        ///第一个和最后一个刻度不画
        for (double angle = pi * (3 / 4) + pi * (1 / 36);
        angle <=
            (pi * (3 / 4 + 1 / 36) +
                pi *
                    (3 / 2) *
                    (progressController * (progress / totalPoint))) &&
            (angle <= pi * (9 / 4) - pi * (1 / 36));
        angle = angle + pi * (1 / 36)) {
          ///画发散簇
          double x1, y1, x11, y11;
          var v = (angle / pi).toStringAsFixed(2);
          var v2 = double.parse(v);
          if (v2 == 1.00 ||
              v2 == 1.25 ||
              v2 == 1.50 ||
              v2 == 1.75 ||
              v2 == 2.00) {
            x1 = clusterRadius * cos(angle);
            y1 = clusterRadius * sin(angle);
          } else {
            x1 = (clusterRadius - 2.5) * cos(angle);
            y1 = (clusterRadius - 2.5) * sin(angle);
          }
          x11 = (clusterRadius - 5) * cos(angle);
          y11 = (clusterRadius - 5) * sin(angle);

          canvas.drawLine(
              Offset(clusterRadius + x1, clusterRadius + y1),
              Offset(clusterRadius + x11, clusterRadius + y11),
              _ratingClusterPaint);
        }

        TextSpan textSpan = TextSpan(
            text: progressLevel,
            style: TextStyle(
                color: colors[0],
                fontWeight: FontWeight.bold,
                fontSize: 13.5));
        TextPainter textPainter =
        TextPainter(textDirection: TextDirection.ltr, text: textSpan);
        textPainter.layout(maxWidth: clusterRadius);
        textPainter.paint(
            canvas,
            Offset(
                clusterRadius - textPainter.width / 2, clusterRadius * 1.23));

        ///画字体左边
        Gradient gradientLeftText = LinearGradient(
          colors: [
            Colors.white,
            colors[0],
          ],
        );
        var rectLeftText = Rect.fromLTWH(
            clusterRadius - textPainter.width / 2 - 20,
            clusterRadius * 1.23,
            14,
            6);
        _levelTextPaint.shader = gradientLeftText.createShader(rectLeftText);
        canvas.drawLine(
            Offset(clusterRadius - textPainter.width / 2 - 20,
                clusterRadius * 1.23 + textPainter.height / 2 + 1),
            Offset(clusterRadius - textPainter.width / 2 - 6,
                clusterRadius * 1.23 + textPainter.height / 2 + 1),
            _levelTextPaint);

        ///画字体右边
        Gradient gradientRightText = LinearGradient(
          colors: [
            colors[0],
            Colors.white,
          ],
        );
        var rectRightText = Rect.fromLTWH(
            clusterRadius + textPainter.width / 2 + 6,
            clusterRadius * 1.23,
            14,
            6);
        _levelTextPaint.shader = gradientRightText.createShader(rectRightText);
        canvas.drawLine(
            Offset(clusterRadius + textPainter.width / 2 + 6,
                clusterRadius * 1.23 + textPainter.height / 2 + 1),
            Offset(clusterRadius + textPainter.width / 2 + 20,
                clusterRadius * 1.23 + textPainter.height / 2 + 1),
            _levelTextPaint);

        TextSpan ProgressTextSpan = TextSpan(
            text: '${(progress*progressController).toInt()}',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 58));
        TextPainter progressTextPainter = TextPainter(
            textDirection: TextDirection.ltr, text: ProgressTextSpan);
        progressTextPainter.layout(maxWidth: clusterRadius * 2);
        progressTextPainter.paint(
            canvas,
            Offset(clusterRadius - progressTextPainter.width / 2,
                0.45 * clusterRadius));
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
