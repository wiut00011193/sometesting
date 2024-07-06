import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mars_it_app/injection_handler.dart';
import 'package:mars_it_app/mars_space/core/calculation/calculate_size.dart';
import 'package:mars_it_app/mars_space/core/theme/colors.dart';
import 'package:mars_it_app/mars_space/core/theme/theme.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mars_it_app/mars_space/core/utils/constants.dart';
import 'package:mars_it_app/mars_space/features/data/enum/loading_state_enum.dart';
import 'package:mars_it_app/mars_space/features/data/model/response/attendance_response_model.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/get_month_attendance_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/attendance_response_entity.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/main/pages/home/bloc/home_bloc.dart';
import 'package:mars_it_app/mars_space/features/presentation/widget/loading_widget.dart';

class AttendancePage extends StatefulWidget {
  final DateTime dateStarted;
  const AttendancePage({
    super.key,
    required this.dateStarted,
  });

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final HomeBloc _homeBloc = di.get<HomeBloc>();
  late final PageController _pageController;
  int selectedMonthIndex = 0;

  DateTime? fromDate;
  DateTime? tillDate;

  DateTime? dateNow;

  List<List<AttendanceResponseEntity>> attendanceList = [];

  bool allAttendanceLoaded = false;

  late List<String> allignedMonthList = [
    AppLocalizations.of(context)!.january_full,
    AppLocalizations.of(context)!.february_full,
    AppLocalizations.of(context)!.march_full,
    AppLocalizations.of(context)!.april_full,
    AppLocalizations.of(context)!.may_full,
    AppLocalizations.of(context)!.june_full,
    AppLocalizations.of(context)!.july_full,
    AppLocalizations.of(context)!.august_full,
    AppLocalizations.of(context)!.september_full,
    AppLocalizations.of(context)!.october_full,
    AppLocalizations.of(context)!.november_full,
    AppLocalizations.of(context)!.december_full,
  ];

  late final List<String> daysOfWeek = [
      AppLocalizations.of(context)!.monday_short,
      AppLocalizations.of(context)!.tuesday_short,
      AppLocalizations.of(context)!.wednesday_short,
      AppLocalizations.of(context)!.thursday_short,
      AppLocalizations.of(context)!.friday_short,
      AppLocalizations.of(context)!.saturday_short,
      AppLocalizations.of(context)!.sunday_short,
    ];

