import 'dart:async';

import 'package:flutter/material.dart';

class EmojisAnimationWidget extends StatefulWidget {
  const EmojisAnimationWidget({super.key});

  @override
  State<EmojisAnimationWidget> createState() => _EmojisAnimationWidgetState();
}

class _EmojisAnimationWidgetState extends State<EmojisAnimationWidget> {
  bool _isFirstLoad = true;
  final List<double> _circleSizes = List.filled(19, 0);

  final List<Color> _circleColors = [
    const Color(0xFFDFCCFB),
    const Color(0xFFFBB2EF),
    const Color(0xFFFFE4D6),
    //
    const Color(0xFFDFCCFB),
    const Color(0xFFD2E0FB),
    const Color(0xFFDBFBB2),
    const Color(0xFFFBF0B2),
    //
    const Color(0xFFDBFBB2),
    const Color(0xFFB2FBCF),
    const Color(0xFFD2E0FB),
    const Color(0xFFFBF0B2),
    const Color(0xFFFFE4D6),
    //
    const Color(0xFFDFCCFB),
    const Color(0xFFFBB2EF),
    const Color(0xFFFFE4D6),
    const Color(0xFFDFCCFB),
    //
    const Color(0xFFD2E0FB),
    const Color(0xFFDBFBB2),
    const Color(0xFFFBF0B2),
  ];

  // four different sizes for circles
  late double radius1;
  late double radius2;
  late double radius3;
  late double radius4;

  int animationPhase = 1; // three looping animation phases in total
  late Timer timer;

  @override
  void initState() {
    super.initState();

    // change emoji size every 3 seconds
    timer = Timer.periodic(const Duration(milliseconds: 3500), (timer) {
      setCircleSize();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    radius1 = MediaQuery.of(this.context).size.width / 8.4783;
    radius2 = MediaQuery.of(this.context).size.width / 5.2703;
    radius3 = MediaQuery.of(this.context).size.width / 4.0625;
    radius4 = MediaQuery.of(this.context).size.width / 3.3621;
    if (_isFirstLoad) {
      setCircleSize();
      _isFirstLoad = false;
    }
    double intervalForThree = (MediaQuery.of(context).size.width / 4);
    double intervalForFour = (MediaQuery.of(context).size.width / 5);
    double intervalForFive = (MediaQuery.of(context).size.width / 6);
    return Stack(
      children: [
        // three
        emojiCircle(0, intervalForThree - 30, 70),
        emojiCircle(1, 2 * intervalForThree, 70),
        emojiCircle(2, 3 * intervalForThree + 30, 70),
        // four
        emojiCircle(3, intervalForFour - 45, 180),
        emojiCircle(4, 2 * intervalForFour - 20, 150),
        emojiCircle(5, 3 * intervalForFour + 20, 150),
        emojiCircle(6, 4 * intervalForFour + 45, 180),
        // five
        emojiCircle(7, intervalForFive - 75, 270),
        emojiCircle(8, 2 * intervalForFive - 45, 270),
        emojiCircle(9, 3 * intervalForFive, 270),
        emojiCircle(10, 4 * intervalForFive + 45, 270),
        emojiCircle(11, 5 * intervalForFive + 80, 270),
        // four
        emojiCircle(12, intervalForFour - 45, 370),
        emojiCircle(13, 2 * intervalForFour - 20, 380),
        emojiCircle(14, 3 * intervalForFour + 20, 370),
        emojiCircle(15, 4 * intervalForFour + 45, 380),
        // three
        emojiCircle(16, intervalForThree - 30, 460),
        emojiCircle(17, 2 * intervalForThree + 10, 460),
        emojiCircle(18, 3 * intervalForThree + 30, 460),
      ],
    );
  }

  void setCircleSize() {
    switch (animationPhase) {
      case 1:
        setState(() {
          animationPhase = 2;
          _circleSizes[0] = radius1;
          _circleSizes[1] = radius2;
          _circleSizes[2] = radius1;
          _circleSizes[3] = radius2;
          _circleSizes[4] = radius3;
          _circleSizes[5] = radius3;
          _circleSizes[6] = radius2;
          _circleSizes[7] = radius1;
          _circleSizes[8] = radius3;
          _circleSizes[9] = radius4;
          _circleSizes[10] = radius3;
          _circleSizes[11] = radius1;
          _circleSizes[12] = radius2;
          _circleSizes[13] = radius3;
          _circleSizes[14] = radius3;
          _circleSizes[15] = radius2;
          _circleSizes[16] = radius1;
          _circleSizes[17] = radius2;
          _circleSizes[18] = radius1;
        });
        break;
      case 2:
        setState(() {
          animationPhase = 3;
          _circleSizes[0] = radius2;
          _circleSizes[1] = radius1;
          _circleSizes[2] = radius1;
          _circleSizes[3] = radius1;
          _circleSizes[4] = radius4;
          _circleSizes[5] = radius2;
          _circleSizes[6] = radius3;
          _circleSizes[7] = radius1;
          _circleSizes[8] = radius2;
          _circleSizes[9] = radius3;
          _circleSizes[10] = radius2;
          _circleSizes[11] = radius2;
          _circleSizes[12] = radius2;
          _circleSizes[13] = radius4;
          _circleSizes[14] = radius2;
          _circleSizes[15] = radius3;
          _circleSizes[16] = radius2;
          _circleSizes[17] = radius2;
          _circleSizes[18] = radius2;
        });
        break;
      case 3:
        setState(() {
          animationPhase = 1;
          _circleSizes[0] = radius1;
          _circleSizes[1] = radius2;
          _circleSizes[2] = radius1;
          _circleSizes[3] = radius2;
          _circleSizes[4] = radius2;
          _circleSizes[5] = radius2;
          _circleSizes[6] = radius1;
          _circleSizes[7] = radius1;
          _circleSizes[8] = radius4;
          _circleSizes[9] = radius2;
          _circleSizes[10] = radius4;
          _circleSizes[11] = radius2;
          _circleSizes[12] = radius2;
          _circleSizes[13] = radius2;
          _circleSizes[14] = radius2;
          _circleSizes[15] = radius1;
          _circleSizes[16] = radius1;
          _circleSizes[17] = radius3;
          _circleSizes[18] = radius3;
        });
        break;
    }

    for (int i = 0; i < _circleSizes.length; i++) {
      setState(() {
        _circleSizes[i] += 3;
      });
    }

    Future.delayed(const Duration(milliseconds: 150), () {
      for (int i = 0; i < _circleSizes.length; i++) {
        setState(() {
          _circleSizes[i] -= 3;
        });
      }
    });
  }

  Widget emojiCircle(
      int elementId, double leftStartPosition, double topStartPosition) {
    double circleSize = _circleSizes[elementId];
    Color circleColor = _circleColors[elementId];
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 100),
      left: leftStartPosition - circleSize / 2,
      top: topStartPosition - circleSize / 2,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: circleSize,
        height: circleSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: circleColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(
              "assets/images/emojis/emoji${elementId % 18 + 1}.png"),
        ),
      ),
    );
  }
}
