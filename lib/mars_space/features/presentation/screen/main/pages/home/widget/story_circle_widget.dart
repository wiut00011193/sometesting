import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mars_it_app/mars_space/core/calculation/calculate_size.dart';
import 'package:mars_it_app/mars_space/core/theme/colors.dart';

class StoryCircleWidget extends StatefulWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onStoryClick;
  const StoryCircleWidget({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.onStoryClick,
  });

  @override
  State<StoryCircleWidget> createState() => _StoryCircleWidgetState();
}

class _StoryCircleWidgetState extends State<StoryCircleWidget> {
  bool _isExpanded = false;

  void _openStoryPage() {
    // Navigate to the page that resembles Instagram stories
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => StoriesPage()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = true;
              Timer(Duration(milliseconds: 500), () {
                setState(() {
                  _isExpanded = false;
                });
                widget.onStoryClick();
              });
            });
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: CalculateSize.getResponsiveSize(68, screenWidth),
            height: CalculateSize.getResponsiveSize(68, screenWidth),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
                  Border.all(color: Colors.orange, width: _isExpanded ? 6 : 2),
            ),
            child: Padding(
              padding: EdgeInsets.all(CalculateSize.getResponsiveSize(8, screenWidth)),
              child: Image.asset(widget.imageUrl),
            ),
          ),
        ),
        SizedBox(height: CalculateSize.getResponsiveSize(4, screenWidth)),
        Text(
          widget.title,
          style: TextStyle(
            color: accentColor,
            fontSize: CalculateSize.getResponsiveSize(12, screenWidth),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
