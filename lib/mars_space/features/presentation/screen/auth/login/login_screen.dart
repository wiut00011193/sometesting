import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mars_it_app/mars_space/core/calculation/calculate_size.dart';
import 'package:mars_it_app/mars_space/core/theme/colors.dart';
import 'package:mars_it_app/mars_space/core/theme/theme.dart';
import 'package:mars_it_app/mars_space/core/utils/output_utils.dart';
import 'package:mars_it_app/mars_space/features/data/enum/loading_state_enum.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/login_request_model.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/auth/add_child_first/add_child_first_screen.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/auth/signup/signup_screen.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/main/main_screen.dart';
import 'package:mars_it_app/mars_space/features/presentation/widget/emojis_animation_widget.dart';
import 'package:mars_it_app/mars_space/features/presentation/widget/loading_widget.dart';

import '../../../../../../injection_handler.dart';
import 'bloc/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _loginBloc = di.get<LoginBloc>();

  // Password Visibility
  bool _isObscured = true;

  bool _isErrorMsgShown = false;

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: SizedBox(
            height: 22,
            child: Image.asset("assets/images/mars_logo_appbar.png"),
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => _loginBloc,
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.status == LoadingState.LOADED) {
              if (state.isChildExist) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainScreen(),
                  ),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddChildFirstScreen(),
                  ),
                );
              }
            } else if (state.status == LoadingState.ERROR) {
              setState(() {
                _isErrorMsgShown = true;
              });
              if (state.errorMessage != 'Exception: Bad Request' &&
                  state.errorMessage != 'Exception: Not Found' &&
                  state.errorMessage != 'Exception: Unprocessable Entity') {
                toast('Keyinroq urunib ko\'ring');
              }
            }
          },
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
                  Container(
                    padding: EdgeInsets.only(
                        bottom:
                            CalculateSize.getResponsiveSize(100, screenWidth),
                        left: CalculateSize.getResponsiveSize(16, screenWidth),
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
                          // Phone Number Input
                          SizedBox(
                            height: CalculateSize.getResponsiveSize(
                                56, screenWidth),
                            child: TextField(
                              onChanged: (text) {
                                setState(() {
                                  _isErrorMsgShown = false;
                                });
                              },
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                color:
                                    _isErrorMsgShown ? errorColor : accentColor,
                                fontSize: CalculateSize.getResponsiveSize(
                                    16, screenWidth),
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
                                          CalculateSize.getResponsiveSize(
                                              12, screenWidth)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/ic_edt_phone.svg",
                                        fit: BoxFit.none,
                                      ),
                                      SizedBox(
                                          width:
                                              CalculateSize.getResponsiveSize(
                                                  12, screenWidth)),
                                      Text(
                                        '+998',
                                        style: TextStyle(
                                          color: _isErrorMsgShown
                                              ? errorColor
                                              : accentColor,
                                          fontSize:
                                              CalculateSize.getResponsiveSize(
                                                  16, screenWidth),
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              CalculateSize.getResponsiveSize(
                                                  12, screenWidth)),
                                      Container(
                                        width: 1,
                                        height: 24,
                                        color: lightGray,
                                      ),
                                    ],
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: _isErrorMsgShown
                                        ? errorColor
                                        : lightGray,
                                    width: 0.4,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: lightGray,
                                    width: 0.4,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                              height: CalculateSize.getResponsiveSize(
                                  8, screenWidth)),

                          // Password Input
                          SizedBox(
                            height: CalculateSize.getResponsiveSize(
                                56, screenWidth),
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
                                color:
                                    _isErrorMsgShown ? errorColor : accentColor,
                                fontSize: CalculateSize.getResponsiveSize(
                                    16, screenWidth),
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
                                        _isObscured ? lightGray : primaryColor,
                                        BlendMode.srcIn),
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
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: _isErrorMsgShown
                                        ? errorColor
                                        : lightGray,
                                    width: 0.4,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: lightGray,
                                    width: 0.4,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                              height: CalculateSize.getResponsiveSize(
                                  12, screenWidth)),

                          // Error Text
                          if (_isErrorMsgShown)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: CalculateSize.getResponsiveSize(
                                      12, screenWidth)),
                              child: Text(
                                'Telefon raqam yoki password noto\'g\'ri kiritildi, iltimos takror kiriting',
                                style: TextStyle(
                                  color: errorColor,
                                  fontSize: CalculateSize.getResponsiveSize(
                                      14, screenWidth),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                          if (_isErrorMsgShown)
                            SizedBox(
                                height: CalculateSize.getResponsiveSize(
                                    12, screenWidth)),

                          // LogIn Button
                          FilledButton(
                            onPressed: () async {
                              // check and post
                              final phone =
                                  '+998${phoneController.text.toString().trim()}';
                              final password =
                                  passwordController.text.toString().trim();
                              if (phone.isNotEmpty && password.isNotEmpty) {
                                _loginBloc.add(LoginUserEvent(
                                  requestModel: LoginRequestModel(
                                    phone: phone,
                                    password: password,
                                  ),
                                ));
                              } else {
                                setState(() {
                                  _isErrorMsgShown = true;
                                });
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
                              "Kirish",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: CalculateSize.getResponsiveSize(
                                    14, screenWidth),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                              height: CalculateSize.getResponsiveSize(
                                  30, screenWidth)),

                          // SignUp Button
                          FilledButton(
                            onPressed: () {
                              // navigate to LoginScreen
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              minimumSize: MaterialStatePropertyAll(Size(
                                  double.infinity,
                                  CalculateSize.getResponsiveSize(
                                      48, screenWidth))),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: accentColor,
                                  ),
                                ),
                              ),
                              backgroundColor: const MaterialStatePropertyAll(
                                  Colors.transparent),
                            ),
                            child: Text(
                              "Ro'yxatdan o'tish",
                              style: TextStyle(
                                fontSize: CalculateSize.getResponsiveSize(
                                    14, screenWidth),
                                color: accentColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
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
