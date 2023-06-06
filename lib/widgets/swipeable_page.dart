import 'package:flutter/material.dart';
import 'package:plan_lekcji/utils/theming.dart';

import '../webscrapper/scrapper.dart';
import '../widgets/lesson_item.dart';

class SwipeablePage extends StatelessWidget {
  final String day;
  final AllLessons lessons;
  const SwipeablePage({
    required this.lessons,
    required this.day,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: _lessonWrapper().isEmpty
          ? const Center(
              child: Text(
                "Brak lekcji",
                style: TextStyle(
                  color: Theming.whiteTone,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._lessonWrapper(),
                  SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 60),
                ],
              ),
            ),
    );
  }

  List<Widget> _lessonWrapper() {
    List<LessonItem> validLessons = [];
    for (int i = 0; i < lessons.lessonData.length; i++) {
      if (lessons.lessonData[i].day == day) {
        validLessons.add(
          LessonItem(
            startHourNextLesson:
                i != lessons.lessonData.length - 1 ? lessons.lessonData[i + 1].hour : "00:00",
            endHourLessonBefore: i != 0 && day == lessons.lessonData[i - 1].day
                ? lessons.lessonData[i - 1].hour
                : "00:00",
            lessonData: lessons.lessonData[i],
            allData: lessons,
          ),
        );
      }
    }

    return validLessons;
  }
}