  @override
  void initState() {
    super.initState();

    getDateNow();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> getDateNow() async {
    final datetimeString = await di<Dio>().get(EndPoints.path_get_datetime);
    DateTime datetime = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSSZ")
        .parse(datetimeString.toString());
    setState(() {
      dateNow = datetime;
      fromDate = firstDayOfMonth(widget.dateStarted);
      tillDate = lastDayOfMonth(fromDate!);
      _homeBloc.add(GetMonthAttendanceEvent(
          getMonthAttendanceRequest: GetMonthAttendanceRequestEntity(
              fromDate: formatDate(fromDate!),
              tillDate: formatDate(tillDate!))));
    });
  }

  DateTime firstDayOfMonth(DateTime dateTime) {
    final date = DateTime(dateTime.year, dateTime.month, 1);
    return date;
  }

  DateTime lastDayOfMonth(DateTime dateTime) {
    final beginningOfNextMonth = dateTime.month < 12
        ? DateTime(dateTime.year, dateTime.month + 1, 1)
        : DateTime(dateTime.year + 1, 1, 1);
    final date = beginningOfNextMonth.subtract(const Duration(days: 1));
    return date;
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: SvgPicture.asset(
            'assets/icons/ic_back_button.svg',
            width: CalculateSize.getResponsiveSize(24, screenWidth),
            height: CalculateSize.getResponsiveSize(24, screenWidth),
            fit: BoxFit.scaleDown,
          ),
        ),
        titleSpacing: 0,
        title: Text(
          AppLocalizations.of(context)!.pageTitleAttendance,
          style: TextStyle(
            color: accentColor,
            fontSize: CalculateSize.getResponsiveSize(24, screenWidth),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => _homeBloc,
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state.status == LoadingState.LOADED) {
              final attendance = state.monthAttendance.getOrElse(
                  () => throw Exception('NO MONTH ATTENDANCE FOUND'));
              attendanceList.add(attendance);

              setState(() {
                if (attendanceList.length == 1) {
                  int monthIndex =
                      DateTime.parse(attendanceList[0][0].attendDate!).month -
                          1;
                  allignedMonthList = [
                    ...allignedMonthList.sublist(monthIndex),
                    ...allignedMonthList.sublist(0, monthIndex)
                  ];
                }

                if (fromDate!.month == dateNow!.month &&
                    fromDate!.year == dateNow!.year) {
                  for (int i = 0; i < attendanceList.length; i++) {
                    if (attendanceList[i].isEmpty) {
                      attendanceList.removeAt(i);
                    }
                  }

                  selectedMonthIndex = attendanceList.length - 1;
                  _pageController =
                      PageController(initialPage: selectedMonthIndex);
                  allAttendanceLoaded = true;
                  return;
                }
                fromDate =
                    firstDayOfMonth(fromDate!.add(const Duration(days: 32)));
                tillDate = lastDayOfMonth(fromDate!);

                _homeBloc.add(GetMonthAttendanceEvent(
                    getMonthAttendanceRequest: GetMonthAttendanceRequestEntity(
                        fromDate: formatDate(fromDate!),
                        tillDate: formatDate(tillDate!))));
              });
            }
          },
          builder: (context, state) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(gradient: gradient),
              child: state.status == LoadingState.LOADING ||
                      !allAttendanceLoaded
                  ? const LoadingWidget()
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 1,
                            color: lightGray,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: CalculateSize.getResponsiveSize(
                                  20, screenWidth),
                              right: CalculateSize.getResponsiveSize(
                                  20, screenWidth),
                              top: CalculateSize.getResponsiveSize(
                                  12, screenWidth),
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: Material(
                                elevation: 2,
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          CalculateSize.getResponsiveSize(
                                              16, screenWidth),
                                      vertical: CalculateSize.getResponsiveSize(
                                          12, screenWidth)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (allAttendanceLoaded)
                                        Text(
                                          DateFormat('yyyy').format(
                                              DateTime.parse(attendanceList[
                                                      selectedMonthIndex][0]
                                                  .attendDate!)),
                                          style: TextStyle(
                                            color: accentColor,
                                            fontSize:
                                                CalculateSize.getResponsiveSize(
                                                    10, screenWidth),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      SizedBox(
                                          height:
                                              CalculateSize.getResponsiveSize(
                                                  4, screenWidth)),
                                      Text(
                                        allignedMonthList[
                                            selectedMonthIndex % 12],
                                        style: TextStyle(
                                          color: accentColor,
                                          fontSize:
                                              CalculateSize.getResponsiveSize(
                                                  18, screenWidth),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .text_attendance_table,
                                        style: TextStyle(
                                            color: lightGray2,
                                            fontSize:
                                                CalculateSize.getResponsiveSize(
                                                    14, screenWidth),
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                          height:
                                              CalculateSize.getResponsiveSize(
                                                  16, screenWidth)),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: lightGray3,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: CalculateSize
                                                  .getResponsiveSize(
                                                      8, screenWidth)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: List.generate(
                                              daysOfWeek.length,
                                              (index) => SizedBox(
                                                width: CalculateSize
                                                    .getResponsiveSize(
                                                        38, screenWidth),
                                                child: Center(
                                                  child: FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Text(
                                                      daysOfWeek[index],
                                                      style: TextStyle(
                                                        color: lightGray2,
                                                        fontSize: CalculateSize
                                                            .getResponsiveSize(
                                                                12,
                                                                screenWidth),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              CalculateSize.getResponsiveSize(
                                                  16, screenWidth)),
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxHeight:
                                              CalculateSize.getResponsiveSize(
                                                  420, screenWidth),
                                        ),
                                        child: PageView.builder(
                                          controller: _pageController,
                                          itemCount: attendanceList.length,
                                          onPageChanged: (index) {
                                            setState(() {
                                              selectedMonthIndex = index;
                                            });
                                          },
                                          itemBuilder: (context, index) {
                                            return buildMonthAttendaceWidget(
                                                index,
                                                lastDayOfMonth(DateTime.parse(
                                                        attendanceList[index][0]
                                                            .attendDate!))
                                                    .day);
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              CalculateSize.getResponsiveSize(
                                                  16, screenWidth)),
                                      SizedBox(
                                        height: CalculateSize.getResponsiveSize(
                                            12, screenWidth),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: CalculateSize
                                                  .getResponsiveSize(
                                                      100, screenWidth)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: List.generate(
                                              attendanceList.length,
                                              (monthIndex) =>
                                                  selectedMonthIndex !=
                                                          monthIndex
                                                      ? Container()
                                                      : Row(
                                                          children:
                                                              List.generate(
                                                            attendanceList
                                                                        .length <=
                                                                    5
                                                                ? attendanceList
                                                                    .length
                                                                : 5,
                                                            (index) => Row(
                                                              children: [
                                                                if (index != 0)
                                                                  SizedBox(
                                                                      width: CalculateSize
                                                                          .getResponsiveSize(
                                                                              8,
                                                                              screenWidth)),
                                                                Container(
                                                                  width: CalculateSize
                                                                      .getResponsiveSize(
                                                                          12,
                                                                          screenWidth),
                                                                  height: CalculateSize
                                                                      .getResponsiveSize(
                                                                          12,
                                                                          screenWidth),
                                                                  decoration: attendanceList
                                                                              .length <=
                                                                          5
                                                                      ? BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          color: selectedMonthIndex == index
                                                                              ? primary400
                                                                              : lightGray5)
                                                                      : BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle,
                                                                          color: selectedMonthIndex >= 2 && selectedMonthIndex <= attendanceList.length - 3 && index == (5 / 2).floor()
                                                                              ? primary400
                                                                              : (selectedMonthIndex == index && selectedMonthIndex <= 1) || (5 - index == 1 && attendanceList.length - monthIndex == 1) || (5 - index == 2 && attendanceList.length - monthIndex == 2)
                                                                                  ? primary400
                                                                                  : (selectedMonthIndex == 2 && index == 0) || (selectedMonthIndex == attendanceList.length - 3 && index == 5 - 1)
                                                                                      ? lightGray5.withOpacity(0.6)
                                                                                      : (5 - index == 5 && selectedMonthIndex > 2) || (5 - index == 1 && selectedMonthIndex < attendanceList.length - 3)
                                                                                          ? lightGray5.withOpacity(0.3)
                                                                                          : (5 - index == 5 - 1 && selectedMonthIndex > 2) || (5 - index == 2 && selectedMonthIndex < attendanceList.length - 3)
                                                                                              ? lightGray5.withOpacity(0.6)
                                                                                              : lightGray5),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              CalculateSize.getResponsiveSize(
                                                  8, screenWidth)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              height: CalculateSize.getResponsiveSize(
                                  20, screenWidth)),
                        ],
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }

  List<DateTime> getPreviousMonthDays(DateTime firstDayOfCurrentMonth) {
    int weekday = firstDayOfCurrentMonth.weekday;
    List<DateTime> previousMonthDays = [];
    for (int i = 1; i < weekday; i++) {
      previousMonthDays.add(firstDayOfCurrentMonth.subtract(Duration(days: i)));
    }
    previousMonthDays = previousMonthDays.reversed.toList();
    return previousMonthDays;
  }

  List<DateTime> getNextMonthDays(
      DateTime lastDayOfCurrentMonth, int totalDays) {
    int nextDaysCount = 42 - totalDays;
    List<DateTime> nextMonthDays = [];
    for (int i = 1; i <= nextDaysCount; i++) {
      nextMonthDays.add(lastDayOfCurrentMonth.add(Duration(days: i)));
    }
    return nextMonthDays;
  }

  Widget buildMonthAttendaceWidget(int monthIndex, int dayCount) {
    final screenWidth = MediaQuery.of(context).size.width;
    DateTime firstDayOfCurrentMonth = firstDayOfMonth(
        DateTime.parse(attendanceList[monthIndex][0].attendDate!));
    DateTime lastDayOfCurrentMonth = lastDayOfMonth(firstDayOfCurrentMonth);

    List<DateTime> previousMonthDays =
        getPreviousMonthDays(firstDayOfCurrentMonth);
    List<DateTime> nextMonthDays = getNextMonthDays(
        lastDayOfCurrentMonth, previousMonthDays.length + dayCount);

    List<DateTime> allDays = [
      ...previousMonthDays,
      ...List.generate(dayCount,
          (index) => firstDayOfCurrentMonth.add(Duration(days: index))),
      ...nextMonthDays,
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 12,
      children: List.generate(
        allDays.length,
        (index) {
          DateTime day = allDays[index];
          final isCurrentMonth = day.month == firstDayOfCurrentMonth.month;
          final attendanceType = attendanceList[monthIndex]
              .firstWhere(
                (element) =>
                    DateTime.parse(element.attendDate!).day == day.day &&
                    DateTime.parse(element.attendDate!).month == day.month,
                orElse: () => AttendanceResponseModel(
                  attendDate: null,
                  attendanceType: null,
                ),
              )
              .attendanceType;
          return Column(
            children: [
              Container(
                  width: CalculateSize.getResponsiveSize(38, screenWidth),
                  height: CalculateSize.getResponsiveSize(38, screenWidth),
                  decoration: BoxDecoration(
                    color: attendanceType != null
                        ? attendanceType == 1
                            ? const Color(0xffF2FFFC)
                            : const Color(0xffF75555).withOpacity(0.05)
                        : lightGray5.withOpacity(isCurrentMonth ? 0.8 : 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(
                        CalculateSize.getResponsiveSize(13, screenWidth)),
                    child: attendanceType != null
                        ? attendanceType == 1
                            ? SvgPicture.asset(
                                'assets/images/attendance_positive.svg')
                            : SvgPicture.asset(
                                'assets/images/attendance_negative.svg')
                        : null,
                  )),
              SizedBox(height: CalculateSize.getResponsiveSize(4, screenWidth)),
              SizedBox(
                width: CalculateSize.getResponsiveSize(14, screenWidth),
                height: CalculateSize.getResponsiveSize(14, screenWidth),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    day.day.toString(),
                    style: TextStyle(
                      color: isCurrentMonth ? accentColor : lightGray,
                      fontSize:
                          CalculateSize.getResponsiveSize(12, screenWidth),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
