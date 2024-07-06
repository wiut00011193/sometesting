import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mars_it_app/injection_handler.dart';
import 'package:mars_it_app/mars_space/core/theme/colors.dart';
import 'package:mars_it_app/mars_space/core/utils/constants.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/main/bloc/main_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MainBloc _mainBloc = di.get<MainBloc>();

  void refreshMainScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MainScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _mainBloc,
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () => Future.value(state.checkScreen),
            child: Scaffold(
              body: IndexedStack(
                index: state.selectedIndex,
                children: pages,
              ),
              bottomNavigationBar: BottomNavigationBar(
                elevation: 8,
                iconSize: 24,
                currentIndex: state.selectedIndex,
                selectedItemColor: primaryColor,
                unselectedItemColor: accentColor,
                selectedFontSize: 14,
                unselectedFontSize: 14,
                onTap: (value) => _mainBloc.add(ItemTappedEvent(index: value)),
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    activeIcon:
                        SvgPicture.asset("assets/icons/ic_home_selected.svg"),
                    icon:
                        SvgPicture.asset("assets/icons/ic_home_unselected.svg"),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    activeIcon: SvgPicture.asset(
                        "assets/icons/ic_learning_selected.svg"),
                    icon: SvgPicture.asset(
                        "assets/icons/ic_learning_unselected.svg"),
                    label: "Learning",
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    activeIcon: Image.asset("assets/images/rating_selected.png", width: 24, height: 24),
                    icon: Image.asset("assets/images/rating_unselected.png", width: 24, height: 24),
                    label: "Rating",
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    activeIcon: Image.asset(
                        "assets/icons/ic_profile_selected.png"),
                    icon: SvgPicture.asset(
                        "assets/icons/ic_profile_unselected.svg"),
                    label: "Profile",
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
