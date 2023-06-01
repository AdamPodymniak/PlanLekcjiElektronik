import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/theming.dart';
import '../utils/constants.dart' show weekdays;
import '../webscrapper/scrapper.dart';

class LessonItem extends StatelessWidget {
  final LessonData lessonData;
  final AllLessons allData;
  final int dayIndex;
  final String endHourLessonBefore;
  final String startHourNextLesson;
  const LessonItem({
    required this.startHourNextLesson,
    required this.endHourLessonBefore,
    required this.lessonData,
    required this.allData,
    required this.dayIndex,
    super.key,
  });

  bool get _isLessonGroup => endHourLessonBefore == lessonData.hour;

  List<String> get _times => lessonData.hour.split("-");

  @override
  Widget build(BuildContext context) {
    //[0] = hour, [1] = minute
    final starts = [
      _times[0].split(":")[0],
      _times[0].split(":")[1],
    ];
    final ends = [
      _times[1].split(":")[0],
      _times[1].split(":")[1],
    ];

    //formatted times
    final formStart = "${int.parse(starts[0]) < 10 ? "0" : ""}${starts[0].trim()}:${starts[1]}";
    final formEnd = "${int.parse(ends[0]) < 10 ? "0" : ""}${ends[0].trim()}:${ends[1]}";
    final formattedTime = "$formStart - $formEnd";

    final now = DateTime.now();

    final lessonStart = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(starts[0]),
      int.parse(starts[1]),
    );

    final lessonEnd = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(ends[0]),
      int.parse(ends[1]),
    );

    final isActive = now.isAfter(lessonStart) &&
        now.isBefore(lessonEnd) &&
        lessonData.day == weekdays[now.weekday - 1];

    final nextLessonHour = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(startHourNextLesson.split("-")[0].split(":")[0]),
      int.parse(startHourNextLesson.split("-")[0].split(":")[1]),
    );

    final beforeLessonHour = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(endHourLessonBefore.split("-")[0].split(":")[0]),
      int.parse(endHourLessonBefore.split("-")[0].split(":")[1]),
    );

    final isNext = now.isAfter(beforeLessonHour) &&
        now.isBefore(nextLessonHour) &&
        lessonData.day == weekdays[now.weekday - 1];

    return Visibility(
      visible: lessonData.day == weekdays[dayIndex],
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                useRootNavigator: true,
                backgroundColor: Theming.bgColor,
                builder: (ctx) {
                  return SizedBox(
                    height: 190,
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 4),
                      child: Column(
                        children: [
                          _eventModalItem(
                            ctx,
                            type: "class",
                            caption: lessonData.className,
                            icon: Icons.calendar_month,
                          ),
                          _eventModalItem(
                            ctx,
                            type: "teacher",
                            caption: lessonData.teacher,
                            icon: Icons.person_rounded,
                          ),
                          _eventModalItem(
                            ctx,
                            type: "classroom",
                            caption: lessonData.classroom,
                            icon: Icons.meeting_room_rounded,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: !_isLessonGroup ? isActive : false,
                      child: const Text(
                        "• Teraz",
                        style: TextStyle(
                          color: Theming.greenTone,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !_isLessonGroup ? isNext : false,
                      child: const Text(
                        "• Następna",
                        style: TextStyle(
                          color: Theming.orangeTone,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      formattedTime,
                      style: TextStyle(
                        color: _isLessonGroup
                            ? Colors.transparent
                            : Theming.whiteTone.withOpacity(isActive ? 1 : 0.6),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Lekcja: ${lessonData.number}",
                      style: const TextStyle(
                        color: Theming.whiteTone,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        right: 15,
                      ),
                      decoration: BoxDecoration(
                        color: Theming.whiteTone.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 80,
                            width: 5,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? Theming.greenTone
                                  : isNext
                                      ? Theming.orangeTone
                                      : Theming.primaryColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lessonData.name,
                                style: const TextStyle(
                                  color: Theming.whiteTone,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                _bottomText(lessonData, allData.type),
                                style: const TextStyle(
                                  color: Theming.whiteTone,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _eventModalItem(
    BuildContext ctx, {
    required String type,
    String? caption,
    required IconData icon,
  }) {
    return Visibility(
      visible: caption != null,
      child: GestureDetector(
        onTap: () async {
          final data = await retrieveDataFromJSON();
          for (final e in data!) {
            if (e.title!.split(" ")[0] == caption) {
              if (ctx.mounted) {
                ctx.go(
                  type == "class"
                      ? "/"
                      : type == "teacher"
                          ? "/teacher-schedule"
                          : "/classroom-schedule",
                  extra: e,
                );
                Navigator.pop(ctx);
              }
              break;
            }
          }
        },
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                top: 10,
                bottom: 10,
                right: 10,
              ),
              decoration: BoxDecoration(
                color: Theming.primaryColor.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Theming.primaryColor,
                size: 30,
              ),
            ),
            Text(
              caption ?? "",
              style: const TextStyle(
                color: Theming.whiteTone,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _bottomText(LessonData data, String? type) {
    if (type == "teacher") {
      return "${data.className} • sala: ${data.classroom}";
    }
    if (type == "classroom") {
      return "${data.teacher} • ${data.className}";
    }
    return "${data.teacher} • sala: ${data.classroom}";
  }
}
