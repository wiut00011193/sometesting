import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mars_it_app/mars_space/core/calculation/calculate_size.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/login_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/send_verification_code_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/signup_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/verify_phone_number_request_model.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/auth/signup/bloc/sign_up_bloc.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/screens.dart';
import 'package:mars_it_app/mars_space/features/presentation/widget/emojis_animation_widget.dart';

import '../../../../../../injection_handler.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../../core/utils/output_utils.dart';
import '../../../../data/enum/loading_state_enum.dart';
import '../../../widget/loading_widget.dart';
import '../add_child_first/add_child_first_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignUpBloc _signUpBloc = di.get<SignUpBloc>();

  TextEditingController phoneController = TextEditingController();
  TextEditingController verificationCodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();

  int currentStep = 1;
  int _timerCount = 60;
  late Timer _timer;
  bool _isObscuredOne = true;
  bool _isObscuredTwo = true;
  bool acceptedTerms = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _stopTimer();
  }

  @override
  void dispose() {
    phoneController.dispose();
    verificationCodeController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerCount > 0) {
        setState(() {
          _timerCount--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  void moveToNextStep() {
    if (currentStep == 1) {
      _startTimer(); // Start timer only when moving to second step
    }
    setState(() {
      currentStep++;
    });
  }

  void moveToPreviousStep() {
    if (currentStep == 2) {
      _stopTimer(); // Stop timer if moving away from the second step
    }
    setState(() {
      currentStep--;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(
              left: CalculateSize.getResponsiveSize(16, screenWidth)),
          child: SizedBox(
            height: CalculateSize.getResponsiveSize(22, screenWidth),
            child: Image.asset("assets/images/mars_logo_appbar.png"),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
                right: CalculateSize.getResponsiveSize(16, screenWidth)),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: Row(
                children: [
                  Text(
                    "Hisobga kirish",
                    style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.w600,
                        fontSize:
                            CalculateSize.getResponsiveSize(16, screenWidth)),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    "assets/icons/ic_next_signup.svg",
                    fit: BoxFit.none,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => _signUpBloc,
        child: BlocConsumer<SignUpBloc, SignUpState>(
          builder: (context, state) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(gradient: gradient),
              child: Stack(
                children: [
                  // BACKGROUND EMOJIS
                  Stack(
                    children: <Widget>[
                      const EmojisAnimationWidget(),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromRGBO(234, 248, 255, 0),
                              Color.fromRGBO(234, 248, 255, 0.95),
                              Color(0xFFE9F7FE),
                            ],
                            stops: [0.0, 0.5986, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: currentStep != 3
                            ? MediaQuery.of(context).size.height / 3.6
                            : MediaQuery.of(context).size.height / 8),
                    child: Container(
                      padding: EdgeInsets.only(
                          left:
                              CalculateSize.getResponsiveSize(16, screenWidth),
                          right:
                              CalculateSize.getResponsiveSize(16, screenWidth)),
                      child: Builder(builder: (context) {
                        if (state.status == LoadingState.LOADING) {
                          return const LoadingWidget();
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (currentStep == 1)
                              _buildPhoneStep()
                            else if (currentStep == 2)
                              _buildVerificationStep()
                            else if (currentStep == 3)
                              _buildPasswordStep(),

                            SizedBox(
                                height: CalculateSize.getResponsiveSize(
                                    16, screenWidth)),

                            // Button
                            FilledButton(
                              onPressed: !acceptedTerms && currentStep == 3
                                  ? null
                                  : () {
                                      final phone =
                                          "+998${phoneController.text.toString().trim()}";
                                      if (currentStep == 1) {
                                        if (phone.isNotEmpty &&
                                            phone.length == 13) {
                                          _signUpBloc.add(CheckUserExistsEvent(
                                              logInRequestModel:
                                                  LoginRequestModel(
                                                      phone: phone,
                                                      password: '')));
                                        } else {
                                          toast("Invalid Phone Number");
                                        }
                                      } else if (currentStep == 2) {
                                        final verificationCode =
                                            verificationCodeController.text
                                                .toString()
                                                .trim();
                                        if (verificationCode.isNotEmpty) {
                                          _signUpBloc.add(VerifyPhoneNumberEvent(
                                              verifyPhoneNumberRequestModel:
                                                  VerifyPhoneNumberRequestModel(
                                                      phone: phone,
                                                      code: verificationCode)));
                                        } else {
                                          toast("Enter Verification Code");
                                        }
                                      } else if (currentStep == 3) {
                                        // Submit the data
                                        final password = passwordController.text
                                            .toString()
                                            .trim();
                                        final passwordConfirmation =
                                            passwordConfirmationController.text
                                                .toString()
                                                .trim();

                                        if (password.isEmpty) {
                                          toast("Enter Password!");
                                        } else if (passwordConfirmation
                                                .isEmpty ||
                                            password != passwordConfirmation) {
                                          toast("Confirm Password!");
                                        } else {
                                          _signUpBloc.add(SignUpUserEvent(
                                            signUpRequestModel:
                                                SignUpRequestModel(
                                              phone: phone,
                                              password: password,
                                            ),
                                          ));
                                        }
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
                                backgroundColor: !acceptedTerms &&
                                        currentStep == 3
                                    ? MaterialStatePropertyAll(lightGray)
                                    : MaterialStatePropertyAll(primaryColor),
                              ),
                              child: Text(
                                currentStep < 3
                                    ? 'Keyingisi'
                                    : 'Ro\'yxatdan o\'tish',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: CalculateSize.getResponsiveSize(
                                        14, screenWidth)),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            );
          },
          listener: (context, state) {
            if (state.status == LoadingState.LOADED) {
              if (currentStep == 1) {
                final userExists = state.checkUserExistsResult.getOrElse(
                    () => throw Exception('USER EXISTS COULD NOT BE CHECKED'));
                if (!userExists) {
                  final phone = "+998${phoneController.text.toString().trim()}";
                  _signUpBloc.add(SendVerificationCodeEvent(
                      sendVerificationCodeRequestModel:
                          SendVerificationCodeRequestModel(phone: phone)));
                  moveToNextStep();
                } else {
                  toast('SUCH USER ALREADY EXISTS');
                }
              } else if (currentStep == 3) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddChildFirstScreen(),
                  ),
                );
              } else if (currentStep == 2) {
                final verificationResult = state.verificationResult
                    .getOrElse(() => throw Exception('NOT VERIFIED'));
                if (verificationResult.isVerified != null &&
                    verificationResult.isVerified!) {
                  moveToNextStep();
                } else {
                  toast('INCORRECT VERIFICATION CODE');
                }
              }
            } else if (state.status == LoadingState.ERROR) {
              toast("Wrong = ${state.errorMessage}");
            }
          },
        ),
      ),
    );
  }

  Widget _buildPhoneStep() {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SizedBox(
          height: CalculateSize.getResponsiveSize(56, screenWidth),
          child: TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            style: TextStyle(
              color: accentColor,
              fontSize: CalculateSize.getResponsiveSize(16, screenWidth),
            ),
            decoration: InputDecoration(
              hintText: 'Telefon raqam...',
              hintStyle: TextStyle(color: lightGray),
              fillColor: Colors.white,
              contentPadding: EdgeInsets.zero,
              filled: true,
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal:
                        CalculateSize.getResponsiveSize(12, screenWidth)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/ic_edt_phone.svg",
                      fit: BoxFit.none,
                    ),
                    SizedBox(
                        width:
                            CalculateSize.getResponsiveSize(12, screenWidth)),
                    Text(
                      '+998',
                      style: TextStyle(
                          color: accentColor,
                          fontSize:
                              CalculateSize.getResponsiveSize(16, screenWidth),
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                        width:
                            CalculateSize.getResponsiveSize(12, screenWidth)),
                    Container(
                      width: 1,
                      height: 24,
                      color: lightGray,
                    ),
                  ],
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationStep() {
    final screenWidth = MediaQuery.of(context).size.width;

    // Flag to determine whether to display the timer or the Send Again button
    bool showTimer = _timerCount > 0;

    return Column(
      children: [
        SizedBox(
          height: CalculateSize.getResponsiveSize(56, screenWidth),
          child: Stack(
            children: [
              TextField(
                controller: verificationCodeController,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: CalculateSize.getResponsiveSize(16, screenWidth),
                  color: accentColor,
                ),
                decoration: InputDecoration(
                  hintText: 'Kodni kiriting',
                  hintStyle: TextStyle(color: lightGray),
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.only(
                      left: CalculateSize.getResponsiveSize(16, screenWidth)),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              if (showTimer) // Display the timer if showTimer is true
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: CalculateSize.getResponsiveSize(8, screenWidth),
                      right: CalculateSize.getResponsiveSize(16, screenWidth),
                      bottom: CalculateSize.getResponsiveSize(8, screenWidth),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 1,
                          height: 22,
                          color: lightGray,
                        ),
                        SizedBox(
                            width: CalculateSize.getResponsiveSize(
                                10, screenWidth)),
                        Text(
                          '${(_timerCount ~/ 60).toString().padLeft(2, '0')} : ${(_timerCount % 60).toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: accentColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              // Send Again Button
              if (!showTimer) // Display the Send Again button if showTimer is false
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: CalculateSize.getResponsiveSize(8, screenWidth),
                      right: CalculateSize.getResponsiveSize(8, screenWidth),
                      bottom: CalculateSize.getResponsiveSize(8, screenWidth),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 1,
                          height: 22,
                          color: lightGray,
                        ),
                        TextButton(
                          onPressed: () {
                            // Restart the timer and resend verification code
                            setState(() {
                              _timerCount = 60;
                            });
                            _startTimer();
                            final phone =
                                "+998${phoneController.text.toString().trim()}";
                            _signUpBloc.add(SendVerificationCodeEvent(
                                sendVerificationCodeRequestModel:
                                    SendVerificationCodeRequestModel(
                                        phone: phone)));
                          },
                          child: Text(
                            'Send again',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: CalculateSize.getResponsiveSize(
                                  14, screenWidth),
                              fontWeight: FontWeight.bold,
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
        SizedBox(height: CalculateSize.getResponsiveSize(16, screenWidth)),
      ],
    );
  }

  Widget _buildPasswordStep() {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SizedBox(
          height: CalculateSize.getResponsiveSize(56, screenWidth),
          child: TextField(
            controller: passwordController,
            obscureText: _isObscuredOne,
            obscuringCharacter: '●',
            style: TextStyle(
              color: accentColor,
              fontSize: CalculateSize.getResponsiveSize(16, screenWidth),
            ),
            decoration: InputDecoration(
              hintText: 'Password',
              hintStyle: TextStyle(color: lightGray),
              fillColor: Colors.white,
              contentPadding: EdgeInsets.zero,
              filled: true,
              prefixIcon: SvgPicture.asset(
                "assets/icons/ic_edt_password.svg",
                fit: BoxFit.none,
              ),
              suffixIcon: IconButton(
                icon: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      _isObscuredOne ? lightGray : primaryColor,
                      BlendMode.srcIn),
                  child: SvgPicture.asset(
                    'assets/icons/ic_eye_password.svg',
                    fit: BoxFit.none,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _isObscuredOne = !_isObscuredOne;
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
        SizedBox(height: CalculateSize.getResponsiveSize(8, screenWidth)),
        SizedBox(
          height: CalculateSize.getResponsiveSize(56, screenWidth),
          child: TextField(
            controller: passwordConfirmationController,
            obscureText: _isObscuredTwo,
            obscuringCharacter: '●',
            style: TextStyle(
              color: accentColor,
              fontSize: CalculateSize.getResponsiveSize(16, screenWidth),
            ),
            decoration: InputDecoration(
              hintText: 'Confirm password',
              hintStyle: TextStyle(color: lightGray),
              fillColor: Colors.white,
              contentPadding: EdgeInsets.zero,
              filled: true,
              prefixIcon: SvgPicture.asset(
                "assets/icons/ic_edt_password.svg",
                fit: BoxFit.none,
              ),
              suffixIcon: IconButton(
                icon: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      _isObscuredTwo ? lightGray : primaryColor,
                      BlendMode.srcIn),
                  child: SvgPicture.asset(
                    'assets/icons/ic_eye_password.svg',
                    fit: BoxFit.none,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _isObscuredTwo = !_isObscuredTwo;
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
        SizedBox(height: CalculateSize.getResponsiveSize(16, screenWidth)),
        CheckboxListTile(
          title: RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.grey,
                fontSize: CalculateSize.getResponsiveSize(14, screenWidth),
              ),
              children: [
                const TextSpan(
                  text: "I have read and I understand Mars Space's ",
                ),
                TextSpan(
                  text: "Terms and Conditions",
                  style: TextStyle(
                    color: accentColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const TextSpan(
                  text: " and ",
                ),
                TextSpan(
                  text: "Privacy Policy",
                  style: TextStyle(
                    color: accentColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
          value: acceptedTerms,
          onChanged: (newValue) {
            setState(() {
              acceptedTerms = newValue!;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: const EdgeInsets.all(0),
          checkColor: Colors.white,
          activeColor: primaryColor,
          side: MaterialStateBorderSide.resolveWith(
            (states) => const BorderSide(width: 1.0, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
