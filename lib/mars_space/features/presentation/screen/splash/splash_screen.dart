import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mars_it_app/mars_space/features/data/enum/loading_state_enum.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/main/main_screen.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/splash/bloc/splash_bloc.dart';

import '../../../../../injection_handler.dart';
import '../../../../core/theme/theme.dart';
import '../auth/login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // check user authorized or not
    di.get<SplashBloc>().add(CheckAuthEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => di.get<SplashBloc>(),
        child: BlocConsumer<SplashBloc, SplashState>(
          listener: (context, state) {
            if (state.state == AuthState.SIGNIN) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
              );
            }
          },
          builder: (context, state) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(gradient: gradient),
              child: Center(
                child: SvgPicture.asset(
                  "assets/icons/mars_logo.svg",
                  width: 80,
                  height: 80,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
