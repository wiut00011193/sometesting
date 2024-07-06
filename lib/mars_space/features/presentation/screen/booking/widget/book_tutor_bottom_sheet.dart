import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_it_app/injection_handler.dart';
import 'package:mars_it_app/mars_space/core/calculation/calculate_size.dart';
import 'package:mars_it_app/mars_space/core/theme/colors.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mars_it_app/mars_space/core/utils/constants.dart';
import 'package:mars_it_app/mars_space/features/data/enum/loading_state_enum.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_tutors_response_entity.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/booking/bloc/booking_bloc.dart';
import 'package:mars_it_app/mars_space/features/presentation/widget/loading_widget.dart';

class BookTutorBottomSheet extends StatefulWidget {
  const BookTutorBottomSheet({super.key});

  @override
  State<BookTutorBottomSheet> createState() => _BookTutorBottomSheetState();
}

class _BookTutorBottomSheetState extends State<BookTutorBottomSheet> {
  final _bookingBloc = di.get<BookingBloc>();

  final List<String> courseList = [
    "Starter",
    "Frontend",
    "Back-end",
    "Design",
  ];

  String selectedPosition = "Starter";
  int selectedTutor = -1;
  int selectedTutorUserId = -1;

  List<GetTutorsResponseEntity> filteredTutorsList = [];
  List<GetTutorsResponseEntity> tutorsList = [];

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _bookingBloc.add(GetTutorsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => _bookingBloc,
      child: BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state.status == LoadingState.LOADED) {
            setState(() {
              tutorsList = state.getTutorsResult
                  .getOrElse(() => throw Exception('NO TUTORS FOUND'));
              filteredTutorsList = tutorsList
                  .where(
                      (element) => element.position!.contains(selectedPosition))
                  .toList();
            });
          }
        },
        builder: (context, state) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: CalculateSize.getResponsiveSize(16, screenWidth)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                      height: CalculateSize.getResponsiveSize(5, screenWidth)),
                  Container(
                    height: CalculateSize.getResponsiveSize(5, screenWidth),
                    width: CalculateSize.getResponsiveSize(36, screenWidth),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.5),
                      color: lightGray4,
                    ),
                  ),
                  SizedBox(
                      height: CalculateSize.getResponsiveSize(16, screenWidth)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            CalculateSize.getResponsiveSize(16, screenWidth)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.tutorList,
                          style: TextStyle(
                            color: accentColor,
                            fontSize: CalculateSize.getResponsiveSize(
                                16, screenWidth),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                            height: CalculateSize.getResponsiveSize(
                                10, screenWidth)),
                        Container(
                          height: 1,
                          color: lightGray4,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      height: CalculateSize.getResponsiveSize(16, screenWidth)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            CalculateSize.getResponsiveSize(20.5, screenWidth)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FittedBox(
                          fit: BoxFit.contain,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              courseList.length,
                              (index) => Row(
                                children: [
                                  if (index != 0)
                                    SizedBox(
                                        width: CalculateSize.getResponsiveSize(
                                            8, screenWidth)),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = index;
                                        selectedTutor = -1;
                                        selectedTutorUserId = -1;
                                        selectedPosition = courseList[index];
                                        filteredTutorsList = tutorsList
                                            .where((element) => element
                                                .position!
                                                .contains(selectedPosition))
                                            .toList();
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: selectedIndex == index
                                            ? primary500
                                            : Colors.white,
                                        border: Border.all(
                                          color: selectedIndex == index
                                              ? primary500
                                              : accentColor,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                CalculateSize.getResponsiveSize(
                                                    12, screenWidth),
                                            vertical:
                                                CalculateSize.getResponsiveSize(
                                                    8, screenWidth)),
                                        child: Text(
                                          courseList[index],
                                          style: TextStyle(
                                            color: selectedIndex == index
                                                ? Colors.white
                                                : accentColor,
                                            // 14
                                            fontSize:
                                                CalculateSize.getResponsiveSize(
                                                    14, screenWidth),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                            height: CalculateSize.getResponsiveSize(
                                16, screenWidth)),

                        // Tutor List
                        if (state.status == LoadingState.LOADING)
                          const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: LoadingWidget(),
                          )
                        else
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: lightGray3,
                            ),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: CalculateSize.getResponsiveSize(
                                    232, screenWidth),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: CalculateSize.getResponsiveSize(
                                      16, screenWidth),
                                  vertical: CalculateSize.getResponsiveSize(
                                      12, screenWidth),
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: List.generate(
                                      filteredTutorsList.length,
                                      (index) => Padding(
                                        padding: EdgeInsets.only(
                                            bottom: index + 1 !=
                                                    filteredTutorsList.length
                                                ? CalculateSize
                                                    .getResponsiveSize(
                                                        8, screenWidth)
                                                : 0),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedTutor = index;
                                              selectedTutorUserId =
                                                  filteredTutorsList[index].id!;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: Colors.white),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: CalculateSize
                                                    .getResponsiveSize(
                                                        12, screenWidth),
                                                vertical: CalculateSize
                                                    .getResponsiveSize(
                                                        4, screenWidth),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      // Tutor Avatar
                                                      Container(
                                                        height: CalculateSize
                                                            .getResponsiveSize(
                                                                56,
                                                                screenWidth),
                                                        width: CalculateSize
                                                            .getResponsiveSize(
                                                                56,
                                                                screenWidth),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: lightGray5,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: filteredTutorsList[
                                                                            index]
                                                                        .profile!
                                                                        .avatar !=
                                                                    null &&
                                                                filteredTutorsList[
                                                                        index]
                                                                    .profile!
                                                                    .avatar!
                                                                    .isNotEmpty
                                                            ? ClipOval(
                                                                child: Image
                                                                    .network(
                                                                  EndPoints
                                                                          .media_base_url +
                                                                      filteredTutorsList[
                                                                              index]
                                                                          .profile!
                                                                          .avatar!,
                                                                  fit: BoxFit
                                                                      .cover,
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
                                                                child:
                                                                    Image.asset(
                                                                  'assets/images/emojis/emoji4.png',
                                                                ),
                                                              ),
                                                      ),

                                                      SizedBox(
                                                          width: CalculateSize
                                                              .getResponsiveSize(
                                                                  16,
                                                                  screenWidth)),

                                                      // Tutor Name and Position
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          // Tutor Name
                                                          Text(
                                                            '${filteredTutorsList[index].firstName!} ${filteredTutorsList[index].lastName!}',
                                                            style: TextStyle(
                                                              color:
                                                                  accentColor,
                                                              fontSize: CalculateSize
                                                                  .getResponsiveSize(
                                                                      16,
                                                                      screenWidth),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),

                                                          // Tutor Position
                                                          Text(
                                                            filteredTutorsList[
                                                                    index]
                                                                .position!
                                                                .join(', '),
                                                            style: TextStyle(
                                                              color: primary500,
                                                              fontSize: CalculateSize
                                                                  .getResponsiveSize(
                                                                      14,
                                                                      screenWidth),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),

                                                  // Select Button
                                                  Container(
                                                    height: CalculateSize
                                                        .getResponsiveSize(
                                                            18, screenWidth),
                                                    width: CalculateSize
                                                        .getResponsiveSize(
                                                            18, screenWidth),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          selectedTutor == index
                                                              ? primary500
                                                              : lightGray5,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: selectedTutor ==
                                                                index
                                                            ? Colors.transparent
                                                            : lightGray2,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
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
                            height: CalculateSize.getResponsiveSize(
                                16, screenWidth)),

                        // Last Chosen Text
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.text_last_booked_teacher,
                              style: TextStyle(
                                color: accentColor,
                                fontSize: CalculateSize.getResponsiveSize(
                                    14, screenWidth),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                                height: CalculateSize.getResponsiveSize(
                                    10, screenWidth)),
                            Container(
                              height: 1,
                              color: lightGray4,
                            ),
                          ],
                        ),

                        SizedBox(
                            height: CalculateSize.getResponsiveSize(
                                16, screenWidth)),

                        // Last Chosen Card
                        Container(
                          decoration: BoxDecoration(
                            color: lightGray3,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: CalculateSize.getResponsiveSize(
                                  88, screenWidth),
                            ),
                          ),
                        ),

                        SizedBox(
                            height: CalculateSize.getResponsiveSize(
                                30, screenWidth)),

                        FilledButton(
                          onPressed: () {
                            if (selectedTutorUserId == -1) {
                              return;
                            }
                            Navigator.pop(context, tutorsList[selectedTutor]);
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

                        SizedBox(
                            height: CalculateSize.getResponsiveSize(
                                60, screenWidth)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
