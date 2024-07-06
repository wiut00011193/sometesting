import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mars_it_app/injection_handler.dart';
import 'package:mars_it_app/mars_space/core/calculation/calculate_size.dart';
import 'package:mars_it_app/mars_space/core/local_db/shared_pref.dart';
import 'package:mars_it_app/mars_space/core/utils/constants.dart';
import 'package:mars_it_app/mars_space/core/utils/output_utils.dart';
import 'package:mars_it_app/mars_space/features/data/enum/loading_state_enum.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/get_profile_request_model.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/delete_child_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_children_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_profile_response_entity.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/main/main_screen.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/main/pages/profile/bloc/profile_bloc.dart';
import 'package:mars_it_app/mars_space/features/presentation/widget/dashed_border_widget.dart';
import 'package:mars_it_app/mars_space/features/presentation/widget/loading_widget.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../../../core/theme/colors.dart';
import '../../../../auth/add_child_first/add_child_first_screen.dart';

class MyBottomSheet extends StatefulWidget {
  const MyBottomSheet({super.key});

  @override
  State<MyBottomSheet> createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  final _mySharedPref = di.get<MySharedPref>();
  final ProfileBloc _profileBloc = di.get<ProfileBloc>();
  int? _currentStudentId;
  List<GetChildrenResponseEntity> childrenList = [];
  List<GetProfileResponseEntity> profileList = [];

  bool isChildDeleted = false;
  int? deletedChildId;

  int step = 1;

  @override
  void initState() {
    _profileBloc.add(GetChildrenEvent());
    super.initState();
  }

