import 'package:flutter/material.dart';
import 'package:mars_it_app/mars_space/core/calculation/calculate_size.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mars_it_app/mars_space/core/theme/colors.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentBottomSheetWidget extends StatefulWidget {
  final String paymentUrl;
  const PaymentBottomSheetWidget({
    super.key,
    required this.paymentUrl,
  });

  @override
  State<PaymentBottomSheetWidget> createState() =>
      _PaymentBottomSheetWidgetState();
}

Future<void> _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $uri';
    }
  }

class _PaymentBottomSheetWidgetState extends State<PaymentBottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: CalculateSize.getResponsiveSize(16, screenWidth)),
        child: Column(
          children: [
            SizedBox(height: CalculateSize.getResponsiveSize(5, screenWidth)),
            Container(
              height: CalculateSize.getResponsiveSize(5, screenWidth),
              width: CalculateSize.getResponsiveSize(36, screenWidth),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.5),
                color: lightGray,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: CalculateSize.getResponsiveSize(16, screenWidth), bottom: CalculateSize.getResponsiveSize(10, screenWidth)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.text_make_payment,
                    style: TextStyle(
                      fontSize: CalculateSize.getResponsiveSize(16, screenWidth),
                      fontWeight: FontWeight.w700,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: lightGray,
            ),
            SizedBox(height: CalculateSize.getResponsiveSize(16, screenWidth)),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 20,
                runSpacing: 27,
                children: List.generate(1, (index) {
                  return GestureDetector(
                    onTap: () async {
                      _launchURL(widget.paymentUrl);
                    },
                    child: Column(
                      children: [
                        Container(
                          width: CalculateSize.getResponsiveSize(60, screenWidth),
                          height: CalculateSize.getResponsiveSize(60, screenWidth),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: lightGray5,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              'assets/images/uzum_bank.png',
                              width: CalculateSize.getResponsiveSize(50, screenWidth),
                              height: CalculateSize.getResponsiveSize(50, screenWidth),
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                        SizedBox(height: CalculateSize.getResponsiveSize(7, screenWidth)),
                        Text(
                          "Uzum Bank",
                          style: TextStyle(
                            color: accentColor,
                            fontSize: CalculateSize.getResponsiveSize(12, screenWidth),
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
