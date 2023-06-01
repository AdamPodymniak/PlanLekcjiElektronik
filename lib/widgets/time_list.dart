import 'package:flutter/material.dart';

import '/webscrapper/scrapper.dart';
import './lesson_item.dart';
import '../utils/constants.dart';

class TimeList extends StatelessWidget {
  final int dayIndex;
  final AllLessons lessons;
  const TimeList({
    required this.dayIndex,
    required this.lessons,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<LessonItem> lessonItems = [];
    lessonItems.clear();
    for (int i = 0; i < lessons.lessonData.length; i++) {
      lessonItems.add(
        LessonItem(
          //Used for showing next lesson
          startHourNextLesson:
              i != lessons.lessonData.length - 1 ? lessons.lessonData[i + 1].hour : "00:00",

          //Used for grouping lessons (changing visibility of displayed time)
          endHourLessonBefore: i != 0 && weekdays[dayIndex] == lessons.lessonData[i - 1].day
              ? lessons.lessonData[i - 1].hour
              : "00:00",
          lessonData: lessons.lessonData[i],
          allData: lessons,
          dayIndex: dayIndex,
        ),
      );
    }
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...lessonItems,
              SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 60),
            ],
          ),
        ),
      ),
    );
  }
}
