import 'package:flutter/material.dart';

import '../webscrapper/scrapper.dart';
import '/utils/theming.dart';

class WeekdayRow extends StatelessWidget {
  final List<LessonData> lessons;
  final TabController ctrl;
  const WeekdayRow({
    required this.lessons,
    required this.ctrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: TabBar(
          isScrollable: true,
          controller: ctrl,
          indicatorColor: Theming.primaryColor,
          dividerColor: Theming.bgColor,
          splashFactory: NoSplash.splashFactory,
          tabs: [
            _weekdayBox("Poniedziałek"),
            _weekdayBox("Wtorek"),
            _weekdayBox("Środa"),
            _weekdayBox("Czwartek"),
            _weekdayBox("Piątek"),
          ],
        ),
      ),
    );
  }

  ///[weekdayNumber] must be 1 - 5 (monday - friday)
  Widget _weekdayBox(String caption) {
    bool hasLessons = false;
    for (final i in lessons) {
      if (i.day == caption) {
        hasLessons = true;
      }
    }

    return Visibility(
      visible: hasLessons,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(15),
        child: Text(
          caption.replaceRange(3, null, "."),
          style: const TextStyle(
            color: Theming.whiteTone,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
