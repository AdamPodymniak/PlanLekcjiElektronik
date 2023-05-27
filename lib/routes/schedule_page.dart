import 'package:flutter/material.dart';
import 'package:plan_lekcji/webscrapper/scrapper.dart';

import '../utils/theming.dart';
import '../widgets/weekday_row.dart';
import '../widgets/time_list.dart';

class SchedulePage extends StatefulWidget {
  final AllLessons data;
  const SchedulePage({
    required this.data,
    super.key,
  });

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  int weekdayIndex = 0;

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
              widget.data.title ?? "Wybierz klasę",
              style: const TextStyle(
                color: Theming.primaryColor,
                fontWeight: FontWeight.bold,
                backgroundColor: Theming.bgColor,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(54),
              child: Align(
                alignment: Alignment.centerLeft,
                child: WeekdayRow(
                  lessons: widget.data.lessonData,
                  onSelect: (wd) {
                    setState(() => weekdayIndex = wd);
                  },
                ),
              ),
            ),
          ),
          TimeList(
            dayIndex: weekdayIndex,
            lessons: widget.data,
          ),
        ],
      ),
    );
  }
}
