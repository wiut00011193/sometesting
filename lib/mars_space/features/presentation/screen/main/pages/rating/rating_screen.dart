import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_it_app/injection_handler.dart';
import 'package:mars_it_app/mars_space/core/calculation/calculate_size.dart';
import 'package:mars_it_app/mars_space/core/theme/colors.dart';
import 'package:mars_it_app/mars_space/core/theme/theme.dart';
import 'package:mars_it_app/mars_space/features/data/enum/loading_state_enum.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_ratings_response_entity.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/main/pages/rating/bloc/rating_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/main/pages/rating/widget/rating_card_widget.dart';
import 'package:mars_it_app/mars_space/features/presentation/widget/loading_widget.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen>
    with TickerProviderStateMixin {
  final _ratingBloc = di.get<RatingBloc>();
  late final TabController _tabController;
  int selectedIndex = 0;
  GetRatingsResponseEntity ratingsEntity =
      GetRatingsResponseEntity(hackers: null, coders: null, gamers: null);
  List<Student> studentList = [];
  List<List<Student>> ratingList = [];

  @override
  void initState() {
    _ratingBloc.add(GetRatingsEvent());
    _tabController = TabController(length: 3, vsync: this);
    _tabController.animation?.addListener(() {
      final newIndex = _tabController.animation?.value.round();
      if (newIndex != selectedIndex) {
        setState(() {
          selectedIndex = newIndex!;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final List<String> clans = [
      AppLocalizations.of(context)!.hackers,
      AppLocalizations.of(context)!.coders,
      AppLocalizations.of(context)!.gamers,
    ];

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Text(
          ' ${AppLocalizations.of(context)!.pageTitleRating}',
          style: TextStyle(
            color: accentColor,
            fontSize: CalculateSize.getResponsiveSize(24, screenWidth),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => _ratingBloc,
        child: BlocConsumer<RatingBloc, RatingState>(
          listener: (context, state) {
            if (state.status == LoadingState.LOADED) {
              setState(() {
                ratingsEntity = state.getRatingsResult
                    .getOrElse(() => throw Exception('NO RATINGS FOUND'));
                ratingList.add(ratingsEntity.hackers!.students!);
                ratingList.add(ratingsEntity.coders!.students!);
                ratingList.add(ratingsEntity.gamers!.students!);
                switch (selectedIndex) {
                  case 0:
                    studentList = ratingsEntity.hackers!.students!;
                    break;
                  case 1:
                    studentList = ratingsEntity.coders!.students!;
                    break;
                  case 2:
                    studentList = ratingsEntity.gamers!.students!;
                    break;
                }
              });
            }
          },
          builder: (context, state) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(gradient: gradient),
              child: Column(
                children: [
                  SizedBox(
                      height: CalculateSize.getResponsiveSize(12, screenWidth)),
                  Expanded(
                    child: DefaultTabController(
                      length: clans.length,
                      child: Column(
                        children: [
                          TabBar(
                            controller: _tabController,
                            indicatorColor: Colors.transparent,
                            dividerHeight: 0,
                            labelPadding: EdgeInsets.zero,
                            tabs: List.generate(
                              clans.length,
                              (index) {
                                return Column(
                                  children: [
                                    Container(
                                      height: CalculateSize.getResponsiveSize(
                                          48, screenWidth),
                                      color: selectedIndex == index
                                          ? Colors.white
                                          : lightGray3,
                                      child: Center(
                                        child: Text(
                                          clans[index],
                                          style: TextStyle(
                                            color: selectedIndex == index
                                                ? primaryColor
                                                : accentColor,
                                            fontSize:
                                                CalculateSize.getResponsiveSize(
                                                    14, screenWidth),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 1,
                                      color: lightGray4,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: List.generate(
                                clans.length,
                                (clanIndex) => Column(
                                  children: [
                                    if (state.status == LoadingState.LOADING)
                                      const LoadingWidget(),
                                    if (state.status != LoadingState.LOADING)
                                      SizedBox(
                                          height:
                                              CalculateSize.getResponsiveSize(
                                                  16, screenWidth)),
                                    if (state.status != LoadingState.LOADING &&
                                        studentList.isNotEmpty)
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: CalculateSize
                                                  .getResponsiveSize(
                                                      20, screenWidth)),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: List.generate(
                                                ratingList[clanIndex].length,
                                                (index) {
                                                  return Column(
                                                    children: [
                                                      RatingCard(
                                                          studentEntity:
                                                              ratingList[
                                                                      clanIndex]
                                                                  [index]),
                                                      SizedBox(
                                                          height: CalculateSize
                                                              .getResponsiveSize(
                                                                  6,
                                                                  screenWidth)),
                                                    ],
                                                  );
                                                },
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
                        ],
                      ),
                    ),
                  ),
                  // Container(
                  //   height: 1,
                  //   color: lightGray4,
                  // ),
                  // if (state.status == LoadingState.LOADING)
                  //   const LoadingWidget(),
                  // if (state.status != LoadingState.LOADING)
                  //   SizedBox(
                  //       height:
                  //           CalculateSize.getResponsiveSize(16, screenWidth)),
                  // if (state.status != LoadingState.LOADING &&
                  //     studentList.isNotEmpty)
                  //   Expanded(
                  //     child: Padding(
                  //       padding: EdgeInsets.symmetric(
                  //           horizontal: CalculateSize.getResponsiveSize(
                  //               20, screenWidth)),
                  //       child: SingleChildScrollView(
                  //         child: Column(
                  //           children: List.generate(
                  //             studentList.length,
                  //             (index) {
                  //               return Column(
                  //                 children: [
                  //                   RatingCard(
                  //                       studentEntity: studentList[index]),
                  //                   SizedBox(
                  //                       height: CalculateSize.getResponsiveSize(
                  //                           6, screenWidth)),
                  //                 ],
                  //               );
                  //             },
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
