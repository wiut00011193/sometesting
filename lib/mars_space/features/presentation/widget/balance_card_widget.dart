import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mars_it_app/mars_space/core/calculation/calculate_size.dart';
import 'package:mars_it_app/mars_space/core/theme/colors.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/child_balance_response_entity.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BalanceCardWidget extends StatefulWidget {
  final ChildBalanceResponseEntity childBalance;
  final Function() onPayButtonClick;

  const BalanceCardWidget({
    super.key,
    required this.childBalance,
    required this.onPayButtonClick,
  });

  @override
  State<BalanceCardWidget> createState() => _BalanceCardWidgetState();
}

class _BalanceCardWidgetState extends State<BalanceCardWidget> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Material(
      elevation: 2,
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: CalculateSize.getResponsiveSize(16, screenWidth),
            vertical: CalculateSize.getResponsiveSize(12, screenWidth)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // text "to'lov holat"
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth:
                          CalculateSize.getResponsiveSize(130, screenWidth)),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      AppLocalizations.of(context)!.text_payment_status,
                      style: TextStyle(
                        color: accentColor,
                        fontSize:
                            CalculateSize.getResponsiveSize(18, screenWidth),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                // Status "Faol" | "Qarzdorlik"
                Container(
                  width: CalculateSize.getResponsiveSize(90, screenWidth),
                  height: CalculateSize.getResponsiveSize(32, screenWidth),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: widget.childBalance.balance! >= 0
                        ? lightGreen4
                        : errorColor.withOpacity(0.08),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          CalculateSize.getResponsiveSize(10, screenWidth),
                      vertical: CalculateSize.getResponsiveSize(6, screenWidth),
                    ),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        widget.childBalance.balance! >= 0
                            ? AppLocalizations.of(context)!.text_child_active
                            : AppLocalizations.of(context)!.text_child_inactive,
                        style: TextStyle(
                          color: widget.childBalance.balance! >= 0
                              ? lightGreen
                              : errorColor,
                          fontSize:
                              CalculateSize.getResponsiveSize(14, screenWidth),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: CalculateSize.getResponsiveSize(10, screenWidth)),
            if (widget.childBalance.balance! >= 0)
              SizedBox(
                  height: CalculateSize.getResponsiveSize(10, screenWidth)),

            // Balance
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Balance
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: CalculateSize.getResponsiveSize(
                              199, screenWidth)),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Row(
                          children: [
                            Text(
                              NumberFormat("#,###")
                                  .format(widget.childBalance.balance),
                              style: TextStyle(
                                color: widget.childBalance.balance! >= 0
                                    ? lightGreen
                                    : errorColor,
                                fontSize: CalculateSize.getResponsiveSize(
                                    32, screenWidth),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                                width: CalculateSize.getResponsiveSize(
                                    2, screenWidth)),
                            Text(
                              "so'm",
                              style: TextStyle(
                                color: widget.childBalance.balance! >= 0
                                    ? lightGreen
                                    : errorColor,
                                fontSize: CalculateSize.getResponsiveSize(
                                    18, screenWidth),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Message for parent
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth:
                            CalculateSize.getResponsiveSize(200, screenWidth),
                      ),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          widget.childBalance.balance! >= 0
                              ? AppLocalizations.of(context)!.text_course_payment_paid
                              : AppLocalizations.of(context)!.text_course_payment_reminder,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: CalculateSize.getResponsiveSize(
                                12, screenWidth),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (widget.childBalance.balance! >= 0)
                  Image.asset(
                    'assets/images/avatar_thumbs_up.png',
                    height: CalculateSize.getResponsiveSize(80, screenWidth),
                    width: CalculateSize.getResponsiveSize(80, screenWidth),
                  ),
              ],
            ),

            if (widget.childBalance.balance! < 0)
              SizedBox(
                  height: CalculateSize.getResponsiveSize(10, screenWidth)),

            // Pay button
            if (widget.childBalance.balance! < 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: widget.onPayButtonClick,
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(errorColor),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all(Size(
                          CalculateSize.getResponsiveSize(124, screenWidth),
                          CalculateSize.getResponsiveSize(40, screenWidth))),
                      maximumSize: MaterialStateProperty.all(Size(
                          CalculateSize.getResponsiveSize(124, screenWidth),
                          CalculateSize.getResponsiveSize(40, screenWidth))),
                    ),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        AppLocalizations.of(context)!.text_make_payment,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              CalculateSize.getResponsiveSize(14, screenWidth),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
