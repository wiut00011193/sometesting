import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mars_it_app/injection_handler.dart';
import 'package:mars_it_app/mars_space/core/calculation/calculate_size.dart';
import 'package:mars_it_app/mars_space/core/theme/colors.dart';
import 'package:mars_it_app/mars_space/core/theme/theme.dart';
import 'package:mars_it_app/mars_space/core/utils/output_utils.dart';
import 'package:mars_it_app/mars_space/features/data/enum/loading_state_enum.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_extra_lessons_response_entity.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/booking/bloc/booking_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/booking/page/book_lesson_page.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/booking/widget/booked_lesson_card_widget.dart';
import 'package:mars_it_app/mars_space/features/presentation/widget/loading_widget.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _bookingBloc = di.get<BookingBloc>();
  List<GetExtraLessonsResponseEntity> extraLessons = [];
  bool isBookingCompleted = false;

  @override
  void initState() {
    super.initState();

    _bookingBloc.add(GetExtraLessonsEvent());
  }

  Future<void> _openBookingScreenPage() async {
    final request = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BookLessonPage(),
      ),
    );

    if (request != null) {
      _bookingBloc.add(BookExtraLessonEvent(addExtraLessonRequest: request));
      setState(() {
        isBookingCompleted = true;
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
              AppLocalizations.of(context)!.bookingList,
              style: TextStyle(
                color: accentColor,
                fontSize: CalculateSize.getResponsiveSize(24, screenWidth),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 19),
            child: InkWell(
              onTap: () {
                _openBookingScreenPage();
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset('assets/icons/ic_add.svg'),
              ),
            ),
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => _bookingBloc,
        child: BlocConsumer<BookingBloc, BookingState>(
          listener: (context, state) {
            if (state.status == LoadingState.ERROR) {
              if (isBookingCompleted) {
                toast('Keyinroq urunib ko\'ring');
                setState(() {
                  isBookingCompleted = false;
                });
              }
            } else if (state.status == LoadingState.LOADED) {
              setState(() {
                if (isBookingCompleted) {
                  _bookingBloc.add(GetExtraLessonsEvent());
                  isBookingCompleted = false;
                  toast('dars band qilindi!');
                  return;
                }
                final extraLessons = state.getExtraLessonsResult
                    .getOrElse(() => throw Exception('NO EXTRA LESSONS FOUND'));
                for (int i = 0; i < extraLessons.length; i++) {
                  if (extraLessons[i].data!.isNotEmpty) {
                    this.extraLessons.add(extraLessons[i]);
                  }
                }
              });
            }
          },
          builder: (context, state) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(gradient: gradient),
              child: state.status == LoadingState.LOADING
                  ? const LoadingWidget()
                  : Column(
                      children: [
                        Container(
                          height: 1,
                          color: lightGray4,
                        ),
                        if (extraLessons.isEmpty)
                          Padding(
                            padding: EdgeInsets.only(
                              left: CalculateSize.getResponsiveSize(
                                  65.5, screenWidth),
                              right: CalculateSize.getResponsiveSize(
                                  65.5, screenWidth),
                              top: CalculateSize.getResponsiveSize(
                                  100, screenWidth),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.text_no_extra_lesson_booked,
                              style: TextStyle(
                                color: accentColor,
                                fontSize: CalculateSize.getResponsiveSize(
                                    18, screenWidth),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        if (extraLessons.isNotEmpty)
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: CalculateSize.getResponsiveSize(
                                      20, screenWidth),
                                  left: CalculateSize.getResponsiveSize(
                                      20, screenWidth),
                                  top: CalculateSize.getResponsiveSize(
                                      12, screenWidth)),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: List.generate(
                                    extraLessons.length,
                                    (index) =>
                                        extraLessons[index].data![0].status ==
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
                              ),
                            ),
                          ),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }
}
