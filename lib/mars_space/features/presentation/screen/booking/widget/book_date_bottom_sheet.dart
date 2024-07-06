import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mars_it_app/injection_handler.dart';
import 'package:mars_it_app/mars_space/core/calculation/calculate_size.dart';
import 'package:mars_it_app/mars_space/core/theme/colors.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mars_it_app/mars_space/core/utils/constants.dart';
import 'package:mars_it_app/mars_space/features/data/enum/loading_state_enum.dart';
import 'package:mars_it_app/mars_space/features/data/model/response/get_user_slots_response_model.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/get_user_slots_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_user_slots_response_entity.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/booking/bloc/booking_bloc.dart';
import 'package:mars_it_app/mars_space/features/presentation/widget/loading_widget.dart';

class BookDateBottomSheet extends StatefulWidget {
  final int userId;
  const BookDateBottomSheet({
    super.key,
    required this.userId,
  });

  @override
  State<BookDateBottomSheet> createState() => _BookDateBottomSheetState();
}

class _BookDateBottomSheetState extends State<BookDateBottomSheet> {
  final _bookingBloc = di.get<BookingBloc>();

  DateTime dateNow = DateTime.now();
  String selectedDay = '';
  int selectedDayId = -1;
  int selectedSlotId = -1;
  List<GetUserSlotsResponseEntity> userSlots = [];

  int tomorrowIndex = -1;
  List<String> daysOfWeek = [
    'Du',
    'Se',
    'Chor',
    'Pay',
    'Juma',
    'Shan',
    'Yak',
  ];

  @override
  void initState() {
    super.initState();

    _bookingBloc.add(GetUserSlotsEvent(
        getUserSlotsRequest: GetUserSlotsRequestEntity(userId: widget.userId)));
    adjustDaysOfWeek();
  }

