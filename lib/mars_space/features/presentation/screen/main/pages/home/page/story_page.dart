import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mars_it_app/mars_space/core/calculation/calculate_size.dart';
import 'package:mars_it_app/mars_space/core/utils/constants.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_stories_response_entity.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StoryPage extends StatefulWidget {
  final List<GetStoriesResponseEntity> stories;
  final String storyTitle;
  final String iconUrl;
  const StoryPage({
    super.key,
    required this.storyTitle,
    required this.iconUrl,
    required this.stories,
  });

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late final List<GetStoriesResponseEntity> _stories;

  late AnimationController _animationController;
  double _progressValue = 0.0;

  @override
  void initState() {
    super.initState();

    _stories = widget.stories;
    startAnimation();
  }

  void startAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8), // Adjust the duration as needed
      value: 0,
    );

    _animationController.addListener(() {
      setState(() {
        _progressValue = _animationController.value;
      });
    });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
        setState(() {
          if (_currentIndex == _stories.length - 1) {
            Navigator.pop(context, true);
          } else {
            _currentIndex++;
          }
        });
        _animationController.forward();
      }
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(color: Colors.black),
            GestureDetector(
              onTap: () {
                _animationController.reset();
                setState(() {
                  if (_currentIndex == _stories.length - 1) {
                    Navigator.pop(context, true);
                  } else {
                    _currentIndex++;
                  }
                });
                _animationController.forward();
              },
              onLongPressStart: (details) {
                _animationController.stop();
              },
              onLongPressEnd: (details) {
                _animationController.forward();
              },
              child: Image.network(
                EndPoints.media_base_url + _stories[_currentIndex].imageUrl!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.fitWidth,
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  // Progress bars indicating the completion of each story
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              CalculateSize.getResponsiveSize(16, screenWidth),
                          vertical:
                              CalculateSize.getResponsiveSize(12, screenWidth)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          _stories.length,
                          (index) => Expanded(
                            child: Row(
                              children: [
                                SizedBox(
                                    width: CalculateSize.getResponsiveSize(
                                        2, screenWidth)),
                                Expanded(
                                  child: _buildCustomProgressBar(
                                      _currentIndex == index
                                          ? _progressValue
                                          : _currentIndex > index
                                              ? 1
                                              : 0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                      height: CalculateSize.getResponsiveSize(6, screenWidth)),

                  // icon, title and story publication date
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            CalculateSize.getResponsiveSize(16, screenWidth)),
                    child: Row(
                      children: [
                        Container(
                          width:
                              CalculateSize.getResponsiveSize(56, screenWidth),
                          height:
                              CalculateSize.getResponsiveSize(56, screenWidth),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(
                                CalculateSize.getResponsiveSize(
                                    8, screenWidth)),
                            child: Image.asset(widget.iconUrl),
                          ),
                        ),
                        SizedBox(
                            width: CalculateSize.getResponsiveSize(
                                16, screenWidth)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.storyTitle,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: CalculateSize.getResponsiveSize(
                                    18, screenWidth),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "${AppLocalizations.of(context)!.text_story_uploaded}: ${DateFormat('dd.MM.yyyy').format(DateTime.parse(_stories[_currentIndex].dateTime!))}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: CalculateSize.getResponsiveSize(
                                    14, screenWidth),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomProgressBar(double value) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: CalculateSize.getResponsiveSize(8, screenWidth),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2), // Set progress bar color to white
        borderRadius: BorderRadius.circular(11), // Set circular radius
      ),
      child: LinearProgressIndicator(
        borderRadius: BorderRadius.circular(11),
        value: value,
        backgroundColor:
            Colors.transparent, // Make progress background transparent
        valueColor:
            AlwaysStoppedAnimation<Color>(Colors.white), // Set progress color
      ),
    );
  }
}
