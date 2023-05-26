import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/theming.dart';
import '../webscrapper/scrapper.dart';
import '../widgets/weekday_row.dart';
import '../widgets/time_list.dart';

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
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Theming.whiteTone,
                size: 18,
              ),
            ),
            title: Text(
              widget.data.title!,
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
