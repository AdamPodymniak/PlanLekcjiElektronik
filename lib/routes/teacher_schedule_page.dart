import 'package:flutter/material.dart';

import '../utils/theming.dart';
import '../webscrapper/scrapper.dart';
import '../widgets/schedulepage/weekday_row.dart';

class TeacherSchedulePage extends StatefulWidget {
  final AllLessons data;
  const TeacherSchedulePage({
    required this.data,
    super.key,
  });

  @override
  State<TeacherSchedulePage> createState() => _TeacherSchedulePageState();
}

class _TeacherSchedulePageState extends State<TeacherSchedulePage> {
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
        ],
      ),
    );
  }
}
