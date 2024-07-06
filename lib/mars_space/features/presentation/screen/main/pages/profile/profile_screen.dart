import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mars_it_app/mars_space/core/calculation/calculate_size.dart';
import 'package:mars_it_app/mars_space/core/local_db/shared_pref.dart';
import 'package:mars_it_app/mars_space/core/theme/colors.dart';
import 'package:mars_it_app/mars_space/core/utils/constants.dart';
import 'package:mars_it_app/mars_space/features/data/enum/loading_state_enum.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/get_profile_request_model.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_children_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_profile_response_entity.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/booking/booking_screen.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/learning_journey/learning_journey_screen.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/main/main_screen.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/main/pages/profile/bloc/profile_bloc.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/main/pages/profile/widget/profile_screen_bottom_sheet.dart';
import 'package:mars_it_app/mars_space/features/presentation/widget/loading_widget.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../../../injection_handler.dart';
import '../../../../../../core/theme/theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GetProfileResponseEntity _studentEntity = GetProfileResponseEntity(
    studentId: null,
    externalId: null,
    companyId: null,
    firstName: null,
    lastName: null,
    coins: null,
    xp: null,
    avatar: null,
    rank: Rank(task: null, title: null, image: null, liga: null),
  );
  final MySharedPref _mySharedPref = di.get<MySharedPref>();
  final ProfileBloc _profileBloc = di.get<ProfileBloc>();
  List<GetChildrenResponseEntity> childrenList = [];
  int step = 1;

  @override
  void initState() {
    // _mySharedPref.getStudentId().then((value) => _profileBloc.add(
    //     GetStudentEvent(request: GetStudentRequestModel(studentId: value))));
    _profileBloc.add(GetChildrenEvent());
    super.initState();
  }

  Future<void> _openProfileBottomModalSheet() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => const MyBottomSheet(),
    );

    _mySharedPref.getStudentModmeId().then((value) {
      if (_studentEntity.studentId != value) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MainScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            _openProfileBottomModalSheet();
          },
          child: SizedBox(
            width: CalculateSize.getResponsiveSize(48, screenWidth),
            height: CalculateSize.getResponsiveSize(48, screenWidth),
            child: SvgPicture.asset(
              'assets/icons/ic_menu.svg',
              width: CalculateSize.getResponsiveSize(24, screenWidth),
              height: CalculateSize.getResponsiveSize(24, screenWidth),
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
        titleSpacing: 0,
        title: Text(
          "Profile",
          style: TextStyle(
            color: accentColor,
            fontSize: CalculateSize.getResponsiveSize(24, screenWidth),
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LearningJourneyScreen()),
              );
            },
            child: Padding(
              padding: EdgeInsets.only(
                  right: CalculateSize.getResponsiveSize(20, screenWidth)),
              child: SvgPicture.asset(
                'assets/icons/ic_profile_road_map.svg',
                width: CalculateSize.getResponsiveSize(24, screenWidth),
                height: CalculateSize.getResponsiveSize(24, screenWidth),
              ),
            ),
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => _profileBloc,
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state.status == LoadingState.LOADED) {
              setState(() {
                if (step == 1) {
                  List<GetChildrenResponseEntity> list = state.getChildrenResult
                      .getOrElse(() => throw Exception('PRoblem'));
                  _mySharedPref.getStudentId().then((value) {
                    for (var i = 0; i < list.length; i++) {
                      if (list[i].externalId == value) {
                        step = 2;
                        _profileBloc.add(GetProfileEvent(
                            getProfileRequest:
                                GetProfileRequestModel(studentId: list[i].id)));
                        return;
                      }
                    }
                  });
                } else if (step == 2) {
                  _studentEntity = state.getStudentResult
                      .getOrElse(() => throw Exception('aaaa'));
                }
                // _studentEntity = state.getStudentResult
                //     .getOrElse(() => throw Exception('GET CHILDREN ERROR'));
              });
            }
          },
          builder: (context, state) {
            if (state.status == LoadingState.LOADING) {
              return const LoadingWidget();
            }
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(gradient: gradient),
              child: Column(
                children: [
                  Container(
                    height: 1,
                    color: lightGray4,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        right: CalculateSize.getResponsiveSize(20, screenWidth),
                        left: CalculateSize.getResponsiveSize(20, screenWidth),
                        top: CalculateSize.getResponsiveSize(30, screenWidth)),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: CalculateSize.getResponsiveSize(
                                      34, screenWidth)),
                              child: Card(
                                elevation: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.contain,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 12.0,
                                            bottom: 25.0,
                                            right:
                                                CalculateSize.getResponsiveSize(
                                                    20, screenWidth)),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                                width: CalculateSize
                                                    .getResponsiveSize(
                                                        180, screenWidth)),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Coin",
                                                  style: TextStyle(
                                                    color: lightGray7,
                                                    fontSize: CalculateSize
                                                        .getResponsiveSize(
                                                            12, screenWidth),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      _studentEntity.coins
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: accentColor,
                                                        fontSize: CalculateSize
                                                            .getResponsiveSize(
                                                                24,
                                                                screenWidth),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        width: CalculateSize
                                                            .getResponsiveSize(
                                                                5,
                                                                screenWidth)),
                                                    SvgPicture.asset(
                                                      'assets/icons/ic_coin.svg',
                                                      height: CalculateSize
                                                          .getResponsiveSize(
                                                              18, screenWidth),
                                                      width: CalculateSize
                                                          .getResponsiveSize(
                                                              18, screenWidth),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                                width: CalculateSize
                                                    .getResponsiveSize(
                                                        8, screenWidth)),
                                            Container(
                                              width: 1,
                                              height: 34,
                                              color: lightGray,
                                            ),
                                            SizedBox(
                                                width: CalculateSize
                                                    .getResponsiveSize(
                                                        8, screenWidth)),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "XP",
                                                  style: TextStyle(
                                                    color: lightGray7,
                                                    fontSize: CalculateSize
                                                        .getResponsiveSize(
                                                            12, screenWidth),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      _studentEntity.xp
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: accentColor,
                                                        fontSize: CalculateSize
                                                            .getResponsiveSize(
                                                                24,
                                                                screenWidth),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        width: CalculateSize
                                                            .getResponsiveSize(
                                                                5,
                                                                screenWidth)),
                                                    SvgPicture.asset(
                                                      'assets/icons/ic_xp.svg',
                                                      height: CalculateSize
                                                          .getResponsiveSize(
                                                              18, screenWidth),
                                                      width: CalculateSize
                                                          .getResponsiveSize(
                                                              28, screenWidth),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: CalculateSize.getResponsiveSize(
                                          119, screenWidth),
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                CalculateSize.getResponsiveSize(
                                                    20, screenWidth),
                                            vertical:
                                                CalculateSize.getResponsiveSize(
                                                    12, screenWidth)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Level',
                                              style: TextStyle(
                                                color: primaryColor,
                                                fontSize: CalculateSize
                                                    .getResponsiveSize(
                                                        14, screenWidth),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: CalculateSize
                                                      .getResponsiveSize(
                                                          24, screenWidth)),
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                child: Text(
                                                  _studentEntity.firstName !=
                                                              null &&
                                                          _studentEntity
                                                                  .lastName !=
                                                              null
                                                      ? '${_studentEntity.firstName} ${_studentEntity.lastName}'
                                                      : 'NO NAME',
                                                  style: TextStyle(
                                                    color: accentColor,
                                                    fontSize: CalculateSize
                                                        .getResponsiveSize(
                                                            24, screenWidth),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (_studentEntity.rank != null)
                                              if (_studentEntity.rank!.task !=
                                                  null)
                                                if (_studentEntity
                                                        .rank!.task!.level !=
                                                    null)
                                                  Row(
                                                    children: [
                                                      for (int i = 0;
                                                          i <
                                                              _studentEntity
                                                                  .rank!
                                                                  .task!
                                                                  .level!;
                                                          i++)
                                                        Row(
                                                          children: [
                                                            Image.asset(
                                                              'assets/images/gold_star.png',
                                                              height: CalculateSize
                                                                  .getResponsiveSize(
                                                                      24,
                                                                      screenWidth),
                                                              width: CalculateSize
                                                                  .getResponsiveSize(
                                                                      24,
                                                                      screenWidth),
                                                            ),
                                                            SizedBox(
                                                                width: CalculateSize
                                                                    .getResponsiveSize(
                                                                        5,
                                                                        screenWidth)),
                                                          ],
                                                        ),
                                                      for (int i = 0;
                                                          i <
                                                              5 -
                                                                  _studentEntity
                                                                      .rank!
                                                                      .task!
                                                                      .level!;
                                                          i++)
                                                        Row(
                                                          children: [
                                                            Image.asset(
                                                              'assets/images/grey_star.png',
                                                              height: CalculateSize
                                                                  .getResponsiveSize(
                                                                      24,
                                                                      screenWidth),
                                                              width: CalculateSize
                                                                  .getResponsiveSize(
                                                                      24,
                                                                      screenWidth),
                                                            ),
                                                            SizedBox(
                                                                width: CalculateSize
                                                                    .getResponsiveSize(
                                                                        5,
                                                                        screenWidth)),
                                                          ],
                                                        ),
                                                    ],
                                                  ),
                                            SizedBox(
                                                height: CalculateSize
                                                    .getResponsiveSize(
                                                        12, screenWidth)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: CalculateSize.getResponsiveSize(
                                      20, screenWidth)),
                              child: Container(
                                width: CalculateSize.getResponsiveSize(
                                    115, screenWidth),
                                height: CalculateSize.getResponsiveSize(
                                    115, screenWidth),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors
                                      .grey, // Set your desired background color
                                ),
                                child: _studentEntity.avatar != null
                                    ? ClipOval(
                                        child: Image.network(
                                          EndPoints.media_base_url +
                                              _studentEntity.avatar!,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : const SizedBox(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: CalculateSize.getResponsiveSize(
                                10, screenWidth)),
                        Card(
                          elevation: 2,
                          child: SizedBox(
                            height: CalculateSize.getResponsiveSize(
                                135, screenWidth),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: CalculateSize.getResponsiveSize(
                                      16, screenWidth),
                                  vertical: CalculateSize.getResponsiveSize(
                                      12, screenWidth)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Support',
                                            style: TextStyle(
                                              color: lightBlue2,
                                              fontSize: CalculateSize
                                                  .getResponsiveSize(
                                                      12, screenWidth),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                              height: CalculateSize
                                                  .getResponsiveSize(
                                                      4, screenWidth)),
                                          Text(
                                            AppLocalizations.of(context)!.text_extra_lesson_hero,
                                            style: TextStyle(
                                              color: accentColor,
                                              fontSize: CalculateSize
                                                  .getResponsiveSize(
                                                      18, screenWidth),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      FilledButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BookingScreen(),
                                            ),
                                          );
                                        },
                                        style: ButtonStyle(
                                          minimumSize: MaterialStatePropertyAll(
                                              Size(
                                                  CalculateSize
                                                      .getResponsiveSize(
                                                          102, screenWidth),
                                                  CalculateSize
                                                      .getResponsiveSize(
                                                          36, screenWidth))),
                                          shape: MaterialStatePropertyAll(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  lightBlue2),
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)!.text_extra_lesson_book,
                                          style: TextStyle(
                                            fontSize:
                                                CalculateSize.getResponsiveSize(
                                                    14, screenWidth),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: CalculateSize.getResponsiveSize(
                                        54, screenWidth),
                                    height: CalculateSize.getResponsiveSize(
                                        54, screenWidth),
                                    decoration: BoxDecoration(
                                      color: lightGray5,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          CalculateSize.getResponsiveSize(
                                              7, screenWidth)),
                                      child: Image.asset(
                                          "assets/images/person_one.png"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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
