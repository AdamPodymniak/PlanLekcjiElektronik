import 'package:flutter/material.dart';

import '../utils/theming.dart';
import '../webscrapper/scrapper.dart';
import '../widgets/schedulepage/weekday_row.dart';
import '../widgets/schedulepage/time_list.dart';

class ClassroomSchedulePage extends StatefulWidget {
  final AllLessons data;
  const ClassroomSchedulePage({
    required this.data,
    super.key,
  });

  @override
  State<ClassroomSchedulePage> createState() => _ClassroomSchedulePageState();
}

class _ClassroomSchedulePageState extends State<ClassroomSchedulePage> {
  int weekdayIndex = 0;
  List<String> weekdays = [
    "Poniedziałek",
    "Wtorek",
    "Środa",
    "Czwartek",
    "Piątek",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theming.bgColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theming.bgColor,
            surfaceTintColor: Theming.bgColor,
            shadowColor: Theming.bgColor,
            pinned: true,
            centerTitle: true,
            expandedHeight: 140,
            title: Text(
              widget.data.title!,
              style: const TextStyle(
                color: Theming.primaryColor,
                fontWeight: FontWeight.bold,
                backgroundColor: Theming.bgColor,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: WeekdayRow(
                onSelect: (wd) {
                  setState(() => weekdayIndex = wd);
                },
              ),
            ),
          ),
          TimeList(
            day: weekdays[DateTime.now().weekday > 5 ? DateTime.now().weekday - 1 : weekdayIndex],
            lessons: widget.data,
          ),
        ],
      ),
    );
  }
}
