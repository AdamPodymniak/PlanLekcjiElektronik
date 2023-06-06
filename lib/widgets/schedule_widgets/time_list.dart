import 'package:flutter/material.dart';

import '/webscrapper/scrapper.dart';
import 'swipeable_page.dart';

class TimeList extends StatelessWidget {
  final AllLessons lessons;
  final TabController ctrl;
  const TimeList({
    required this.lessons,
    required this.ctrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: ctrl,
      children: [
        SwipeablePage(
          day: "Poniedziałek",
          lessons: lessons,
        ),
        SwipeablePage(
          day: "Wtorek",
          lessons: lessons,
        ),
        SwipeablePage(
          day: "Środa",
          lessons: lessons,
        ),
        SwipeablePage(
          day: "Czwartek",
          lessons: lessons,
        ),
        SwipeablePage(
          day: "Piątek",
          lessons: lessons,
        ),
      ],
    );
  }
}
