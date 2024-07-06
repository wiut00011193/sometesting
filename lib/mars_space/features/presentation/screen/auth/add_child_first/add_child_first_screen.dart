import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mars_it_app/mars_space/core/calculation/calculate_size.dart';
import 'package:mars_it_app/mars_space/core/theme/colors.dart';
import 'package:mars_it_app/mars_space/core/theme/strings.dart';

import '../../../../../core/theme/theme.dart';
import '../add_child_second/add_child_second_screen.dart';

class AddChildFirstScreen extends StatefulWidget {
  const AddChildFirstScreen({super.key});

  @override
  State<AddChildFirstScreen> createState() => _AddChildFirstScreenState();
}

class _AddChildFirstScreenState extends State<AddChildFirstScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
            child: SvgPicture.asset(
              'assets/icons/ic_back_button.svg',
              width: CalculateSize.getResponsiveSize(24, screenWidth),
              height: CalculateSize.getResponsiveSize(24, screenWidth),
              fit: BoxFit.scaleDown,
            ),
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
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(gradient: gradient),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal:
                        CalculateSize.getResponsiveSize(16, screenWidth)),
                child: Text(
                  Strings.text_add_child,
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: CalculateSize.getResponsiveSize(22, screenWidth),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                  height: CalculateSize.getResponsiveSize(14, screenWidth)),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddChildSecondScreen(),
                    ),
                  );
                },
                child: Image.asset('assets/images/add_child_icon.png'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
