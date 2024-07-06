import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mars_it_app/injection_handler.dart';
import 'package:mars_it_app/mars_space/core/calculation/calculate_size.dart';
import 'package:mars_it_app/mars_space/core/theme/colors.dart';
import 'package:mars_it_app/mars_space/core/utils/constants.dart';
import 'package:mars_it_app/mars_space/core/utils/output_utils.dart';
import 'package:mars_it_app/mars_space/features/data/enum/loading_state_enum.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/get_stories_request_model.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/get_group_attendance_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/attendance_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/child_balance_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_extra_lessons_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_group_attendance_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_stories_response_entity.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/auth/login/login_screen.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/booking/widget/booked_lesson_card_widget.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/main/pages/home/bloc/home_bloc.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/main/pages/home/page/attendance_page.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/main/pages/home/page/story_page.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/main/pages/home/widget/story_circle_widget.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/notification/notification_screen.dart';
import 'package:mars_it_app/mars_space/features/presentation/widget/attendance_card_widget.dart';
import 'package:mars_it_app/mars_space/features/presentation/widget/balance_card_widget.dart';
import 'package:mars_it_app/mars_space/features/presentation/widget/loading_widget.dart';
import 'package:mars_it_app/mars_space/features/presentation/widget/payment_widget.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../../core/theme/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _homeBloc = di.get<HomeBloc>();
  DateTime? dateStarted;
  List<AttendanceResponseEntity> attendanceList = [];
  ChildBalanceResponseEntity balanceEntity = ChildBalanceResponseEntity();
  List<GetExtraLessonsResponseEntity> extraLessons = [];
  bool isStoryClicked = false;
  int clickedStoryIndex = 0;

  GetGroupAttendanceResponseEntity? groupAttendance;

  List<String> storyTypeList = [
    "events",
    "",
    "",
    "",
  ];
  late List<String> storyTitleList = [
    AppLocalizations.of(context)!.text_story_type_events,
    AppLocalizations.of(context)!.text_story_type_news,
    AppLocalizations.of(context)!.text_story_type_rules,
    AppLocalizations.of(context)!.text_story_type_students,
  ];
  List<String> storyIconUrlList = [
    "assets/images/events.png",
    "assets/images/news.png",
    "assets/images/rules.png",
    "assets/images/students.png",
  ];

  @override
  void initState() {
    _homeBloc.add(GetBalanceEvent());
    _homeBloc.add(GetExtraLessonsEvent());
    _homeBloc.add(GetAttendanceEvent());
    super.initState();
  }

  Future<void> _triggerGroupAttendanceEvent(int groupId) async {
    final datetimeString = await di.get<Dio>().get(EndPoints.path_get_datetime);
    DateTime dateNow = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSSZ")
        .parse(datetimeString.toString());

    DateTime fromDate = DateTime(dateNow.year, dateNow.month, 1);

    DateTime beginningOfNextMonth = fromDate.month != 12
        ? DateTime(fromDate.year, fromDate.month + 1, 1)
        : DateTime(fromDate.year + 1, 1, 1);

    DateTime tillDate = beginningOfNextMonth.subtract(const Duration(days: 1));

    _homeBloc.add(GetGroupAttendanceEvent(
      getGroupAttendanceRequest: GetGroupAttendanceRequestEntity(
        groupId: groupId,
        fromDate: DateFormat('yyyy-MM-dd').format(fromDate),
        tillDate: DateFormat('yyyy-MM-dd').format(tillDate),
      ),
    ));
  }

  void onStoryClick(int index) {
    setState(() {
      isStoryClicked = true;
      clickedStoryIndex = index;
    });

    _homeBloc.add(GetStories(
        requestModel:
            GetStoriesRequestModel(type: storyTypeList[clickedStoryIndex])));
  }

  Future<void> _openStoryPage(List<GetStoriesResponseEntity> stories) async {
    final moveToNextStory = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryPage(
          storyTitle: storyTitleList[clickedStoryIndex],
          iconUrl: storyIconUrlList[clickedStoryIndex],
          stories: stories,
        ),
      ),
    );

    if (moveToNextStory != null && moveToNextStory) {
      // TO BE CHANGED LATER
      setState(() {
        clickedStoryIndex++;
      });
      if (clickedStoryIndex <= 1) {
        onStoryClick(clickedStoryIndex);
      } else {
        setState(() {
          isStoryClicked = false;
        });
      }
    } else {
      setState(() {
        isStoryClicked = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.only(
              left: CalculateSize.getResponsiveSize(16, screenWidth)),
          child: SizedBox(
            height: CalculateSize.getResponsiveSize(22, screenWidth),
            child: Image.asset("assets/images/mars_logo_appbar.png"),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _homeBloc.add(LogOut());
              },
              icon: Icon(
                Icons.logout,
                color: primaryColor,
              )),
          Padding(
            padding: EdgeInsets.only(
                right: CalculateSize.getResponsiveSize(12, screenWidth)),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                );
              },
              icon: SvgPicture.asset(
                'assets/icons/ic_notification.svg',
                width: CalculateSize.getResponsiveSize(22, screenWidth),
                height: CalculateSize.getResponsiveSize(22, screenWidth),
              ),
            ),
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => _homeBloc,
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state.authStatus == AuthState.SIGNIN) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            } else if (state.status == LoadingState.LOADED) {
              setState(() {
                attendanceList = state.childAttendance
                    .getOrElse(() => throw Exception('NO ATTENDACE FOUND'));
                if (balanceEntity.balance == null) {
                  balanceEntity = state.childBalance
                      .getOrElse(() => ChildBalanceResponseEntity());
                }

                if (extraLessons.isEmpty) {
                  final extraLessons =
                      state.getExtraLessonsResult.getOrElse(() => []);
                  for (int i = 0; i < extraLessons.length; i++) {
                    if (extraLessons[i].data!.isNotEmpty) {
                      this.extraLessons.add(extraLessons[i]);
                    }
                  }
                }

                if (balanceEntity.groups != null &&
                    balanceEntity.groups!.isNotEmpty &&
                    dateStarted == null) {
                  dateStarted = DateTime.parse(
                      balanceEntity.groups![0].dateStarted!.substring(0, 10));
                  final groupId = balanceEntity.groups!.last.id;
                  _triggerGroupAttendanceEvent(groupId!);
                }
              });

              final getGroupAttendanceResult = state.getGroupAttendanceResult
                  .getOrElse(() => GetGroupAttendanceResponseEntity());
              if (getGroupAttendanceResult.days != null) {
                groupAttendance = getGroupAttendanceResult;
              }

              if (isStoryClicked) {
                final stories = state.stories
                    .getOrElse(() => throw Exception('NO STORY FOUND'));
                _openStoryPage(stories);
              }
            } else if (state.status == LoadingState.ERROR) {
              if (state.errorMessage == 'Exception: Unauthorized' ||
                  state.errorMessage == 'Exception: Forbidden') {
                _homeBloc.add(LogOut());
              }
              toast('Xato yuzga chiqdi');
            }
          },
          builder: (context, state) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(gradient: gradient),
              child: Builder(builder: (context) {
                if (state.status == LoadingState.LOADING || groupAttendance == null) {
                  return const LoadingWidget();
                } else if (state.status == LoadingState.LOADED) {
                  return Column(
                    children: [
                      Container(
                        height: 1,
                        color: lightGray4,
                      ),

                      // events and news
                      Padding(
                        padding: EdgeInsets.all(
                            CalculateSize.getResponsiveSize(10, screenWidth)),
                        child: Row(
                          children: List.generate(
                            4,
                            (index) => Padding(
                              padding: EdgeInsets.only(
                                  left: CalculateSize.getResponsiveSize(
                                      10, screenWidth)),
                              child: StoryCircleWidget(
                                title: storyTitleList[index],
                                imageUrl: storyIconUrlList[index],
                                onStoryClick: () {
                                  if (index > 1) {
                                    toast(
                                        '${storyTitleList[index]} mavjud emas');
                                    return;
                                  }
                                  if (isStoryClicked) return;
                                  onStoryClick(index);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                          height:
                              CalculateSize.getResponsiveSize(26, screenWidth)),

                      // Child Full name
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: CalculateSize.getResponsiveSize(
                                20, screenWidth),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${balanceEntity.firstName} ${balanceEntity.lastName}",
                                      style: TextStyle(
                                        fontSize:
                                            CalculateSize.getResponsiveSize(
                                                24, screenWidth),
                                        fontWeight: FontWeight.w700,
                                        color: accentColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height: CalculateSize.getResponsiveSize(
                                        26, screenWidth)),
                                // Child balance card
                                if (balanceEntity.balance != null)
                                  BalanceCardWidget(
                                    childBalance: balanceEntity,
                                    onPayButtonClick: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) =>
                                            PaymentBottomSheetWidget(
                                          paymentUrl:
                                              balanceEntity.paymentLink!,
                                        ),
                                      );
                                    },
                                  ),

                                if (balanceEntity.balance != null)
                                  SizedBox(
                                      height: CalculateSize.getResponsiveSize(
                                          12, screenWidth)),

                                if (extraLessons.isNotEmpty)
                                  Column(
                                    children: List.generate(
                                      extraLessons.length,
                                      (index) => extraLessons[index]
                                                      .data![0]
                                                      .status ==
                                                  'not_came' ||
                                              extraLessons[index]
                                                      .data![0]
                                                      .status ==
                                                  'canceled'
                                          ? Column(
                                              children: [
                                                BookedLessonCardWidget(
                                                  extraLesson:
                                                      extraLessons[index],
                                                ),
                                                SizedBox(
                                                    height: CalculateSize
                                                        .getResponsiveSize(
                                                            10, screenWidth)),
                                              ],
                                            )
                                          : Container(),
                                    ),
                                  ),

                                if (extraLessons.isNotEmpty)
                                  SizedBox(
                                      height: CalculateSize.getResponsiveSize(
                                          2, screenWidth)),
                                if (groupAttendance != null)
                                  AttendanceCardWidget(
                                    attendanceList: attendanceList,
                                    groupAttendance: groupAttendance!,
                                    onExpandButtonClick: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AttendancePage(
                                                    dateStarted: dateStarted!)),
                                      );
                                    },
                                  ),
                                SizedBox(
                                    height: CalculateSize.getResponsiveSize(
                                        12, screenWidth)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return const LoadingWidget();
              }),
            );
          },
        ),
      ),
    );
  }
}
