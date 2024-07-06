import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mars_it_app/mars_space/core/calculation/calculate_size.dart';
import 'package:mars_it_app/mars_space/core/theme/colors.dart';
import 'package:mars_it_app/mars_space/core/theme/theme.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_course_element_response_entity.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AssignmentPage extends StatefulWidget {
  final GetCourseElementResponseEntity courseElement;
  final int index;
  const AssignmentPage({
    super.key,
    required this.courseElement,
    required this.index,
  });

  @override
  State<AssignmentPage> createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
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
          widget.courseElement.title!.uz!,
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          CalculateSize.getResponsiveSize(20, screenWidth)),
                  child: Column(
                    children: [
                      SizedBox(
                          height:
                              CalculateSize.getResponsiveSize(10, screenWidth)),
                      // Assignment Info
                      Container(
                        width: double.infinity,
                        decoration:
                            widget.courseElement.answer!.status != 'opened'
                                ? null
                                : const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFFFF7D58),
                                        Color(0xFFE33D0E),
                                      ],
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                  ),
                        child: Material(
                          elevation: 2,
                          borderRadius: BorderRadius.circular(12),
                          shadowColor:
                              widget.courseElement.answer!.status == 'opened' ||
                                      widget.courseElement.answer!.status ==
                                          'denied'
                                  ? Colors.transparent
                                  : null,
                          color: widget.courseElement.answer!.status == 'denied'
                              ? const Color(0xffFACC15).withOpacity(0.8)
                              : widget.courseElement.answer!.status == 'opened'
                                  ? Colors.transparent
                                  : widget.courseElement.answer!.status ==
                                          'not_checked'
                                      ? markNull
                                      : lightGreen,
                          child: Padding(
                            padding: EdgeInsets.all(
                                CalculateSize.getResponsiveSize(
                                    12, screenWidth)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width:
                                              CalculateSize.getResponsiveSize(
                                                  204, screenWidth),
                                          child: Text(
                                            widget.courseElement.title!.uz!,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: CalculateSize
                                                  .getResponsiveSize(
                                                      18, screenWidth),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          widget.courseElement.answer!.status ==
                                                  'denied'
                                              ? AppLocalizations.of(context)!
                                                  .text_assignment_denied
                                              : widget.courseElement.answer!
                                                          .status ==
                                                      'opened'
                                                  ? AppLocalizations.of(
                                                          context)!
                                                      .text_assignment_not_uploaded
                                                  : widget.courseElement.answer!
                                                              .mark !=
                                                          null
                                                      ? AppLocalizations.of(
                                                              context)!
                                                          .text_assignment_checked
                                                      : AppLocalizations.of(
                                                              context)!
                                                          .text_assignment_pending,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                CalculateSize.getResponsiveSize(
                                                    14, screenWidth),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    SizedBox(
                                      width: CalculateSize.getResponsiveSize(
                                          204, screenWidth),
                                      child: Text(
                                        widget.courseElement.about!.uz!,
                                        style: TextStyle(
                                          color: widget.courseElement.answer!
                                                      .status ==
                                                  'opened'
                                              ? lightGray5
                                              : widget.courseElement.answer!
                                                              .status ==
                                                          'not_checked' ||
                                                      widget.courseElement
                                                              .answer!.status ==
                                                          'denied'
                                                  ? lightGray5
                                                  : lightGreen3,
                                          fontSize:
                                              CalculateSize.getResponsiveSize(
                                                  14, screenWidth),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height: CalculateSize.getResponsiveSize(
                                        16, screenWidth)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: widget.courseElement.answer!
                                                        .status ==
                                                    'opened' ||
                                                widget.courseElement.answer!
                                                        .status ==
                                                    'denied'
                                            ? Colors.white
                                            : widget.courseElement.answer!
                                                        .status ==
                                                    'not_checked'
                                                ? Colors.white
                                                : lightGreen2,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                CalculateSize.getResponsiveSize(
                                                    12, screenWidth),
                                            vertical:
                                                CalculateSize.getResponsiveSize(
                                                    9, screenWidth)),
                                        child: Text(
                                          widget.index >= 10
                                              ? widget.index.toString()
                                              : '0${widget.index}',
                                          style: TextStyle(
                                            color: widget.courseElement.answer!
                                                        .status ==
                                                    'denied'
                                                ? const Color(0xffFACC15)
                                                : widget.courseElement.answer!
                                                            .status ==
                                                        'opened'
                                                    ? primaryColor
                                                    : widget
                                                                .courseElement
                                                                .answer!
                                                                .status ==
                                                            'not_checked'
                                                        ? markNull
                                                        : Colors.white,
                                            fontSize:
                                                CalculateSize.getResponsiveSize(
                                                    16, screenWidth),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (widget.courseElement.answer!.mark !=
                                            null &&
                                        widget.courseElement.answer!.status !=
                                            'denied')
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: lightGreen2,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: CalculateSize
                                                  .getResponsiveSize(
                                                      8, screenWidth),
                                              vertical: CalculateSize
                                                  .getResponsiveSize(
                                                      4, screenWidth)),
                                          child: Text(
                                            widget.courseElement.answer!.mark
                                                .toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: CalculateSize
                                                  .getResponsiveSize(
                                                      20, screenWidth),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                          height:
                              CalculateSize.getResponsiveSize(10, screenWidth)),

                      // Task Description
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.text_about,
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
                                  widget
                                      .courseElement.project!.description!.uz!,
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

                      // Task Requirements
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
                                  AppLocalizations.of(context)!
                                      .text_requirements,
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
                                Column(
                                  children: List.generate(
                                      widget.courseElement.project!
                                          .requirements!.length, (index) {
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: CalculateSize
                                                  .getResponsiveSize(
                                                      10, screenWidth)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    width: CalculateSize
                                                        .getResponsiveSize(
                                                            12, screenWidth),
                                                    child: Text(
                                                      '${index + 1}.',
                                                      style: TextStyle(
                                                        color: lightGray2,
                                                        fontSize: CalculateSize
                                                            .getResponsiveSize(
                                                                14,
                                                                screenWidth),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  SizedBox(
                                                    width: CalculateSize
                                                        .getResponsiveSize(
                                                            245, screenWidth),
                                                    child: Text(
                                                      '${widget.courseElement.project!.requirements![index].uz}',
                                                      style: TextStyle(
                                                        color: lightGray2,
                                                        fontSize: CalculateSize
                                                            .getResponsiveSize(
                                                                14,
                                                                screenWidth),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    widget
                                                        .courseElement
                                                        .project!
                                                        .requirements![index]
                                                        .coins
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: accentColor,
                                                      fontSize: CalculateSize
                                                          .getResponsiveSize(
                                                              18, screenWidth),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 2),
                                                  Image.asset(
                                                    'assets/images/student_coin.png',
                                                    width: CalculateSize
                                                        .getResponsiveSize(
                                                            18, screenWidth),
                                                    height: CalculateSize
                                                        .getResponsiveSize(
                                                            18, screenWidth),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                            height:
                                                CalculateSize.getResponsiveSize(
                                                    10, screenWidth)),
                                      ],
                                    );
                                  }),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                          height:
                              CalculateSize.getResponsiveSize(10, screenWidth)),

                      // Theory
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
                                  AppLocalizations.of(context)!.text_theory,
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
                                  widget.courseElement.theory!.text!.uz!,
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
                                          AppLocalizations.of(context)!
                                              .text_file,
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
                                          if (widget.courseElement.answer!
                                                      .project!.file ==
                                                  null ||
                                              widget.courseElement.answer!
                                                  .project!.file!.isEmpty) {
                                            return;
                                          }
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/ic_file.svg',
                                              width: CalculateSize
                                                  .getResponsiveSize(
                                                      14, screenWidth),
                                              height: CalculateSize
                                                  .getResponsiveSize(
                                                      14, screenWidth),
                                              color: widget
                                                          .courseElement
                                                          .answer!
                                                          .project!
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
                                                widget.courseElement.answer!
                                                            .project!.file !=
                                                        null
                                                    ? widget.courseElement
                                                        .answer!.project!.file!
                                                        .split('/')
                                                        .last
                                                    : AppLocalizations.of(
                                                            context)!
                                                        .text_no_file,
                                                style: TextStyle(
                                                  color: widget
                                                              .courseElement
                                                              .answer!
                                                              .project!
                                                              .file !=
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
                                        fontSize:
                                            CalculateSize.getResponsiveSize(
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
                                          if (widget.courseElement.answer!
                                                      .project!.link ==
                                                  null ||
                                              widget.courseElement.answer!
                                                  .project!.link!.isEmpty) {
                                            return;
                                          }
                                          _launchURL(widget.courseElement
                                              .answer!.project!.link!);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/ic_link.svg',
                                              width: CalculateSize
                                                  .getResponsiveSize(
                                                      14, screenWidth),
                                              height: CalculateSize
                                                  .getResponsiveSize(
                                                      14, screenWidth),
                                              color: widget
                                                              .courseElement
                                                              .answer!
                                                              .project!
                                                              .link !=
                                                          null &&
                                                      widget
                                                          .courseElement
                                                          .answer!
                                                          .project!
                                                          .link!
                                                          .isNotEmpty
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
                                                widget
                                                                .courseElement
                                                                .answer!
                                                                .project!
                                                                .link !=
                                                            null &&
                                                        widget
                                                            .courseElement
                                                            .answer!
                                                            .project!
                                                            .link!
                                                            .isNotEmpty
                                                    ? widget.courseElement
                                                        .answer!.project!.link!
                                                    : AppLocalizations.of(
                                                            context)!
                                                        .text_no_link,
                                                style: TextStyle(
                                                  color: widget
                                                                  .courseElement
                                                                  .answer!
                                                                  .project!
                                                                  .link !=
                                                              null &&
                                                          widget
                                                              .courseElement
                                                              .answer!
                                                              .project!
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

                      // Text
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
                                  AppLocalizations.of(context)!.text_comment,
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
                                  padding: widget.courseElement.answer!.project!
                                                  .comments !=
                                              null &&
                                          widget.courseElement.answer!.project!
                                              .comments!.isNotEmpty
                                      ? const EdgeInsets.all(0)
                                      : EdgeInsets.symmetric(
                                          vertical:
                                              CalculateSize.getResponsiveSize(
                                                  24.5, screenWidth)),
                                  child: Row(
                                    mainAxisAlignment: widget
                                                    .courseElement
                                                    .answer!
                                                    .project!
                                                    .comments !=
                                                null &&
                                            widget.courseElement.answer!
                                                .project!.comments!.isNotEmpty
                                        ? MainAxisAlignment.start
                                        : MainAxisAlignment.center,
                                    children: [
                                      if (widget.courseElement.answer!.project!
                                                  .comments ==
                                              null ||
                                          widget.courseElement.answer!.project!
                                              .comments!.isEmpty)
                                        SvgPicture.asset(
                                          'assets/icons/ic_pen.svg',
                                          width:
                                              CalculateSize.getResponsiveSize(
                                                  14, screenWidth),
                                          height:
                                              CalculateSize.getResponsiveSize(
                                                  14, screenWidth),
                                        ),
                                      SizedBox(
                                          width:
                                              CalculateSize.getResponsiveSize(
                                                  4, screenWidth)),
                                      Text(
                                        widget.courseElement.answer!.project!
                                                        .comments !=
                                                    null &&
                                                widget
                                                    .courseElement
                                                    .answer!
                                                    .project!
                                                    .comments!
                                                    .isNotEmpty
                                            ? widget.courseElement.answer!
                                                .project!.comments!
                                                .split('\r')
                                                .first
                                            : AppLocalizations.of(context)!
                                                .text_no_comment,
                                        style: TextStyle(
                                          color: lightGray2,
                                          fontSize: widget.courseElement.answer!
                                                          .project!.comments !=
                                                      null &&
                                                  widget
                                                      .courseElement
                                                      .answer!
                                                      .project!
                                                      .comments!
                                                      .isNotEmpty
                                              ? CalculateSize.getResponsiveSize(
                                                  14, screenWidth)
                                              : CalculateSize.getResponsiveSize(
                                                  12, screenWidth),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      if (widget.courseElement.answer!.mark != null)
                        SizedBox(
                            height: CalculateSize.getResponsiveSize(
                                10, screenWidth)),

                      // Feedback
                      if (widget.courseElement.answer!.status == 'checked')
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
                                    widget.courseElement.answer!.comment != null
                                        ? widget.courseElement.answer!.comment
                                            .toString()
                                        : AppLocalizations.of(context)!
                                            .text_no_feedback,
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
            ),
          ],
        ),
      ),
    );
  }
}