  void adjustDaysOfWeek() async {
    final response = await di.get<Dio>().get(EndPoints.path_get_datetime);
    setState(() {
      dateNow = DateTime.parse(response.data as String);
    });

    // Calculate tomorrow's day index
    tomorrowIndex = (dateNow.weekday % 7);

    setState(() {
      daysOfWeek = [
        ...daysOfWeek.sublist(tomorrowIndex),
        ...daysOfWeek.sublist(0, tomorrowIndex)
      ];
    });
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
              userSlots = state.getUserSlotsResult
                  .getOrElse(() => throw Exception('NO USER SLOTS FOUND'));
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
                          AppLocalizations.of(context)!.days,
                          style: TextStyle(
                            color: accentColor,
                            fontSize: CalculateSize.getResponsiveSize(
                                16, screenWidth),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                            height: CalculateSize.getResponsiveSize(
                                16, screenWidth)),
                        if (state.status == LoadingState.LOADING)
                          const LoadingWidget()
                        else if (tomorrowIndex != -1)
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: CalculateSize.getResponsiveSize(
                                    8, screenWidth)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                daysOfWeek.length,
                                (index) {
                                  final List<String> daysDefault = [
                                    'monday',
                                    'tuesday',
                                    'wednesday',
                                    'thursday',
                                    'friday',
                                    'saturday',
                                    'sunday',
                                  ];
                                  final List<String> days = [
                                    ...daysDefault.sublist(tomorrowIndex),
                                    ...daysDefault.sublist(0, tomorrowIndex)
                                  ];

                                  if (days[index] == 'sunday') {
                                    return Container();
                                  }

                                  final bool isAvailable = userSlots
                                          .firstWhere(
                                            (element) =>
                                                element.dayOfWeek ==
                                                days[index],
                                            orElse: () =>
                                                GetUserSlotsResponseModel(
                                                    date: null,
                                                    dayOfWeek: null,
                                                    slot: null),
                                          )
                                          .slot !=
                                      null;

                                  return Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        // Weekday
                                        Text(
                                          daysOfWeek[index],
                                          style: TextStyle(
                                            color: accentColor,
                                            fontSize:
                                                CalculateSize.getResponsiveSize(
                                                    12, screenWidth),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),

                                        SizedBox(
                                            height:
                                                CalculateSize.getResponsiveSize(
                                                    16, screenWidth)),

                                        // CheckBox
                                        InkWell(
                                          onTap: () {
                                            if (!isAvailable || selectedDayId == index) {
                                              return;
                                            }
                                            setState(() {
                                              selectedDay = days[index];
                                              selectedDayId = index;
                                              selectedSlotId = -1;
                                            });
                                          },
                                          child: Container(
                                            width:
                                                CalculateSize.getResponsiveSize(
                                                    38, screenWidth),
                                            height:
                                                CalculateSize.getResponsiveSize(
                                                    38, screenWidth),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: selectedDayId == index
                                                  ? primary500
                                                  : lightGray3,
                                              border: Border.all(
                                                color: lightGray4,
                                                width: 0.4,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  CalculateSize
                                                      .getResponsiveSize(
                                                          5, screenWidth)),
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                child: !isAvailable
                                                    ? Icon(Icons.remove,
                                                        color: lightGray2)
                                                    : selectedDayId != index
                                                        ? null
                                                        : Center(
                                                            child: Text(
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              '${dateNow.add(Duration(days: index + 1)).day}\n${DateFormat('MMMM').format(dateNow.add(Duration(days: index + 1)))}',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: CalculateSize
                                                                    .getResponsiveSize(
                                                                        10,
                                                                        screenWidth),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
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
                                                    4, screenWidth)),

                                        // Day of Month
                                        Text(
                                          dateNow
                                              .add(Duration(days: index + 1))
                                              .day
                                              .toString(),
                                          style: TextStyle(
                                            color: accentColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                        SizedBox(
                            height: CalculateSize.getResponsiveSize(
                                16, screenWidth)),

                        // Choose Time Text
                        Text(
                          AppLocalizations.of(context)!.hours,
                          style: TextStyle(
                            color: accentColor,
                            fontSize: CalculateSize.getResponsiveSize(
                                16, screenWidth),
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        SizedBox(
                            height: CalculateSize.getResponsiveSize(
                                16, screenWidth)),

                        // Choose Time Slots
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: lightGray3,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: CalculateSize.getResponsiveSize(
                                  16, screenWidth),
                              vertical: CalculateSize.getResponsiveSize(
                                  12, screenWidth),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: selectedDay == ''
                                    ? List.empty()
                                    : List.generate(
                                        userSlots
                                            .where((element) =>
                                                element.dayOfWeek ==
                                                selectedDay)
                                            .first
                                            .slot!
                                            .length,
                                        (index) {
                                          final slotList = userSlots
                                              .where((element) =>
                                                  element.dayOfWeek ==
                                                  selectedDay)
                                              .first
                                              .slot!;
                                          return Row(
                                            children: [
                                              if (index != 0)
                                                SizedBox(
                                                    width: CalculateSize
                                                        .getResponsiveSize(
                                                            8, screenWidth)),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectedSlotId =
                                                        slotList[index].id!;
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: selectedSlotId ==
                                                            slotList[index].id!
                                                        ? primary500
                                                        : lightGray3,
                                                    border: Border.all(
                                                      color: selectedSlotId ==
                                                              slotList[index]
                                                                  .id!
                                                          ? primary500
                                                          : accentColor,
                                                      width: 1.6,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: CalculateSize
                                                          .getResponsiveSize(
                                                              15.5,
                                                              screenWidth),
                                                      vertical: CalculateSize
                                                          .getResponsiveSize(
                                                              10, screenWidth),
                                                    ),
                                                    child: Text(
                                                      slotList[index]
                                                          .fromHour
                                                          .toString()
                                                          .substring(0, 5),
                                                      style: TextStyle(
                                                        color: selectedSlotId ==
                                                                slotList[index]
                                                                    .id!
                                                            ? Colors.white
                                                            : accentColor,
                                                        fontSize: CalculateSize
                                                            .getResponsiveSize(
                                                                12,
                                                                screenWidth),
                                                        fontWeight:
                                                            FontWeight.w600,
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
                            ),
                          ),
                        ),

                        SizedBox(
                            height: CalculateSize.getResponsiveSize(
                                40, screenWidth)),

                        FilledButton(
                          onPressed: () {
                            if (selectedSlotId == -1) {
                              return;
                            }
                            final userSlot = userSlots.firstWhere(
                                (element) => element.dayOfWeek == selectedDay);
                            final slot = userSlot.slot!.firstWhere(
                                (element) => element.id == selectedSlotId);
                            Map<String, String> map = {
                              'weekday': userSlot.dayOfWeek!,
                              'from_hour': slot.fromHour!,
                              'till_hour': slot.tillHour!,
                              'for_date': userSlot.date!,
                              'slot_id': selectedSlotId.toString(),
                            };
                            Navigator.pop(
                                context, map);
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
