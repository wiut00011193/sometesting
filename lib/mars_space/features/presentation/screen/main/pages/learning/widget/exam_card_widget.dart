import 'package:flutter/material.dart';
import 'package:mars_it_app/mars_space/core/calculation/calculate_size.dart';
import 'package:mars_it_app/mars_space/core/theme/colors.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_exam_result_response_entity.dart';

class ExamCard extends StatefulWidget {
  final int module;
  final GetExamResultResponseEntity examResult;
  const ExamCard({
    super.key,
    required this.examResult,
    required this.module,
  });

  @override
  State<ExamCard> createState() => _ExamCardState();
}

class _ExamCardState extends State<ExamCard> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      color: lightGreen,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: CalculateSize.getResponsiveSize(12, screenWidth),
            horizontal: CalculateSize.getResponsiveSize(16, screenWidth)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: CalculateSize.getResponsiveSize(40, screenWidth),
                      height: CalculateSize.getResponsiveSize(40, screenWidth),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: Center(
                        child: Text(
                          widget.module.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: CalculateSize.getResponsiveSize(
                                16, screenWidth),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        width:
                            CalculateSize.getResponsiveSize(12, screenWidth)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.exam,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: CalculateSize.getResponsiveSize(
                                18, screenWidth),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${widget.module}-oy | ${AppLocalizations.of(context)!.text_exam_results}',
                          style: TextStyle(
                            color: lightGreen3,
                            fontSize: CalculateSize.getResponsiveSize(
                                12, screenWidth),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    '20.01.2023',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          CalculateSize.getResponsiveSize(12, screenWidth),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: CalculateSize.getResponsiveSize(18, screenWidth)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.text_exam_total_score,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: CalculateSize.getResponsiveSize(14, screenWidth),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            CalculateSize.getResponsiveSize(10, screenWidth),
                        vertical:
                            CalculateSize.getResponsiveSize(4, screenWidth)),
                    child: Text(
                      widget.examResult.overall.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            CalculateSize.getResponsiveSize(18, screenWidth),
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
