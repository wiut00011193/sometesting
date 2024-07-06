import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mars_it_app/mars_space/core/calculation/calculate_size.dart';
import 'package:mars_it_app/mars_space/core/theme/colors.dart';
import 'package:mars_it_app/mars_space/core/theme/theme.dart';
import 'package:mars_it_app/mars_space/core/utils/constants.dart';
import 'package:mars_it_app/mars_space/core/utils/output_utils.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/add_extra_lesson_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_tutors_response_entity.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/booking/widget/book_date_bottom_sheet.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/booking/widget/book_tutor_bottom_sheet.dart';

class BookLessonPage extends StatefulWidget {
  const BookLessonPage({
    super.key
  });

  @override
  State<BookLessonPage> createState() => _BookLessonPageState();
}

class _BookLessonPageState extends State<BookLessonPage> {
  GetTutorsResponseEntity? selectedTutor;
  Map<String, String>? userSlotMap;
  int? weekDayId;

  List<String> daysOfWeek = [
    'Dushanba',
    'Seshanba',
    'Chorshanba',
    'Payshanba',
    'Juma',
    'Shanba',
  ];

  void setWeekdayId(String weekday) {
    setState(() {
      switch (weekday) {
        case 'monday':
          weekDayId = 0;
          break;
        case 'tuesday':
          weekDayId = 1;
          break;
        case 'wednesday':
          weekDayId = 2;
          break;
        case 'thursday':
          weekDayId = 3;
          break;
        case 'friday':
          weekDayId = 4;
          break;
        case 'saturday':
          weekDayId = 5;
          break;
      }
    });
  }

  Future<void> _openBookTutorBottomModalSheet() async {
    final GetTutorsResponseEntity? tutor = await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => const BookTutorBottomSheet(),
    );

