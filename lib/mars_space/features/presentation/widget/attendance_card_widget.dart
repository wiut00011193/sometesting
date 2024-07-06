import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mars_it_app/mars_space/core/calculation/calculate_size.dart';
import 'package:mars_it_app/mars_space/core/theme/colors.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/attendance_response_entity.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_group_attendance_response_entity.dart';

class AttendanceCardWidget extends StatefulWidget {
  final List<AttendanceResponseEntity> attendanceList;
  final VoidCallback onExpandButtonClick;
  final GetGroupAttendanceResponseEntity groupAttendance;
  const AttendanceCardWidget({
    super.key,
    required this.attendanceList,
    required this.onExpandButtonClick,
    required this.groupAttendance,
  });

  @override
  State<AttendanceCardWidget> createState() => _AttendanceCardWidgetState();
}

class _AttendanceCardWidgetState extends State<AttendanceCardWidget> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Material(
      elevation: 2,
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: CalculateSize.getResponsiveSize(16, screenWidth),
            vertical: CalculateSize.getResponsiveSize(13, screenWidth)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.attendance,
                      style: TextStyle(
                        color: accentColor,
                        fontSize:
                            CalculateSize.getResponsiveSize(18, screenWidth),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.text_lesson_count,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize:
                            CalculateSize.getResponsiveSize(14, screenWidth),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: widget.onExpandButtonClick,
                  child: InkWell(
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.text_attendance_see_all,
                          style: TextStyle(
                            color: accentColor,
                            fontSize: CalculateSize.getResponsiveSize(
                                14, screenWidth),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                            width: CalculateSize.getResponsiveSize(
                                8, screenWidth)),
                        SvgPicture.asset('assets/icons/ic_next_signup.svg'),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: CalculateSize.getResponsiveSize(17, screenWidth)),
            if (widget.groupAttendance.days != null)
              Wrap(
                spacing: CalculateSize.getResponsiveSize(18, screenWidth),
                runSpacing: CalculateSize.getResponsiveSize(12, screenWidth),
                children: List.generate(
                  widget.groupAttendance.days!.length,
                  (index) {
                    return Column(
                      children: [
                        Container(
                          width:
                              CalculateSize.getResponsiveSize(37, screenWidth),
                          height:
                              CalculateSize.getResponsiveSize(37, screenWidth),
                          decoration: BoxDecoration(
                            color:
                                widget.groupAttendance.days![index].holiday !=
                                        null
                                    ? null
                                    : widget.attendanceList.any((element) =>
                                            element.attendDate ==
                                            widget.groupAttendance.days![index]
                                                .date)
                                        ? widget.attendanceList
                                                    .firstWhere((element) =>
                                                        element.attendDate ==
                                                        widget.groupAttendance
                                                            .days![index].date)
                                                    .attendanceType ==
                                                1
                                            ? const Color(0xffF2FFFC)
                                            : const Color(0xffF75555).withOpacity(0.05)
                                        : lightGray5,
                            shape: BoxShape.circle,
                          ),
                          child: widget.groupAttendance.days![index].holiday !=
                                  null
                              ? Image.asset('assets/images/events.png')
                              : Padding(
                                  padding: EdgeInsets.all(
                                      CalculateSize.getResponsiveSize(
                                          13, screenWidth)),
                                  child: widget.attendanceList.isNotEmpty &&
                                          index < widget.attendanceList.length
                                      ? (widget.attendanceList[index]
                                                  .attendanceType! ==
                                              1
                                          ? SvgPicture.asset(
                                              'assets/images/attendance_positive.svg')
                                          : SvgPicture.asset(
                                              'assets/images/attendance_negative.svg'))
                                      : null,
                                ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          (index + 1).toString(),
                          style: TextStyle(
                            color: accentColor,
                            fontSize: CalculateSize.getResponsiveSize(
                                14, screenWidth),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            // SizedBox(
            //   width: 318,
            //   height: 136,
            //   child: GridView.count(
            //     crossAxisSpacing: 18.0,
            //     mainAxisSpacing: 30.0,
            //     crossAxisCount: 6,
            //     children: List.generate(
            //       12,
            //       (index) {
            //         return GridTile(
            //           child: Column(
            //             children: [
            //               Container(
            //                 width: 38,
            //                 height: 38,
            //                 decoration: BoxDecoration(
            //                   color: lightGray,
            //                   shape: BoxShape.circle,
            //                 ),
            //               ),
            //               const SizedBox(height: 4),
            //               Text(
            //                 (index + 1).toString(),
            //                 style: TextStyle(
            //                   color: accentColor,
            //                   fontSize: 14,
            //                   fontWeight: FontWeight.w600,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         );
            //       },
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
