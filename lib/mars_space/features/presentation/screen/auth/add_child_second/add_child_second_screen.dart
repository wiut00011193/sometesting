import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mars_it_app/injection_handler.dart';
import 'package:mars_it_app/mars_space/core/calculation/calculate_size.dart';
import 'package:mars_it_app/mars_space/core/local_db/shared_pref.dart';
import 'package:mars_it_app/mars_space/features/data/enum/loading_state_enum.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/search_student_request_model.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_profile_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/search_student_response_entity.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/auth/add_child_second/bloc/add_child_second_bloc.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/main/main_screen.dart';
import 'package:mars_it_app/mars_space/features/presentation/widget/dashed_border_widget.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/output_utils.dart';
import '../../../../data/model/request/add_child_request_model.dart';
import '../../../../data/model/request/get_profile_request_model.dart';
import '../../../widget/loading_widget.dart';

class AddChildSecondScreen extends StatefulWidget {
  const AddChildSecondScreen({super.key});

  @override
  State<AddChildSecondScreen> createState() => _AddChildSecondScreenState();
}

class _AddChildSecondScreenState extends State<AddChildSecondScreen> {
  final AddChildSecondBloc _addChildSecondBloc = di.get<AddChildSecondBloc>();
  TextEditingController studentIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  int currentStep = 1;
  // STEP 1 = STUDENT ID INPUT AND STUDENT SEARCH
  // STEP 2 = STUDENT PASSWORD INPUT
  // STEP 3 = ADDED CHILREN LIST || ADD MORE
  // STEP 4 = <ADD CHILD> COMPLETION

  bool _isObscured = true; // Password Visibility
  bool _isSearchResultListShown = false;
  bool _isErrorMsgShown = false;
  String _errorMsg = '';

  GetProfileResponseEntity studentEntity = GetProfileResponseEntity(
    studentId: null,
    externalId: null,
    companyId: null,
    firstName: null,
    lastName: null,
    coins: null,
    xp: null,
    avatar: null,
    rank: Rank(task: null, title: null, image: null, liga: null),
  ); // Student to enter password for (not yet confirmed as a child)
  List<SearchStudentResponseEntity> searchStudentResultList =
      []; // Student Search Result List
  List<GetProfileResponseEntity> childrenList = []; // Added Children List

