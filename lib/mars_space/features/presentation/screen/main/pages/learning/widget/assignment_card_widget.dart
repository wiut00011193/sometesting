import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mars_it_app/mars_space/core/calculation/calculate_size.dart';
import 'package:mars_it_app/mars_space/core/theme/colors.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_course_elements_response_entity.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AssignmentCard extends StatefulWidget {
  final GetCourseElementsResponseEntity courseElement;
  final int index;
  final VoidCallback onAssignmentClick;

  const AssignmentCard({
    super.key,
    required this.courseElement,
    required this.index,
    required this.onAssignmentClick,
  });

  @override
  State<AssignmentCard> createState() => _AssignmentCardState();
}

class _AssignmentCardState extends State<AssignmentCard> {
  Color iconBoxColor = Colors.transparent;
  Color textBoxColor = Colors.transparent;
  Color textColor = Colors.transparent;
  SvgPicture? svgIcon;
  double iconSvgPadding = 0;

  @override
  void initState() {
    super.initState();

    switch (widget.courseElement.status) {
      case 'denied':
        textBoxColor = Colors.white;
        textColor = const Color(0xffFACC15);
      case 'closed':
        iconBoxColor = const Color(0xffFAFAFA);
        textBoxColor = iconBoxColor;
        svgIcon = SvgPicture.asset('assets/icons/ic_assignment_closed.svg');
        iconSvgPadding = 3;
        break;
      case 'uploaded':
        iconBoxColor = const Color(0xff335EF7).withOpacity(0.08);
        textBoxColor = iconBoxColor;
        textColor = const Color(0xff00A9F1);
        svgIcon = SvgPicture.asset('assets/icons/ic_assignment_pending.svg');
        iconSvgPadding = 3;
        break;
      case 'marked':
        if (widget.courseElement.mark != null &&
            widget.courseElement.mark! > 0) {
          iconBoxColor = const Color(0xffF2FFFC);
          svgIcon = SvgPicture.asset('assets/icons/ic_assignment_passed.svg');
          iconSvgPadding = 3.5;

          if (widget.courseElement.mark! <= 33) {
            textBoxColor = const Color(0xffFACC15).withOpacity(0.08);
            textColor = const Color(0xffFACC15);
          } else if (widget.courseElement.mark! <= 66) {
            textBoxColor = const Color(0xffFF9800).withOpacity(0.08);
            textColor = const Color(0xffFF981F);
          } else if (widget.courseElement.mark! <= 100) {
            textBoxColor = const Color(0xffF2FFFC);
            textColor = const Color(0xff4ADE80);
          }
        } else {
          iconBoxColor = const Color(0xffF75555).withOpacity(0.08);
          textBoxColor = iconBoxColor;
          textColor = const Color(0xffF75555);
          svgIcon = SvgPicture.asset('assets/icons/ic_assignment_failed.svg');
          iconSvgPadding = 4;
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: widget.courseElement.status != 'closed'
          ? widget.onAssignmentClick
          : null,
      child: Material(
        elevation: 2,
        shadowColor:
            widget.courseElement.status == 'denied' ? Colors.transparent : null,
        color: widget.courseElement.status == 'denied'
            ? const Color(0xffFACC15).withOpacity(0.8)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: widget.courseElement.status != 'opened'
              ? null
              : const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFF7D58),
                      Color(0xFFE33D0E),
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
          child: Padding(
            padding: EdgeInsets.all(
                CalculateSize.getResponsiveSize(12, screenWidth)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: CalculateSize.getResponsiveSize(118, screenWidth),
                      child: Text(
                        widget.courseElement.title!.uz!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: widget.courseElement.status == 'closed'
                              ? const Color(0xff757575)
                              : widget.courseElement.status == 'opened' ||
                                      widget.courseElement.status == 'denied'
                                  ? Colors.white
                                  : accentColor,
                          fontSize:
                              CalculateSize.getResponsiveSize(18, screenWidth),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      width: CalculateSize.getResponsiveSize(18, screenWidth),
                      height: CalculateSize.getResponsiveSize(18, screenWidth),
                      decoration: BoxDecoration(
                        color: iconBoxColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(CalculateSize.getResponsiveSize(
                            iconSvgPadding, screenWidth)),
                        child: svgIcon,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                    height: CalculateSize.getResponsiveSize(4, screenWidth)),
                Text(
                  '${widget.courseElement.about!.uz!}\n',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    color: widget.courseElement.status == 'denied'
                        ? lightGray5
                        : widget.courseElement.status == 'opened'
                            ? primary300
                            : lightGray2,
                    fontSize: CalculateSize.getResponsiveSize(12, screenWidth),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                    height: CalculateSize.getResponsiveSize(16, screenWidth)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.courseElement.status == 'closed'
                            ? lightGray5
                            : lightGray3,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                CalculateSize.getResponsiveSize(6, screenWidth),
                            vertical: CalculateSize.getResponsiveSize(
                                2, screenWidth)),
                        child: Text(
                          widget.index >= 10
                              ? widget.index.toString()
                              : '0${widget.index}',
                          style: TextStyle(
                            color: widget.courseElement.status == 'denied'
                                ? const Color(0xffFACC15)
                                : widget.courseElement.status == 'opened'
                                    ? primaryColor
                                    : lightGray2,
                            fontSize: CalculateSize.getResponsiveSize(
                                16, screenWidth),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    if (widget.courseElement.status == 'uploaded' ||
                        widget.courseElement.status == 'marked' ||
                        widget.courseElement.status == 'denied')
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width / 5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: textBoxColor,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: CalculateSize.getResponsiveSize(
                                    6, screenWidth),
                                vertical: CalculateSize.getResponsiveSize(
                                    2, screenWidth)),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                widget.courseElement.status == 'denied'
                                    ? 'Denied'
                                    : widget.courseElement.status == 'marked'
                                        ? widget.courseElement.mark.toString()
                                        : 'Pending',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: CalculateSize.getResponsiveSize(
                                      14, screenWidth),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
