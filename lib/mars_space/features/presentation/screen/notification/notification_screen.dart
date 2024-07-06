import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mars_it_app/injection_handler.dart';
import 'package:mars_it_app/mars_space/core/calculation/calculate_size.dart';
import 'package:mars_it_app/mars_space/core/theme/colors.dart';
import 'package:mars_it_app/mars_space/core/theme/strings.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/notification/bloc/notification_bloc.dart';

import '../../../../core/theme/theme.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: SvgPicture.asset('assets/icons/ic_back_button.svg',
              width: CalculateSize.getResponsiveSize(24, screenWidth), height: CalculateSize.getResponsiveSize(24, screenWidth), fit: BoxFit.scaleDown),
        ),
        titleSpacing: 0,
        title: Text(
          AppLocalizations.of(context)!.pageTitleNotifications,
          style: TextStyle(
            color: accentColor,
            fontSize: CalculateSize.getResponsiveSize(24, screenWidth),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => di.get<NotificationBloc>(),
        child: BlocConsumer<NotificationBloc, NotificationState>(
          builder: (context, state) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(gradient: gradient),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: CalculateSize.getResponsiveSize(80, screenWidth),
                      left: CalculateSize.getResponsiveSize(52, screenWidth),
                      right: CalculateSize.getResponsiveSize(52, screenWidth),
                    ),
                    child: SizedBox(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0x03335EF7),
                          border: Border.all(
                            color: const Color(0x08335EF7),
                            width: 0.4,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: CalculateSize.getResponsiveSize(
                                16, screenWidth),
                            horizontal: CalculateSize.getResponsiveSize(
                                34, screenWidth),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: CalculateSize.getResponsiveSize(
                                    56, screenWidth),
                                height: CalculateSize.getResponsiveSize(
                                    56, screenWidth),
                                decoration: const BoxDecoration(
                                  color: Color(0x08335EF7),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/emojis/emoji4.png',
                                    width: CalculateSize.getResponsiveSize(
                                        48, screenWidth),
                                    height: CalculateSize.getResponsiveSize(
                                        48, screenWidth),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: CalculateSize.getResponsiveSize(
                                      10, screenWidth)),
                              Text(
                                textAlign: TextAlign.center,
                                Strings.text_notification_empty,
                                style: TextStyle(
                                  color: accentColor,
                                  fontSize: CalculateSize.getResponsiveSize(
                                      22, screenWidth),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          listener: (context, state) {
            // some logic if needed
          },
        ),
      ),
    );
  }
}
