import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mars_it_app/mars_space/core/calculation/calculate_size.dart';
import 'package:mars_it_app/mars_space/core/theme/colors.dart';
import 'package:mars_it_app/mars_space/core/theme/theme.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_exam_result_response_entity.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/main/pages/learning/widget/exam_card_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ExamPage extends StatefulWidget {
  final int module;
  final GetExamResultResponseEntity examResult;
  const ExamPage({
    super.key,
    required this.examResult,
    required this.module,
  });

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {

  Future<void> _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: SvgPicture.asset('assets/icons/ic_back_button.svg',
              width: CalculateSize.getResponsiveSize(24, screenWidth),
              height: CalculateSize.getResponsiveSize(24, screenWidth),
              fit: BoxFit.scaleDown),
        ),
        titleSpacing: 0,
        title: Text(
          AppLocalizations.of(context)!.examResults,
          style: TextStyle(
            color: accentColor,
            fontSize: CalculateSize.getResponsiveSize(24, screenWidth),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(gradient: gradient),
        child: Column(
          children: [
            Container(
              height: 1,
              color: lightGray4,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal:
                        CalculateSize.getResponsiveSize(20, screenWidth)),
                child: Column(
                  children: [
                    SizedBox(
                        height:
                            CalculateSize.getResponsiveSize(12, screenWidth)),
                    ExamCard(
                      examResult: widget.examResult,
                      module: widget.module,
                    ),
                    SizedBox(
                        height:
                            CalculateSize.getResponsiveSize(10, screenWidth)),
                    // File and Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Material(
                            elevation: 2,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: EdgeInsets.all(
                                  CalculateSize.getResponsiveSize(
                                      12, screenWidth)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.text_file,
                                        style: TextStyle(
                                          color: accentColor,
                                          fontSize:
                                              CalculateSize.getResponsiveSize(
                                                  18, screenWidth),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      // Text(
                                      //   '20.10.2023',
                                      //   style: TextStyle(
                                      //     color: lightGray2,
                                      //     fontSize: 12,
                                      //     fontWeight: FontWeight.w500,
                                      //   ),
                                      // )
                                    ],
                                  ),
                                  SizedBox(
                                      height: CalculateSize.getResponsiveSize(
                                          16, screenWidth)),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            CalculateSize.getResponsiveSize(
                                                24.5, screenWidth)),
                                    child: InkWell(
                                      onTap: () {
                                        if (widget.examResult.data![0].file ==
                                                null ||
                                            widget.examResult.data![0].file!
                                                .isEmpty) {
                                          return;
                                        }
                                        
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/ic_file.svg',
                                            width:
                                                CalculateSize.getResponsiveSize(
                                                    14, screenWidth),
                                            height:
                                                CalculateSize.getResponsiveSize(
                                                    14, screenWidth),
                                            color: widget.examResult.data![0]
                                                        .file !=
                                                    null
                                                ? primaryColor
                                                : lightGray2,
                                          ),
                                          SizedBox(
                                              width: CalculateSize
                                                  .getResponsiveSize(
                                                      4, screenWidth)),
                                          Flexible(
                                            child: Text(
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              widget.examResult.data![0].file !=
                                                      null
                                                  ? widget
                                                      .examResult.data![0].file!
                                                      .split('/')
                                                      .last
                                                  : AppLocalizations.of(context)!.text_no_file,
                                              style: TextStyle(
                                                color: widget.examResult
                                                            .data![0].file !=
                                                        null
                                                    ? primaryColor
                                                    : lightGray2,
                                                fontSize: CalculateSize
                                                    .getResponsiveSize(
                                                        12, screenWidth),
                                                fontWeight: FontWeight.w600,
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
                          ),
                        ),
                        SizedBox(
                            width: CalculateSize.getResponsiveSize(
                                10, screenWidth)),
                        Expanded(
                          child: Material(
                            elevation: 2,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: EdgeInsets.all(
                                  CalculateSize.getResponsiveSize(
                                      12, screenWidth)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.text_link,
                                    style: TextStyle(
                                      color: accentColor,
                                      fontSize: CalculateSize.getResponsiveSize(
                                          18, screenWidth),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(
                                      height: CalculateSize.getResponsiveSize(
                                          16, screenWidth)),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            CalculateSize.getResponsiveSize(
                                                24.5, screenWidth)),
                                    child: InkWell(
                                      onTap: () {
                                        if (widget.examResult.data![0].link ==
                                                null ||
                                            widget.examResult.data![0].link!
                                                .isEmpty) {
                                          return;
                                        }
                                        _launchURL(
                                            widget.examResult.data![0].link!);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/ic_link.svg',
                                            width:
                                                CalculateSize.getResponsiveSize(
                                                    14, screenWidth),
                                            height:
                                                CalculateSize.getResponsiveSize(
                                                    14, screenWidth),
                                            color: widget.examResult.data![0]
                                                            .link !=
                                                        null &&
                                                    widget.examResult.data![0]
                                                        .link!.isNotEmpty
                                                ? primaryColor
                                                : lightGray2,
                                          ),
                                          SizedBox(
                                              width: CalculateSize
                                                  .getResponsiveSize(
                                                      4, screenWidth)),
                                          Flexible(
                                            child: Text(
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              widget.examResult.data![0].link !=
                                                          null &&
                                                      widget.examResult.data![0]
                                                          .link!.isNotEmpty
                                                  ? widget
                                                      .examResult.data![0].link!
                                                  : AppLocalizations.of(context)!.text_no_link,
                                              style: TextStyle(
                                                color: widget
                                                                .examResult
                                                                .data![0]
                                                                .link !=
                                                            null &&
                                                        widget
                                                            .examResult
                                                            .data![0]
                                                            .link!
                                                            .isNotEmpty
                                                    ? primaryColor
                                                    : lightGray2,
                                                fontSize: CalculateSize
                                                    .getResponsiveSize(
                                                        12, screenWidth),
                                                fontWeight: FontWeight.w600,
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
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                        height:
                            CalculateSize.getResponsiveSize(10, screenWidth)),

                    // Feedback
                    if (widget.examResult.data![0].feedback != null &&
                        widget.examResult.data![0].feedback!.isNotEmpty)
                      SizedBox(
                        width: double.infinity,
                        child: Material(
                          elevation: 2,
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: EdgeInsets.all(
                                CalculateSize.getResponsiveSize(
                                    12, screenWidth)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.text_feedback,
                                  style: TextStyle(
                                    color: accentColor,
                                    fontSize: CalculateSize.getResponsiveSize(
                                        18, screenWidth),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                    height: CalculateSize.getResponsiveSize(
                                        16, screenWidth)),
                                Text(
                                  widget.examResult.data![0].feedback!,
                                  style: TextStyle(
                                    color: lightGray2,
                                    fontSize: CalculateSize.getResponsiveSize(
                                        14, screenWidth),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    SizedBox(
                        height:
                            CalculateSize.getResponsiveSize(10, screenWidth)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
