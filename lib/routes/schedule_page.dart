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
            expandedHeight: 125,
            title: Text(
              weekday ?? "Brak",
              style: const TextStyle(
                color: Theming.primaryColor,
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