  Future<void> _showConfirmationDialog(BuildContext context, int id) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.white,
          title: Text(AppLocalizations.of(context)!.text_confirmation),
          content: Text(AppLocalizations.of(context)!.text_confirmation_delete_child),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(AppLocalizations.of(context)!.text_no),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(AppLocalizations.of(context)!.text_yes),
            ),
          ],
        );
      },
    );

    // Handle the result
    if (result == true) {
      setState(() {
        isChildDeleted = true;
      });
      _profileBloc.add(DeleteChildEvent(
          deleteChildRequest: DeleteChildRequestEntity(id: id)));
    } else {
      setState(() {
        deletedChildId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => _profileBloc,
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.status == LoadingState.ERROR) {
            if (isChildDeleted) {
              setState(() {
                toast('Keyinroq urinib ko\'ring');
                deletedChildId = null;
                isChildDeleted = false;
              });
            }
          } else if (state.status == LoadingState.LOADED) {
            if (isChildDeleted) {
              _mySharedPref.getStudentModmeId().then((value) {
                if (deletedChildId == value) {
                  childrenList.remove(childrenList
                      .firstWhere((element) => element.id == deletedChildId));
                  if (childrenList.isNotEmpty) {
                    final student = childrenList[0];
                    _mySharedPref
                        .setStudentId(student.externalId ?? 0)
                        .then((value) {
                      _mySharedPref
                          .setStudentModmeId(student.id ?? 0)
                          .then((value) {
                        _mySharedPref
                            .setBranchId(student.companyId ?? -1)
                            .then((value) {
                          toast(AppLocalizations.of(context)!.text_child_deleted);
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainScreen()));
                        });
                      });
                    });
                  } else {
                    toast(AppLocalizations.of(context)!.text_child_deleted);
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddChildFirstScreen()));
                  }
                } else {
                  setState(() {
                    step = 1;
                    childrenList = [];
                    profileList = [];
                    _currentStudentId = null;
                    _profileBloc.add(GetChildrenEvent());
                    isChildDeleted = false;
                    toast(AppLocalizations.of(context)!.text_child_deleted);
                  });
                }
              });
            } else if (step == 1) {
              _mySharedPref.getStudentId().then((value) {
                setState(() {
                  step = 2;
                  _currentStudentId = value;
                  childrenList = state.getChildrenResult
                      .getOrElse(() => throw Exception('GET CHILDREN ERROR'));
                  profileList = List<GetProfileResponseEntity>.filled(
                    childrenList.length,
                    GetProfileResponseEntity(
                      studentId: null,
                      externalId: null,
                      companyId: null,
                      firstName: '',
                      lastName: '',
                      coins: null,
                      xp: null,
                      avatar: '',
                      rank: Rank(
                          task: null, title: null, image: null, liga: null),
                    ),
                  );
                  for (int i = 0; i < childrenList.length; i++) {
                    _profileBloc.add(GetProfileEvent(
                        getProfileRequest: GetProfileRequestModel(
                            studentId: childrenList[i].id)));
                  }
                });
              });
            } else if (step == 2) {
              GetProfileResponseEntity profileEntity = state.getStudentResult
                  .getOrElse(() => throw Exception('some error'));
              setState(() {
                for (int i = 0; i < childrenList.length; i++) {
                  if (profileEntity.studentId == childrenList[i].id) {
                    profileList[i] = profileEntity;
                  }
                }
              });
            }
          }
        },
        builder: (context, state) {
          return Container(
            height: CalculateSize.getResponsiveSize(448, screenWidth),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              color: Colors.white,
            ),
            child: state.status == LoadingState.LOADING || isChildDeleted
                ? const LoadingWidget()
                : Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            CalculateSize.getResponsiveSize(16, screenWidth)),
                    child: Column(
                      children: [
                        SizedBox(
                            height: CalculateSize.getResponsiveSize(
                                5, screenWidth)),
                        Container(
                          height:
                              CalculateSize.getResponsiveSize(5, screenWidth),
                          width:
                              CalculateSize.getResponsiveSize(36, screenWidth),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.5),
                            color: lightGray,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: CalculateSize.getResponsiveSize(
                                  16, screenWidth),
                              bottom: CalculateSize.getResponsiveSize(
                                  10, screenWidth)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.text_choose_account,
                                style: TextStyle(
                                  fontSize: CalculateSize.getResponsiveSize(
                                      16, screenWidth),
                                  fontWeight: FontWeight.bold,
                                  color: darkGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          color: lightGray,
                        ),

                        SizedBox(
                            height: CalculateSize.getResponsiveSize(
                                16, screenWidth)),

                        // Children List
                        _buildChildrenListStep(),

                        SizedBox(
                            height: CalculateSize.getResponsiveSize(
                                16, screenWidth)),

                        // Add More Child Button
                        Material(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AddChildFirstScreen(),
                                ),
                              );
                            },
                            child: SizedBox(
                              height: CalculateSize.getResponsiveSize(
                                  54, screenWidth),
                              width: CalculateSize.getResponsiveSize(
                                  236, screenWidth),
                              child: DashedBorder(
                                strokeWidth: 1.5,
                                color: lightBlue2,
                                gapWidth: 8.0,
                                borderRadius: 10.0,
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            CalculateSize.getResponsiveSize(
                                                24, screenWidth)),
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        '+  ${AppLocalizations.of(context)!.text_add_child}',
                                        style: TextStyle(
                                          color: lightBlue2,
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
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
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
                      ? CalculateSize.getResponsiveSize(168, screenWidth)
                      : CalculateSize.getResponsiveSize(250, screenWidth))
                  : CalculateSize.getResponsiveSize(84, screenWidth))
              : 0,
        ),
        child: ListView.builder(
          itemCount: childrenList.isNotEmpty ? childrenList.length : 0,
          itemBuilder: (context, index) {
            final student = childrenList[index];
            return Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    _mySharedPref
                        .setStudentId(student.externalId ?? 0)
                        .then((value) {
                      _mySharedPref
                          .setStudentModmeId(student.id ?? 0)
                          .then((value) {
                        _mySharedPref
                            .setBranchId(student.companyId ?? -1)
                            .then((value) {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainScreen()));
                        });
                      });
                    });
                  },
                  child: SizedBox(
                    height: CalculateSize.getResponsiveSize(72, screenWidth),
                    child: Slidable(
                      key: const ValueKey(0),
                      endActionPane: ActionPane(
                        extentRatio: 0.2,
                        motion: const ScrollMotion(),
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                deletedChildId = student.id;
                              });
                              _showConfirmationDialog(
                                  context, student.objectId!);
                            },
                            child: Container(
                              width: CalculateSize.getResponsiveSize(
                                  62, screenWidth),
                              height: CalculateSize.getResponsiveSize(
                                  62, screenWidth),
                              decoration: BoxDecoration(
                                color: errorColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      child: Card(
                        elevation: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: CalculateSize.getResponsiveSize(
                                  14, screenWidth),
                              vertical: CalculateSize.getResponsiveSize(
                                  4, screenWidth),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: CalculateSize.getResponsiveSize(
                                          56, screenWidth),
                                      width: CalculateSize.getResponsiveSize(
                                          56, screenWidth),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors
                                            .grey, // Set your desired background color
                                      ),
                                      child: profileList[index].studentId ==
                                              student.id
                                          ? ClipOval(
                                              child: Image.network(
                                                EndPoints.media_base_url +
                                                    profileList[index].avatar!,
                                                fit: BoxFit.cover,
                                                width: CalculateSize
                                                    .getResponsiveSize(
                                                        56, screenWidth),
                                                height: CalculateSize
                                                    .getResponsiveSize(
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
                                          maxWidth:
                                              CalculateSize.getResponsiveSize(
                                                  180, screenWidth)),
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(
                                          student.lastName != null &&
                                                  student.firstName != null
                                              ? '${student.lastName} ${student.firstName}'
                                              : '',
                                          style: TextStyle(
                                            color: accentColor,
                                            fontSize:
                                                CalculateSize.getResponsiveSize(
                                                    16, screenWidth),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (student.externalId == _currentStudentId)
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
                  ),
                ),
                SizedBox(
                    height: CalculateSize.getResponsiveSize(12, screenWidth)),
              ],
            );
          },
        ),
      ),
    );
  }
}
