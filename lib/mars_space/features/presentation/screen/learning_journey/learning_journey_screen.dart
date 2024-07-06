import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mars_it_app/injection_handler.dart';
import 'package:mars_it_app/mars_space/core/calculation/calculate_size.dart';
import 'package:mars_it_app/mars_space/core/theme/colors.dart';
import 'package:mars_it_app/mars_space/core/utils/constants.dart';
import 'package:mars_it_app/mars_space/features/data/enum/loading_state_enum.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/get_course_modules_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_course_modules_response_entity.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/learning_journey/bloc/learning_journey_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mars_it_app/mars_space/features/presentation/widget/loading_widget.dart';

class LearningJourneyScreen extends StatefulWidget {
  const LearningJourneyScreen({super.key});

  @override
  State<LearningJourneyScreen> createState() => _LearningJourneyScreenState();
}

class _LearningJourneyScreenState extends State<LearningJourneyScreen> {
  final LearningJourneyBloc _learningJourneyBloc =
      di.get<LearningJourneyBloc>();
  int currentMonth = 0;
  final ScrollController _scrollController = ScrollController();
  DateTime? dateNow;
  int? moduleCount;
  bool setupCompleted = false;

  @override
  void initState() {
    super.initState();

    _learningJourneyBloc.add(GetStudentEvent());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: SvgPicture.asset('assets/icons/ic_back_button.svg',
              width: CalculateSize.getResponsiveSize(24, screenWidth),
              height: CalculateSize.getResponsiveSize(24, screenWidth),
              fit: BoxFit.scaleDown),
        ),
        titleSpacing: 0,
        title: Text(
          AppLocalizations.of(context)!.learningJourneyPageTitle,
          style: TextStyle(
            color: accentColor,
            fontSize: CalculateSize.getResponsiveSize(24, screenWidth),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => _learningJourneyBloc,
        child: BlocConsumer<LearningJourneyBloc, LearningJourneyState>(
          listener: (context, state) async {
            if (state.status == LoadingState.LOADED) {
              if (currentMonth == 0) {
                final getStudentResult =
                    state.getStudentResult.getOrElse(() => throw Exception());
                if (getStudentResult.groups != null) {
                  final groupResult = getStudentResult.groups!;
                  for (int i = 0; i < groupResult.length; i++) {
                    if (groupResult[i].status == 5) {
                      final group = groupResult[i];
                      _learningJourneyBloc.add(GetCourseModulesEvent(
                          getCourseModulesRequestEntity:
                              GetCourseModulesRequestEntity(
                                  courseId: group.categoryId)));
                      final DateTime dateStarted =
                          DateTime.parse(group.dateStarted!);
                      final datetimeString =
                          await di.get<Dio>().get(EndPoints.path_get_datetime);
                      dateNow = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSSZ")
                          .parse(datetimeString.toString());
                      final daysDifference =
                          dateNow!.difference(dateStarted).inDays;
                      double months = daysDifference / 30.4375;
                      setState(() {
                        currentMonth = months.floor();
                        if (currentMonth == 0) {
                          currentMonth = 1;
                        }
                      });
                    }
                  }
                }
              } else if (dateNow != null) {
                setState(() {
                  moduleCount = state.getCourseModulesResult
                      .getOrElse(
                          () => GetCourseModulesResponseEntity(modules: null))
                      .modules;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollController
                        .jumpTo(_scrollController.position.maxScrollExtent);
                  });
                  setupCompleted = true;
                });
              }
            }
          },
          builder: (context, state) {
            if (state.status == LoadingState.LOADING ||
                setupCompleted == false) {
              return const LoadingWidget();
            }
            return SingleChildScrollView(
              controller: _scrollController,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width /
                            3 /
                            1.95 *
                            (moduleCount!) <
                        MediaQuery.of(context).size.height
                    ? MediaQuery.of(context).size.height
                    : MediaQuery.of(context).size.width /
                        3 /
                        1.95 *
                        (moduleCount!),
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/learning_journey_background.png',
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 3,
                      repeat: ImageRepeat.repeat,
                    ),
                    Positioned(
                      right: CalculateSize.getResponsiveSize(-40, screenWidth),
                      bottom:
                          CalculateSize.getResponsiveSize(-200, screenWidth),
                      child: Transform.rotate(
                        angle: -26.15 * (3.14159 / 180),
                        child: Image.asset(
                          'assets/images/learning_journey/pencil.png',
                          scale: 1.5,
                        ),
                      ),
                    ),
                    Positioned(
                      left: CalculateSize.getResponsiveSize(-40, screenWidth),
                      bottom: CalculateSize.getResponsiveSize(180, screenWidth),
                      child: Transform.rotate(
                        angle: 26.15 * (3.14159 / 180),
                        child: Image.asset(
                          'assets/images/learning_journey/pencil.png',
                          scale: 1.5,
                        ),
                      ),
                    ),
                    Positioned(
                      right: CalculateSize.getResponsiveSize(-50, screenWidth),
                      bottom: CalculateSize.getResponsiveSize(260, screenWidth),
                      child: Transform.rotate(
                        angle: 12 * (3.14159 / 180),
                        child: Image.asset(
                          'assets/images/learning_journey/rocket.png',
                          scale: 5,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: CalculateSize.getResponsiveSize(150, screenWidth),
                      child: Transform.rotate(
                        angle: 18 * (3.14159 / 180),
                        child: Image.asset(
                          'assets/images/learning_journey/earth.png',
                          scale: 7,
                        ),
                      ),
                    ),
                    Positioned(
                      right: CalculateSize.getResponsiveSize(-40, screenWidth),
                      bottom: CalculateSize.getResponsiveSize(500, screenWidth),
                      child: Image.asset(
                        'assets/images/learning_journey/keyboard.png',
                        scale: 6,
                      ),
                    ),
                    Positioned(
                      right: CalculateSize.getResponsiveSize(-40, screenWidth),
                      bottom: CalculateSize.getResponsiveSize(550, screenWidth),
                      child: Transform.rotate(
                        angle: -26.15 * (3.14159 / 180),
                        child: Image.asset(
                          'assets/images/learning_journey/pencil.png',
                          scale: 1.5,
                        ),
                      ),
                    ),
                    Positioned(
                      left: CalculateSize.getResponsiveSize(-40, screenWidth),
                      bottom: CalculateSize.getResponsiveSize(680, screenWidth),
                      child: Transform.rotate(
                        angle: 26.15 * (3.14159 / 180),
                        child: Image.asset(
                          'assets/images/learning_journey/pencil.png',
                          scale: 1.5,
                        ),
                      ),
                    ),
                    Positioned(
                      right: CalculateSize.getResponsiveSize(-50, screenWidth),
                      bottom: CalculateSize.getResponsiveSize(960, screenWidth),
                      child: Transform.rotate(
                        angle: 12 * (3.14159 / 180),
                        child: Image.asset(
                          'assets/images/learning_journey/rocket.png',
                          scale: 5,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: CalculateSize.getResponsiveSize(610, screenWidth),
                      child: Transform.rotate(
                        angle: 18 * (3.14159 / 180),
                        child: Image.asset(
                          'assets/images/learning_journey/mars.png',
                          scale: 7,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom:
                          CalculateSize.getResponsiveSize(1075, screenWidth),
                      child: Transform.rotate(
                        angle: 18 * (3.14159 / 180),
                        child: Image.asset(
                          'assets/images/learning_journey/earth.png',
                          scale: 7,
                        ),
                      ),
                    ),
                    Positioned(
                      right: CalculateSize.getResponsiveSize(-40, screenWidth),
                      bottom:
                          CalculateSize.getResponsiveSize(1200, screenWidth),
                      child: Image.asset(
                        'assets/images/learning_journey/keyboard.png',
                        scale: 6,
                      ),
                    ),
                    Stack(
                      children: List.generate(
                        moduleCount!,
                        (index) {
                          double width = MediaQuery.of(context).size.width / 3;
                          double height = width / 1.95;
                          double adjValue1 = (index % 2 == 0
                                  ? index
                                  : index - 1) *
                              (height / (width / 81.8181 * (130.9090 / width)));
                          double adjValue2 =
                              height / (width / 48 * (130.9090 / width));
                          String assetUrl = "";
                          double? leftPosition;
                          double? rightPosition;
                          double bottomPosition =
                              70 + (index * width / 1.309090) - adjValue1;
                          switch (index % 4) {
                            case 0:
                              assetUrl =
                                  'assets/images/learning_journey/vector_down_left.svg';
                              rightPosition =
                                  (MediaQuery.of(context).size.width / 2);
                              bottomPosition += adjValue2;
                              break;
                            case 1:
                              assetUrl =
                                  'assets/images/learning_journey/vector_down_right.svg';
                              leftPosition =
                                  (MediaQuery.of(context).size.width / 2);
                              bottomPosition -= adjValue2;
                              break;
                            case 2:
                              assetUrl =
                                  'assets/images/learning_journey/vector_up_right.svg';
                              leftPosition =
                                  (MediaQuery.of(context).size.width / 2);
                              bottomPosition += adjValue2;
                              break;
                            case 3:
                              assetUrl =
                                  'assets/images/learning_journey/vector_up_left.svg';
                              rightPosition =
                                  (MediaQuery.of(context).size.width / 2);
                              bottomPosition -= adjValue2;
                              break;
                          }
                          return Stack(
                            children: [
                              if (index != moduleCount! - 1)
                                Positioned(
                                  bottom: bottomPosition,
                                  right: rightPosition,
                                  left: leftPosition,
                                  child: SvgPicture.asset(
                                    assetUrl,
                                    width: width,
                                    color: index + 1 < currentMonth
                                        ? lightGreen2
                                        : index + 1 == currentMonth
                                            ? primary500
                                            : null,
                                  ),
                                ),
                              Positioned(
                                bottom: index % 2 == 0
                                    ? bottomPosition - width / 8
                                    : bottomPosition - width / 15,
                                left: index % 2 == 1
                                    ? null
                                    : index % 4 == 0
                                        ? rightPosition! - width - width / 16
                                        : null,
                                right: index % 2 == 1
                                    ? MediaQuery.of(context).size.width / 2 -
                                        width / 8
                                    : index % 4 != 0
                                        ? leftPosition! - width - width / 16
                                        : null,
                                child: SizedBox(
                                  width: width / 4,
                                  height: width / 4,
                                  child: Material(
                                    shape: CircleBorder(),
                                    elevation: 10,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: index + 1 < currentMonth
                                              ? lightGreen2
                                              : index + 1 == currentMonth
                                                  ? primary500
                                                  : lightGray2,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: Text(
                                                (index + 1).toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