  @override
  void dispose() {
    studentIdController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  void appendChild(GetProfileResponseEntity studentEntity) {
    setState(() {
      childrenList.add(studentEntity);
    });
  }

  void setStudent(GetProfileResponseEntity studentEntity) {
    setState(() {
      this.studentEntity = studentEntity;
    });
  }

  void moveToNextStep() {
    setState(() {
      currentStep++;
      setState(() {
        _isErrorMsgShown = false;
      });
    });
  }

  void moveToPreviousStep() {
    setState(() {
      currentStep--;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        if (currentStep == 3) {
          return false;
        } else if (currentStep == 1) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        } else {
          moveToPreviousStep();
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          leading: InkWell(
            onTap: () {
              if (currentStep == 3) {
                return;
              } else if (currentStep == 1) {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              } else {
                moveToPreviousStep();
              }
            },
            child: SvgPicture.asset('assets/icons/ic_back_button.svg',
                width: CalculateSize.getResponsiveSize(24, screenWidth),
                height: CalculateSize.getResponsiveSize(24, screenWidth),
                fit: BoxFit.scaleDown),
          ),
          titleSpacing: 0,
          title: Padding(
            padding: EdgeInsets.only(
                left: CalculateSize.getResponsiveSize(16, screenWidth)),
            child: SizedBox(
              height: CalculateSize.getResponsiveSize(22, screenWidth),
              child: Image.asset("assets/images/mars_logo_appbar.png"),
            ),
          ),
        ),
        body: BlocProvider(
          create: (context) => _addChildSecondBloc,
          child: BlocConsumer<AddChildSecondBloc, AddChildSecondState>(
            builder: (context, state) {
              if (currentStep != 1 && state.status == LoadingState.LOADING) {
                return const LoadingWidget();
              }
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(gradient: gradient),
                child: Padding(
                  padding: EdgeInsets.all(
                      CalculateSize.getResponsiveSize(16, screenWidth)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Step Title
                      Text(
                        currentStep == 1
                            ? AppLocalizations.of(context)!
                                .text_enter_student_id
                            : (currentStep == 2
                                ? AppLocalizations.of(context)!
                                    .text_enter_password
                                : AppLocalizations.of(context)!
                                    .text_added_children),
                        style: TextStyle(
                            color: accentColor,
                            fontSize: CalculateSize.getResponsiveSize(
                                18, screenWidth),
                            fontWeight: FontWeight.w700),
                      ),

                      SizedBox(
                          height:
                              CalculateSize.getResponsiveSize(16, screenWidth)),

                      // Student ID
                      if (currentStep == 1) _buildStudentIdStep(),

                      // Sudent Search
                      if (currentStep == 1 && _isSearchResultListShown)
                        _buildSearchChild(),

                      SizedBox(
                          height:
                              CalculateSize.getResponsiveSize(16, screenWidth)),

                      // Password
                      if (currentStep == 2) _buildPasswordStep(),

                      // All Chrildren List
                      if (currentStep == 3) _buildChildrenListStep(),
                      if (currentStep == 3)
                        SizedBox(
                            height: CalculateSize.getResponsiveSize(
                                16, screenWidth)),
                      if (currentStep == 3)
                        InkWell(
                          onTap: () {
                            setState(() {
                              studentIdController.clear();
                              passwordController.clear();
                              _isSearchResultListShown = false;
                              currentStep = 1;
                            });
                          },
                          child: DashedBorder(
                            strokeWidth: 2.0,
                            color: primaryColor,
                            gapWidth: 10.0,
                            borderRadius: 10.0,
                            child: Container(
                              height: CalculateSize.getResponsiveSize(
                                  88, screenWidth),
                              color: const Color(0xffF6FAFD),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: CalculateSize.getResponsiveSize(
                                        64, screenWidth)),
                                child: Center(
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(
                                      '+  ${AppLocalizations.of(context)!.text_add_child}',
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontSize:
                                            CalculateSize.getResponsiveSize(
                                                16, screenWidth),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      SizedBox(
                          height:
                              CalculateSize.getResponsiveSize(30, screenWidth)),

                      // Add Child Button
                      if (currentStep != 1)
                        FilledButton(
                          onPressed: () async {
                            final studentId =
                                studentIdController.text.toString().trim();
                            final password =
                                passwordController.text.toString().trim();

                            moveToNextStep(); // MOVE TO NEXT STEP

                            if (currentStep == 2 && studentId.isNotEmpty) {
                              _addChildSecondBloc.add(
                                GetProfileEvent(
                                  request: GetProfileRequestModel(
                                    studentId: int.parse(studentId),
                                  ),
                                ),
                              );
                            } else if (currentStep == 3) {
                              if (password.isEmpty) {
                                setState(() {
                                  _isErrorMsgShown = true;
                                  _errorMsg = AppLocalizations.of(context)!
                                      .error_empty_field;
                                });
                                moveToPreviousStep();
                                return;
                              }
                              _addChildSecondBloc.add(
                                AddChildEvent(
                                  request: AddChildRequestModel(
                                    externalId: studentEntity.externalId,
                                    code: password,
                                    role: 'student',
                                  ),
                                ),
                              );
                            } else if (currentStep == 4) {
                              if (Navigator.of(context).canPop()) {
                                Navigator.pop(context);
                              }
                              if (Navigator.of(context).canPop()) {
                                Navigator.pop(context);
                              }
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MainScreen(),
                                  ));
                            } else {
                              _isErrorMsgShown = true;
                              moveToPreviousStep(); // MOVE TO PREVIOUS STEP UPON VALIDATION ERROR
                            }
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
                            currentStep == 2
                                ? AppLocalizations.of(context)!.text_add
                                : AppLocalizations.of(context)!.text_continue,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: CalculateSize.getResponsiveSize(
                                  14, screenWidth),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
            listener: (context, state) {
              if (state.status == LoadingState.LOADED) {
                setState(() {
                  _isErrorMsgShown = false;
                });
                if (currentStep == 1) {
                  dartz.Either<Failure, List<SearchStudentResponseEntity>>
                      searchResult = state.searchResult;
                  List<SearchStudentResponseEntity> successValue = searchResult
                      .getOrElse(() => throw '<SEARCH CHILD> ERROR');
                  setState(() {
                    searchStudentResultList = successValue;
                    _isSearchResultListShown = true;
                  });
                } else if (currentStep == 2) {
                  dartz.Either<Failure, GetProfileResponseEntity> result =
                      state.getResult;
                  GetProfileResponseEntity studentEntity =
                      result.getOrElse(() => throw '<GET CHILD> ERROR');
                  setStudent(studentEntity);
                } else if (currentStep == 3) {
                  appendChild(studentEntity);
                }
              } else if (state.status == LoadingState.ERROR) {
                if (currentStep > 1) {
                  moveToPreviousStep(); // MOVE TO PREVIOUS STEP UPON ERROR
                }
                logger("AddChildSecondScreen Error = ${state.errorMessage}");
                if (state.errorMessage ==
                    'Exception: {detail: Could not validate credentials}') {
                  setState(() {
                    _isErrorMsgShown = true;

                    _errorMsg =
                        AppLocalizations.of(context)!.error_wrong_password;
                  });
                } else if (state.errorMessage ==
                    'Exception: {detail: Already created}') {
                  setState(() {
                    _isErrorMsgShown = true;

                    _errorMsg =
                        AppLocalizations.of(context)!.error_child_already_added;
                  });
                } else {
                  toast(AppLocalizations.of(context)!.error_try_later);
                }
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStudentIdStep() {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: CalculateSize.getResponsiveSize(56, screenWidth),
      child: TextField(
        onChanged: (externalId) {
          // Check if there are at least three numbers in the text field
          if (externalId.length >= 3) {
            // Trigger the search request
            _addChildSecondBloc.add(
              SearchStudentEvent(
                request: SearchStudentRequestModel(
                  externalId: int.parse(externalId),
                  page: 1,
                  perPage: 5,
                ),
              ),
            );
          } else {
            setState(() {
              _isSearchResultListShown = false;
            });
          }
        },
        controller: studentIdController,
        keyboardType: TextInputType.number,
        style: TextStyle(
          fontSize: CalculateSize.getResponsiveSize(16, screenWidth),
          color: accentColor,
        ),
        decoration: InputDecoration(
          hintText: "Student ID",
          fillColor: Colors.white,
          filled: true,
          prefixIcon: SvgPicture.asset(
            "assets/icons/ic_edt_login.svg",
            fit: BoxFit.none,
          ),
          prefixIconColor: primaryColor,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchChild() {
    final screenWidth = MediaQuery.of(context).size.width;

    return Flexible(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        constraints: BoxConstraints(
          maxHeight: searchStudentResultList.isNotEmpty
              ? CalculateSize.getResponsiveSize(220, screenWidth)
              : 0,
        ),
        child: ListView.builder(
          itemCount: searchStudentResultList.isNotEmpty
              ? searchStudentResultList.length
              : 0,
          itemBuilder: (context, index) {
            final student = searchStudentResultList[index];
            final accessToken = di.get<MySharedPref>().getAccessToken();
            return GestureDetector(
              onTap: () {
                moveToNextStep();
                _addChildSecondBloc.add(
                  GetProfileEvent(
                    request: GetProfileRequestModel(
                      studentId: student.id,
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  SizedBox(
                    height: CalculateSize.getResponsiveSize(88, screenWidth),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              CalculateSize.getResponsiveSize(16, screenWidth),
                          vertical:
                              CalculateSize.getResponsiveSize(12, screenWidth),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: CalculateSize.getResponsiveSize(
                                      56, screenWidth),
                                  height: CalculateSize.getResponsiveSize(
                                      56, screenWidth),
                                  decoration: BoxDecoration(
                                    color: lightGreen4,
                                    shape: BoxShape.circle,
                                  ),
                                  child: student.profile!.avatar!.isNotEmpty
                                      ? ClipOval(
                                          child: Image.network(
                                            EndPoints.media_base_url +
                                                student.profile!.avatar!,
                                            headers: {
                                              'Authorization':
                                                  'Bearer $accessToken'
                                            },
                                          ),
                                        )
                                      : Padding(
                                          padding: EdgeInsets.all(
                                              CalculateSize.getResponsiveSize(
                                                  8, screenWidth)),
                                          child: Image.asset(
                                            'assets/images/emojis/emoji4.png',
                                          ),
                                        ),
                                ),
                                SizedBox(
                                    width: CalculateSize.getResponsiveSize(
                                        16, screenWidth)),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth: CalculateSize.getResponsiveSize(
                                          240, screenWidth)),
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // STUDENT NAME
                                        Text(
                                          student.name ?? 'NO NAME',
                                          style: TextStyle(
                                            color: accentColor,
                                            fontSize:
                                                CalculateSize.getResponsiveSize(
                                                    16, screenWidth),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        // STUDENT ID
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              for (var i = 0;
                                                  i <
                                                      student.externalId
                                                          .toString()
                                                          .length;
                                                  i++)
                                                TextSpan(
                                                  text: student.externalId
                                                      .toString()[i],
                                                  style: TextStyle(
                                                    color: studentIdController
                                                            .text
                                                            .toString()
                                                            .contains(student
                                                                .externalId
                                                                .toString()[i])
                                                        ? primaryColor
                                                        : Colors.grey,
                                                    fontSize: CalculateSize
                                                        .getResponsiveSize(
                                                            14, screenWidth),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            CalculateSize.getResponsiveSize(16, screenWidth)),
                    child: Container(
                      height: 1,
                      color: lightGray,
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

  Widget _buildPasswordStep() {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SizedBox(
          height: CalculateSize.getResponsiveSize(88, screenWidth),
          child: Card(
            elevation: 4,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: CalculateSize.getResponsiveSize(16, screenWidth),
                  vertical: CalculateSize.getResponsiveSize(12, screenWidth),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height:
                              CalculateSize.getResponsiveSize(56, screenWidth),
                          width:
                              CalculateSize.getResponsiveSize(56, screenWidth),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors
                                .grey, // Set your desired background color
                          ),
                          child: studentEntity.avatar != null
                              ? ClipOval(
                                  child: Image.network(
                                    EndPoints.media_base_url +
                                        studentEntity.avatar!,
                                    fit: BoxFit.cover,
                                    width: CalculateSize.getResponsiveSize(
                                        56, screenWidth),
                                    height: CalculateSize.getResponsiveSize(
                                        56, screenWidth),
                                  ),
                                )
                              : const SizedBox(),
                        ),
                        SizedBox(
                            width: CalculateSize.getResponsiveSize(
                                16, screenWidth)),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: CalculateSize.getResponsiveSize(
                                  180, screenWidth)),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  studentEntity.firstName != null &&
                                          studentEntity.lastName != null
                                      ? '${studentEntity.lastName!} ${studentEntity.firstName!}'
                                      : 'NO NAME',
                                  style: TextStyle(
                                    color: accentColor,
                                    fontSize: CalculateSize.getResponsiveSize(
                                        16, screenWidth),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  studentEntity.externalId != null
                                      ? studentEntity.externalId.toString()
                                      : 'ID NOT FOUND',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: CalculateSize.getResponsiveSize(
                                        14, screenWidth),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Checkbox(
                      value: true,
                      onChanged: (changedValue) {},
                      checkColor: Colors.white,
                      activeColor: primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: CalculateSize.getResponsiveSize(16, screenWidth)),

        // Password Input
        SizedBox(
          height: CalculateSize.getResponsiveSize(56, screenWidth),
          child: TextField(
            onChanged: (text) {
              setState(() {
                _isErrorMsgShown = false;
              });
            },
            controller: passwordController,
            obscureText: _isObscured,
            obscuringCharacter: '●',
            style: TextStyle(
              color: accentColor,
              fontSize: CalculateSize.getResponsiveSize(16, screenWidth),
            ),
            decoration: InputDecoration(
              hintText: 'Password',
              hintStyle: TextStyle(color: lightGray),
              fillColor: Colors.white,
              filled: true,
              prefixIcon: SvgPicture.asset(
                "assets/icons/ic_edt_password.svg",
                fit: BoxFit.none,
              ),
              suffixIcon: IconButton(
                icon: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      _isObscured ? lightGray : primaryColor, BlendMode.srcIn),
                  child: SvgPicture.asset(
                    'assets/icons/ic_eye_password.svg',
                    fit: BoxFit.none,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        if (_isErrorMsgShown)
          SizedBox(height: CalculateSize.getResponsiveSize(12, screenWidth)),

        // Error Text
        if (_isErrorMsgShown)
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: CalculateSize.getResponsiveSize(12, screenWidth)),
            child: Text(
              _errorMsg,
              style: TextStyle(
                color: errorColor,
                fontSize: CalculateSize.getResponsiveSize(14, screenWidth),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildChildrenListStep() {
    final screenWidth = MediaQuery.of(context).size.width;

    return Flexible(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        constraints: BoxConstraints(
          maxHeight: childrenList.isNotEmpty
              ? (childrenList.length > 1
                  ? (childrenList.length == 2
                      ? CalculateSize.getResponsiveSize(178, screenWidth)
                      : CalculateSize.getResponsiveSize(220, screenWidth))
                  : CalculateSize.getResponsiveSize(89, screenWidth))
              : 0,
        ),
        child: ListView.builder(
          itemCount: childrenList.isNotEmpty ? childrenList.length : 0,
          itemBuilder: (context, index) {
            final student = childrenList[index];
            return Column(
              children: [
                SizedBox(
                  height: CalculateSize.getResponsiveSize(88, screenWidth),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            CalculateSize.getResponsiveSize(16, screenWidth),
                        vertical:
                            CalculateSize.getResponsiveSize(12, screenWidth),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: CalculateSize.getResponsiveSize(
                                        56, screenWidth),
                                    height: CalculateSize.getResponsiveSize(
                                        56, screenWidth),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors
                                          .grey, // Set your desired background color
                                    ),
                                    child: student.avatar != null
                                        ? ClipOval(
                                            child: Image.network(
                                              EndPoints.media_base_url +
                                                  student.avatar!,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const SizedBox(),
                                  ),
                                  SizedBox(
                                      width: CalculateSize.getResponsiveSize(
                                          16, screenWidth)),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            CalculateSize.getResponsiveSize(
                                                180, screenWidth)),
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            student.lastName != null &&
                                                    student.firstName != null
                                                ? '${student.lastName} ${student.firstName}'
                                                : 'NO NAME',
                                            style: TextStyle(
                                              color: accentColor,
                                              fontSize: CalculateSize
                                                  .getResponsiveSize(
                                                      16, screenWidth),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            student.externalId.toString(),
                                            style: TextStyle(
                                              color: primaryColor,
                                              fontSize: CalculateSize
                                                  .getResponsiveSize(
                                                      14, screenWidth),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Checkbox(
                                value: true,
                                onChanged: (changedValue) {},
                                checkColor: Colors.white,
                                activeColor: primaryColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          CalculateSize.getResponsiveSize(16, screenWidth)),
                  child: Container(
                    height: 1,
                    color: lightGray,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
