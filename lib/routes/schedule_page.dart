import 'package:flutter/material.dart';
import 'package:plan_lekcji/webscrapper/scrapper.dart';

import '../utils/theming.dart';
import '../widgets/schedulepage/weekday_row.dart';
import '../widgets/schedulepage/time_list.dart';

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
  String? weekday;

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
            expandedHeight: 110,
            title: Text(
              weekday != null
                  ? weekday!
                  : DateTime.now().weekday > 5
                      ? weekdays[0]
                      : weekdays[DateTime.now().weekday - 1],
              style: const TextStyle(
                color: Theming.primaryColor,
                fontWeight: FontWeight.bold,
                backgroundColor: Theming.bgColor,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                widget.data.title!,
                style: const TextStyle(
                  color: Theming.whiteTone,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          WeekdayRow(
            onSelect: (wd) {
              setState(() => weekday = wd);
            },
          ),
          TimeList(widget.data.lessonData),
        ],
      ),
    );
  }
}
