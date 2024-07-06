import 'package:flutter/material.dart';
import 'package:mars_it_app/mars_space/core/calculation/calculate_size.dart';
import 'package:mars_it_app/mars_space/core/theme/colors.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_extra_lessons_response_entity.dart';

class BookedLessonCardWidget extends StatefulWidget {
  final GetExtraLessonsResponseEntity extraLesson;
  const BookedLessonCardWidget({
    super.key,
    required this.extraLesson,
  });

  @override
  State<BookedLessonCardWidget> createState() => _BookedLessonCardWidgetState();
}

class _BookedLessonCardWidgetState extends State<BookedLessonCardWidget> {
  String getWeekday(int weekday) {
    switch (weekday) {
      case 1:
        return 'Dushanba';
      case 2:
        return 'Seshanba';
      case 3:
        return 'Chorshanba';
      case 4:
        return 'Payshanba';
      case 5:
        return 'Juma';
      case 6:
        return 'Shanba';
      case 7:
        return 'Yakshanba';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: CalculateSize.getResponsiveSize(135, screenWidth),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: CalculateSize.getResponsiveSize(16, screenWidth),
              vertical: CalculateSize.getResponsiveSize(12, screenWidth)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.extraLesson.data![0].status == 'canceled'
                            ? 'Bekor qilindi'
                            : AppLocalizations.of(context)!.booked,
                        style: TextStyle(
                          color:
                              widget.extraLesson.data![0].status == 'canceled'
                                  ? errorColor
                                  : lightBlue2,
                          fontSize:
                              CalculateSize.getResponsiveSize(12, screenWidth),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                          height:
                              CalculateSize.getResponsiveSize(4, screenWidth)),
                      Text(
                        '${widget.extraLesson.data![0].tutor!.firstName!} ${widget.extraLesson.data![0].tutor!.lastName!}',
                        style: TextStyle(
                          color: accentColor,
                          fontSize:
                              CalculateSize.getResponsiveSize(18, screenWidth),
                          fontWeight: FontWeight.w700,
                        ),
                      ), 
                      Text(
                        'Frontend tutor',
                        style: TextStyle(
                          color: lightGray2,
                          fontSize:
                              CalculateSize.getResponsiveSize(16, screenWidth),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: CalculateSize.getResponsiveSize(56, screenWidth),
                    height: CalculateSize.getResponsiveSize(56, screenWidth),
                    decoration: BoxDecoration(
                      color: lightGreen4,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(
                          CalculateSize.getResponsiveSize(6, screenWidth)),
                      child: Image.asset('assets/images/emojis/emoji4.png'),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: CalculateSize.getResponsiveSize(6, screenWidth)),
                child: Text(
                  '${getWeekday(DateTime.parse(widget.extraLesson.forDate!).weekday)} ${widget.extraLesson.data![0].slot!.fromHour!.substring(0, 5)}',
                  style: TextStyle(
                    color: widget.extraLesson.data![0].status == 'canceled'
                        ? accentColor
                        : lightBlue2,
                    fontSize: CalculateSize.getResponsiveSize(14, screenWidth),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
