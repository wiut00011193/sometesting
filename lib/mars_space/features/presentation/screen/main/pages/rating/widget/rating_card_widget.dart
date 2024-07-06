import 'package:flutter/material.dart';
import 'package:mars_it_app/mars_space/core/calculation/calculate_size.dart';
import 'package:mars_it_app/mars_space/core/theme/colors.dart';
import 'package:mars_it_app/mars_space/core/utils/constants.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_ratings_response_entity.dart'
    as get_ratings_response_entity;

class RatingCard extends StatefulWidget {
  final get_ratings_response_entity.Student studentEntity;

  const RatingCard({
    super.key,
    required this.studentEntity,
  });

  @override
  State<RatingCard> createState() => _RatingCardState();
}

class _RatingCardState extends State<RatingCard> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final groupEntity = widget.studentEntity.groups!
        .firstWhere((student) => student.status == 5,
            orElse: () => get_ratings_response_entity.Group(
                  id: null,
                  name: 'NO GROUP',
                  status: null,
                  course: null,
                  teacher: 'NO TEACHER',
                  dateStarted: null,
                  dateFinished: null,
                  lessonStartTime: null,
                ));
    final rankLevel = widget.studentEntity.rank!.task!.level;

    return SizedBox(
      height: CalculateSize.getResponsiveSize(66, screenWidth),
      child: Material(
        elevation: 2,
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: EdgeInsets.all(CalculateSize.getResponsiveSize(12, screenWidth)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: CalculateSize.getResponsiveSize(42, screenWidth),
                    height: CalculateSize.getResponsiveSize(42, screenWidth),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: widget.studentEntity.avatar != null && widget.studentEntity.avatar!.isNotEmpty ? Image.network(EndPoints.media_base_url +
                          widget.studentEntity.avatar!) : null,
                    ),
                  ),
                  SizedBox(width: CalculateSize.getResponsiveSize(10, screenWidth)),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: CalculateSize.getResponsiveSize(190, screenWidth)),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.studentEntity.firstName} ${widget.studentEntity.lastName}',
                            style: TextStyle(
                              color: accentColor,
                              fontSize: CalculateSize.getResponsiveSize(16, screenWidth),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${groupEntity.name} | ${groupEntity.teacher}',
                            style: TextStyle(
                              color: lightGray6,
                              fontSize: CalculateSize.getResponsiveSize(12, screenWidth),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(width: CalculateSize.getResponsiveSize(6, screenWidth)),

              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.studentEntity.coins.toString(),
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: CalculateSize.getResponsiveSize(16, screenWidth),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Image.asset(
                        'assets/images/student_coin.png',
                        height: CalculateSize.getResponsiveSize(16, screenWidth),
                        width: CalculateSize.getResponsiveSize(16, screenWidth),
                      ),
                    ],
                  ),
                  if (rankLevel != null)
                    Row(
                      children: [
                        for (int i = 0; i < rankLevel; i++)
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/gold_star.png',
                                height: CalculateSize.getResponsiveSize(12, screenWidth),
                                width: CalculateSize.getResponsiveSize(12, screenWidth),
                                fit: BoxFit.scaleDown,
                              ),
                              if (i + 1 != rankLevel || rankLevel < 5)
                                const SizedBox(width: 1),
                            ],
                          ),
                        for (int i = 0; i < 5 - rankLevel; i++)
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/grey_star.png',
                                height: CalculateSize.getResponsiveSize(12, screenWidth),
                                width: CalculateSize.getResponsiveSize(12, screenWidth),
                                fit: BoxFit.scaleDown,
                              ),
                              if (i + 1 != 5 - rankLevel)
                                const SizedBox(width: 1),
                            ],
                          ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
