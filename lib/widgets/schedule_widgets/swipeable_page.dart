import 'package:flutter/material.dart';

import '/webscrapper/scrapper.dart';
import 'lesson_item.dart';
import '/utils/theming.dart';

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
                  fontSize: 20,
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
            //Used for showing next lesson
            startHourNextLesson:
                i != lessons.lessonData.length - 1 ? lessons.lessonData[i + 1].hour : "00:00-00:01",

            //Used for grouping lessons (changing visibility of displayed time)
            endHourLessonBefore: i != 0 && day == lessons.lessonData[i - 1].day
                ? lessons.lessonData[i - 1].hour
                : "00:00-00:01",
            lessonData: lessons.lessonData[i],
            allData: lessons,
          ),
        );
      }
    }

    return validLessons;
  }
}
