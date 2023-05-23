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
  late int weekdayIndex;
  List<String> weekdays = [
    "Poniedziałek",
    "Wtorek",
    "Środa",
    "Czwartek",
    "Piątek",
  ];

  @override
  void initState() {
    super.initState();
    weekdayIndex = 0;
  }

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
              "${widget.data.title}",
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
            day: weekdays[weekdayIndex],
            lessons: widget.data,
          ),
        ],
      ),
    );
  }
}