    if (tutor != null) {
      setState(() {
        selectedTutor = tutor;
        userSlotMap = null;
        weekDayId = null;
      });

      _openBookDateBottomModalSheet();
    }
  }

  Future<void> _openBookDateBottomModalSheet() async {
    final Map<String, String>? map = await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => BookDateBottomSheet(userId: selectedTutor!.id!),
    );

    if (map != null) {
      setState(() {
        userSlotMap = map;
        setWeekdayId(map['weekday'].toString());
      });
    }
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
        title: Padding(
          padding: EdgeInsets.only(
              right: CalculateSize.getResponsiveSize(72, screenWidth)),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              AppLocalizations.of(context)!.tutorBooking,
              style: TextStyle(
                color: accentColor,
                fontSize: CalculateSize.getResponsiveSize(24, screenWidth),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
      body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(gradient: gradient),
              child: Column(
                children: [
                  Container(
                    height: 1,
                    color: lightGray4,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              CalculateSize.getResponsiveSize(20, screenWidth)),
                      child: Column(
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 4),

                          Column(
                            children: [
                              // Choose Tutor
                              InkWell(
                                onTap: () {
                                  _openBookTutorBottomModalSheet();
                                },
                                child: SizedBox(
                                  height: CalculateSize.getResponsiveSize(
                                      78, screenWidth),
                                  child: Material(
                                    elevation: 2,
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              CalculateSize.getResponsiveSize(
                                                  16, screenWidth),
                                          vertical:
                                              CalculateSize.getResponsiveSize(
                                                  12, screenWidth)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: CalculateSize
                                                    .getResponsiveSize(
                                                        56, screenWidth),
                                                width: CalculateSize
                                                    .getResponsiveSize(
                                                        56, screenWidth),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: lightGray5,
                                                ),
                                                child: selectedTutor != null &&
                                                        selectedTutor!
                                                                .profile !=
                                                            null &&
                                                        selectedTutor!.profile!
                                                                .avatar !=
                                                            null &&
                                                        selectedTutor!.profile!
                                                            .avatar!.isNotEmpty
                                                    ? ClipOval(
                                                        child: Image.network(
                                                          EndPoints
                                                                  .media_base_url +
                                                              selectedTutor!
                                                                  .profile!
                                                                  .avatar!,
                                                          fit: BoxFit.cover,
                                                          width: CalculateSize
                                                              .getResponsiveSize(
                                                                  56,
                                                                  screenWidth),
                                                          height: CalculateSize
                                                              .getResponsiveSize(
                                                                  56,
                                                                  screenWidth),
                                                        ),
                                                      )
                                                    : Padding(
                                                        padding: EdgeInsets.all(
                                                            CalculateSize
                                                                .getResponsiveSize(
                                                                    6,
                                                                    screenWidth)),
                                                        child: Image.asset(
                                                            'assets/images/emojis/emoji4.png'),
                                                      ),
                                              ),
                                              SizedBox(
                                                  width: CalculateSize
                                                      .getResponsiveSize(
                                                          12, screenWidth)),
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    maxWidth: CalculateSize
                                                        .getResponsiveSize(
                                                            200, screenWidth)),
                                                child: FittedBox(
                                                  fit: BoxFit.contain,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        selectedTutor != null
                                                            ? '${selectedTutor!.firstName} ${selectedTutor!.lastName}'
                                                            : AppLocalizations
                                                                    .of(context)!
                                                                .chooseTutor,
                                                        style: TextStyle(
                                                          color: accentColor,
                                                          fontSize: CalculateSize
                                                              .getResponsiveSize(
                                                                  18,
                                                                  screenWidth),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      if (selectedTutor != null)
                                                        Text(
                                                          ' ${selectedTutor!.position![0]}',
                                                          style: TextStyle(
                                                            color: lightBlue2,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SvgPicture.asset(
                                              'assets/icons/ic_down.svg'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(
                                  height: CalculateSize.getResponsiveSize(
                                      10, screenWidth)),

                              // Choose Date and Time
                              InkWell(
                                onTap: () {
                                  if (selectedTutor == null) {
                                    toast('Birinchi Tutor Tanlang!');
                                    return;
                                  }

                                  _openBookDateBottomModalSheet();
                                },
                                child: Opacity(
                                  opacity: selectedTutor == null ? 0.5 : 1,
                                  child: SizedBox(
                                    height: CalculateSize.getResponsiveSize(
                                        78, screenWidth),
                                    child: Material(
                                      elevation: 2,
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                CalculateSize.getResponsiveSize(
                                                    16, screenWidth),
                                            vertical:
                                                CalculateSize.getResponsiveSize(
                                                    12, screenWidth)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: CalculateSize
                                                      .getResponsiveSize(
                                                          56, screenWidth),
                                                  height: CalculateSize
                                                      .getResponsiveSize(
                                                          56, screenWidth),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: lightGray5,
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        CalculateSize
                                                            .getResponsiveSize(
                                                                9,
                                                                screenWidth)),
                                                    child: Image.asset(
                                                        'assets/images/datetime.png'),
                                                  ),
                                                ),
                                                SizedBox(
                                                    width: CalculateSize
                                                        .getResponsiveSize(
                                                            12, screenWidth)),
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                      maxWidth: CalculateSize
                                                          .getResponsiveSize(
                                                              200,
                                                              screenWidth)),
                                                  child: FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Text(
                                                      userSlotMap != null &&
                                                              weekDayId != null
                                                          ? daysOfWeek[
                                                                  weekDayId!] +
                                                              ' / ' +
                                                              userSlotMap![
                                                                      'from_hour']!
                                                                  .substring(
                                                                      0, 5)
                                                          : AppLocalizations.of(
                                                                  context)!
                                                              .chooseDateAndTime,
                                                      style: TextStyle(
                                                        color: accentColor,
                                                        fontSize: CalculateSize
                                                            .getResponsiveSize(
                                                                18,
                                                                screenWidth),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SvgPicture.asset(
                                                'assets/icons/ic_down.svg'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                              height: MediaQuery.of(context).size.height / 4),

                          // Confirm Button
                          Opacity(
                            opacity:
                                userSlotMap == null || selectedTutor == null
                                    ? 0.5
                                    : 1,
                            child: FilledButton(
                              onPressed: () {
                                if (userSlotMap == null ||
                                    selectedTutor == null) {
                                  return;
                                }
                                
                                Navigator.pop(
                                    context,
                                    AddExtraLessonRequestEntity(
                                      tutorId: selectedTutor!.id!,
                                      slotId: int.parse(
                                          userSlotMap!['slot_id'].toString()),
                                      forDate: userSlotMap!['for_date'],
                                      theme: 'theme',
                                    ));
                              },
                              style: ButtonStyle(
                                minimumSize: MaterialStatePropertyAll(Size(
                                    double.infinity,
                                    CalculateSize.getResponsiveSize(
                                        48, screenWidth))),
                                shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStatePropertyAll(primaryColor),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.confirm,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: CalculateSize.getResponsiveSize(
                                      14, screenWidth),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
