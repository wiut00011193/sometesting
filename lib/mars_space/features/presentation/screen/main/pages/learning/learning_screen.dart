import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_it_app/injection_handler.dart';
import 'package:mars_it_app/mars_space/core/calculation/calculate_size.dart';
import 'package:mars_it_app/mars_space/features/data/enum/loading_state_enum.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/get_course_element_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/get_course_elements_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/get_exam_result_request_model.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/get_course_modules_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_course_element_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_course_elements_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_course_modules_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_exam_result_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_student_response_entity.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/main/pages/learning/bloc/learning_bloc.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/main/pages/learning/page/assignment_page.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/main/pages/learning/page/exam_page.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/main/pages/learning/widget/assignment_card_widget.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/main/pages/learning/widget/exam_card_widget.dart';
import 'package:mars_it_app/mars_space/features/presentation/widget/loading_widget.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../../core/theme/colors.dart';
import '../../../../../../core/theme/theme.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen>
    with SingleTickerProviderStateMixin {
  final _learningBloc = di.get<LearningBloc>();
  late final TabController _tabController;
  int studentId = -1;

  List<GetCourseElementsResponseEntity> courseElementsList = [];
  List<List<GetCourseElementsResponseEntity>> courseElementsssssList = [];
  List<GetExamResultResponseEntity> examResultsList = [];
  GetCourseElementResponseEntity courseElement =
      GetCourseElementResponseEntity.create();
  GetExamResultResponseEntity? examResult;
  int? groupId;
  int? courseId;
  late int step;
  bool loadAssignmentPage = false;
  int index = 0;

  int? moduleCount;
  late int currentModule;

  @override
  void initState() {
    _learningBloc.add(GetStudentEvent());
    currentModule = 1;
    step = 1;
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void fetchModuleElements(int module) {
    if (step == 3) {
      _learningBloc.add(GetCourseElementsEvent(
        getCourseElementsRequestModel: GetCourseElementsRequestModel(
          courseId: courseId,
          module: module,
        ),
      ));
    }

    if (step == 4) {
      _learningBloc.add(GetExamResultEvent(
        getExamResultRequestModel: GetExamResultRequestModel(
          groupId: groupId,
          module: module,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Text(
          ' ${AppLocalizations.of(context)!.pageTitleLearning}',
          style: TextStyle(
            color: accentColor,
            fontSize: CalculateSize.getResponsiveSize(24, screenWidth),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => _learningBloc,
        child: BlocConsumer<LearningBloc, LearningState>(
          listener: (context, state) {
            if (state.status == LoadingState.LOADED) {
              if (step == 1) {
                studentId = state.studentId;
                final getStudentResult = state.getStudentResult
                    .getOrElse(() => GetStudentResponseEntity(
                          id: null,
                          name: null,
                          groups: null,
                        ));
                if (getStudentResult.groups != null) {
                  final groupResult = getStudentResult.groups!;
                  bool activeGroupExists = false;
                  for (int i = 0; i < groupResult.length; i++) {
                    if (groupResult[i].status == 5) {
                      activeGroupExists = true;
                      setState(() {
                        groupId = groupResult[i].id;
                        courseId = groupResult[i].categoryId;
                        step++;
                      });
                      _learningBloc.add(GetCourseModulesEvent(
                          getCourseModulesRequestEntity:
                              GetCourseModulesRequestEntity(
                                  courseId: courseId)));
                    }
                  }

                  if (!activeGroupExists && groupResult.isNotEmpty) {
                    setState(() {
                      groupId = groupResult.last.id;
                      courseId = groupResult.last.categoryId;
                      step++;
                    });
                    _learningBloc.add(GetCourseModulesEvent(
                        getCourseModulesRequestEntity:
                            GetCourseModulesRequestEntity(courseId: courseId)));
                  }
                }
              } else if (step == 2) {
                final getCourseModulesResult = state.getCourseModulesResult
                    .getOrElse(
                        () => GetCourseModulesResponseEntity(modules: null));
                setState(() {
                  if (getCourseModulesResult.modules != null) {
                    _tabController = TabController(
                        length: getCourseModulesResult.modules!, vsync: this);
                    _tabController.animation?.addListener(() {
                      final newIndex = _tabController.animation?.value.round();
                      if (newIndex != currentModule - 1) {
                        setState(() {
                          currentModule = (newIndex! + 1);
                        });
                      }
                    });
                    moduleCount = getCourseModulesResult.modules!;
                    step++;
                    fetchModuleElements(1);
                  }
                });
              } else if (step == 3) {
                final getCourseElementsResult =
                    state.getCourseElementsResult.getOrElse(() => [
                          GetCourseElementsResponseEntity(
                              id: null,
                              title: null,
                              about: null,
                              module: null,
                              order: null,
                              mark: null,
                              status: null,
                              answerStatus: null),
                        ]);

                setState(() {
                  if (getCourseElementsResult[0].id != null) {
                    courseElementsssssList.add(getCourseElementsResult);
                  }
                });

                if (courseElementsssssList.length < moduleCount!) {
                  fetchModuleElements(courseElementsssssList.length + 1);
                } else if (courseElementsssssList.length == moduleCount!) {
                  setState(() {
                    step++;
                    fetchModuleElements(1);
                  });
                }
              } else if (step == 4) {
                final getExamResult = state.getExamResult.getOrElse(() =>
                    GetExamResultResponseEntity(overall: null, data: null));

                setState(() {
                  examResultsList.add(getExamResult);
                });

                if (examResultsList.length < moduleCount!) {
                  fetchModuleElements(examResultsList.length + 1);
                } else if (examResultsList.length == moduleCount!) {
                  setState(() {
                    step++;
                  });
                }
              }

              if (loadAssignmentPage) {
                final getCourseElementResult = state.getCourseElementResult
                    .getOrElse(() => throw Exception());
                setState(() {
                  courseElement = getCourseElementResult;
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AssignmentPage(
                            courseElement: courseElement, index: index + 1)));
                loadAssignmentPage = false;
              }

              // for (int i = 0; i < getStudentResult.groups!.length; i++) {
              //   if (getStudentResult.groups![i].status == 5) {
              //     print('aaa' + getStudentResult.groups![i].id.toString());
              //     print('aaa' +
              //         getStudentResult.groups![i].categoryId.toString());
              //   }
              // }
            }
          },
          builder: (context, state) {
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
                  if (moduleCount != null)
                    Expanded(
                      child: DefaultTabController(
                        length: moduleCount!,
                        child: Column(
                          children: [
                            TabBar(
                              controller: _tabController,
                              labelPadding: EdgeInsets.zero,
                              tabs: List.generate(
                                moduleCount!,
                                (index) => SizedBox(
                                  height: CalculateSize.getResponsiveSize(
                                      50, screenWidth),
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                              CalculateSize.getResponsiveSize(
                                                  32, screenWidth)),
                                      child: Center(
                                        child: Text(
                                          '${index + 1} ${AppLocalizations.of(context)!.text_month}',
                                          style: TextStyle(
                                            color: currentModule == index + 1
                                                ? primaryColor
                                                : accentColor,
                                            fontSize: 32,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (courseElementsssssList.length == moduleCount &&
                                examResultsList.length == moduleCount)
                              Expanded(
                                child: TabBarView(
                                  controller: _tabController,
                                  children: List.generate(
                                    moduleCount!,
                                    (moduleIndex) => Stack(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: CalculateSize
                                                  .getResponsiveSize(
                                                      20, screenWidth)),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                const SizedBox(height: 12),
                                                if (examResultsList[moduleIndex]
                                                            .overall !=
                                                        null &&
                                                    examResultsList[moduleIndex]
                                                            .data !=
                                                        null)
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ExamPage(
                                                            examResult:
                                                                examResultsList[
                                                                    moduleIndex],
                                                            module:
                                                                moduleIndex + 1,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: ExamCard(
                                                      examResult:
                                                          examResultsList[
                                                              moduleIndex],
                                                      module: moduleIndex + 1,
                                                    ),
                                                  ),
                                                Column(
                                                  children: List.generate(
                                                    (courseElementsssssList[
                                                                    moduleIndex]
                                                                .length /
                                                            2)
                                                        .round(),
                                                    (rowIndex) {
                                                      int rowCount =
                                                          rowIndex + 1;
                                                      int secondItemId =
                                                          rowCount * 2 - 1;
                                                      int firstItemId =
                                                          secondItemId - 1;
                                                      return Column(
                                                        children: [
                                                          if (rowCount == 1)
                                                            const SizedBox(
                                                                height: 10),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: InkWell(
                                                                  child:
                                                                      AssignmentCard(
                                                                    courseElement:
                                                                        courseElementsssssList[moduleIndex]
                                                                            [
                                                                            firstItemId],
                                                                    index:
                                                                        firstItemId +
                                                                            1,
                                                                    onAssignmentClick:
                                                                        () async {
                                                                      setState(
                                                                          () {
                                                                        index =
                                                                            firstItemId;
                                                                      });
                                                                      _learningBloc.add(GetCourseElementEvent(
                                                                          getCourseElementRequestModel: GetCourseElementRequestModel(
                                                                              groupId: groupId,
                                                                              courseElementId: courseElementsssssList[moduleIndex][index].id)));
                                                                      loadAssignmentPage =
                                                                          true;
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 10),
                                                              if (courseElementsssssList[
                                                                          moduleIndex]
                                                                      .length <
                                                                  secondItemId +
                                                                      1)
                                                                Expanded(
                                                                    child:
                                                                        Container()),
                                                              if (courseElementsssssList[
                                                                          moduleIndex]
                                                                      .length >=
                                                                  (secondItemId +
                                                                      1))
                                                                Expanded(
                                                                  child:
                                                                      AssignmentCard(
                                                                    courseElement:
                                                                        courseElementsssssList[moduleIndex]
                                                                            [
                                                                            secondItemId],
                                                                    index:
                                                                        secondItemId +
                                                                            1,
                                                                    onAssignmentClick:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        index =
                                                                            secondItemId;
                                                                      });
                                                                      _learningBloc.add(GetCourseElementEvent(
                                                                          getCourseElementRequestModel: GetCourseElementRequestModel(
                                                                              groupId: groupId,
                                                                              courseElementId: courseElementsssssList[moduleIndex][index].id)));
                                                                      loadAssignmentPage =
                                                                          true;
                                                                    },
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        // Loading Overlay
                                        if (state.status ==
                                            LoadingState.LOADING)
                                          Container(
                                            height: double.infinity,
                                            width: double.infinity,
                                            color: lightGray.withOpacity(0.2),
                                          ),
                                        if (state.status ==
                                            LoadingState.LOADING)
                                          const LoadingWidget()
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                  // if (moduleCount != null)
                  //   Row(
                  //     children: List.generate(
                  //       moduleCount!,
                  //       (index) => InkWell(
                  //         onTap: () {
                  //           setState(() {
                  //             if (currentModule == index + 1) {
                  //               return;
                  //             }
                  //             currentModule = index + 1;
                  //             examResult = null;
                  //             loadModulePage();
                  //           });
                  //         },
                  //         child: Container(
                  //           // width: CalculateSize.getResponsiveSize(
                  //           //     150, screenWidth),
                  //           width: MediaQuery.of(context).size.width /
                  //               moduleCount!,
                  //           height: CalculateSize.getResponsiveSize(
                  //               50, screenWidth),
                  //           decoration: BoxDecoration(
                  //             color: currentModule == index + 1
                  //                 ? Colors.white
                  //                 : lightGray3,
                  //           ),
                  //           child: FittedBox(
                  //             fit: BoxFit.contain,
                  //             child: Padding(
                  //               padding: EdgeInsets.all(
                  //                   CalculateSize.getResponsiveSize(
                  //                       32, screenWidth)),
                  //               child: Center(
                  //                 child: Text(
                  //                   '${index + 1} месяц',
                  //                   style: TextStyle(
                  //                     color: currentModule == index + 1
                  //                         ? primaryColor
                  //                         : accentColor,
                  //                     fontSize: 32,
                  //                     fontWeight: FontWeight.w700,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // Expanded(
                  //   child: Stack(
                  //     children: [
                  //       Padding(
                  //         padding: EdgeInsets.symmetric(
                  //             horizontal: CalculateSize.getResponsiveSize(
                  //                 20, screenWidth)),
                  //         child: SingleChildScrollView(
                  //           child: Column(
                  //             children: [
                  //               const SizedBox(height: 12),
                  //               if (examResult != null &&
                  //                   examResult!.overall != null &&
                  //                   examResult!.data != null)
                  //                 GestureDetector(
                  //                   onTap: () {
                  //                     Navigator.push(
                  //                       context,
                  //                       MaterialPageRoute(
                  //                         builder: (context) => ExamPage(
                  //                           examResult: examResult ??
                  //                               GetExamResultResponseEntity(
                  //                                   overall: null, data: null),
                  //                           module: currentModule,
                  //                         ),
                  //                       ),
                  //                     );
                  //                   },
                  //                   child: ExamCard(
                  //                     examResult: examResult ??
                  //                         GetExamResultResponseEntity(
                  //                             overall: null, data: null),
                  //                     module: currentModule,
                  //                   ),
                  //                 ),
                  //               Column(
                  //                 children: List.generate(
                  //                   (courseElementsList.length / 2).round(),
                  //                   (rowIndex) {
                  //                     int rowCount = rowIndex + 1;
                  //                     int secondItemId = rowCount * 2 - 1;
                  //                     int firstItemId = secondItemId - 1;
                  //                     return Column(
                  //                       children: [
                  //                         if (rowCount == 1)
                  //                           const SizedBox(height: 10),
                  //                         Row(
                  //                           children: [
                  //                             Expanded(
                  //                               child: InkWell(
                  //                                 child: AssignmentCard(
                  //                                   courseElement:
                  //                                       courseElementsList[
                  //                                           firstItemId],
                  //                                   index: firstItemId + 1,
                  //                                   onAssignmentClick:
                  //                                       () async {
                  //                                     setState(() {
                  //                                       index = firstItemId;
                  //                                     });
                  //                                     _learningBloc.add(GetCourseElementEvent(
                  //                                         getCourseElementRequestModel:
                  //                                             GetCourseElementRequestModel(
                  //                                                 groupId:
                  //                                                     groupId,
                  //                                                 courseElementId:
                  //                                                     courseElementsList[
                  //                                                             index]
                  //                                                         .id)));
                  //                                     loadAssignmentPage = true;
                  //                                   },
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                             const SizedBox(width: 10),
                  //                             if (courseElementsList.length <
                  //                                 secondItemId + 1)
                  //                               Expanded(child: Container()),
                  //                             if (courseElementsList.length >=
                  //                                 (secondItemId + 1))
                  //                               Expanded(
                  //                                 child: AssignmentCard(
                  //                                   courseElement:
                  //                                       courseElementsList[
                  //                                           secondItemId],
                  //                                   index: secondItemId + 1,
                  //                                   onAssignmentClick: () {
                  //                                     setState(() {
                  //                                       index = secondItemId;
                  //                                     });
                  //                                     _learningBloc.add(GetCourseElementEvent(
                  //                                         getCourseElementRequestModel:
                  //                                             GetCourseElementRequestModel(
                  //                                                 groupId:
                  //                                                     groupId,
                  //                                                 courseElementId:
                  //                                                     courseElementsList[
                  //                                                             index]
                  //                                                         .id)));
                  //                                     loadAssignmentPage = true;
                  //                                   },
                  //                                 ),
                  //                               ),
                  //                           ],
                  //                         ),
                  //                         const SizedBox(height: 10),
                  //                       ],
                  //                     );
                  //                   },
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),

                  //       // Loading Overlay
                  //       if (state.status == LoadingState.LOADING)
                  //         Container(
                  //           height: double.infinity,
                  //           width: double.infinity,
                  //           color: lightGray.withOpacity(0.2),
                  //         ),
                  //       if (state.status == LoadingState.LOADING)
                  //         const LoadingWidget()
                  //     ],
                  //   ),
                  // ),

                  // Expanded(
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  //     child: SingleChildScrollView(
                  //       child: Wrap(
                  //         spacing: 10,
                  //         children: List.generate(
                  //           courseElementsList.length,
                  //           (index) => AssignmentCard(
                  //             courseElement: courseElementsList[index],
                  //             index: index + 1,
                  //             onAssignmentClick: () {
                  //               setState(() {
                  //                 loadAssignmentPage = true;
                  //                 this.index = index;
                  //               });
                  //               _learningBloc.add(
                  //                 GetCourseElementEvent(
                  //                   request: GetCourseElementRequestModel(
                  //                     elementId:
                  //                         courseElementsList[index].id,
                  //                     groupId: groupId,
                  //                   ),
                  //                 ),
                  //               );
                  //             },
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
