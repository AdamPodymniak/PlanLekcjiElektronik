import 'package:flutter/material.dart';

import '../utils/theming.dart';
import '../widgets/schedulepage/weekday_row.dart';
import '../widgets/schedulepage/time_list.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

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
            expandedHeight: 50,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                weekday ?? "Plan lekcji",
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
          const TimeList(),
        ],
      ),
    );
  }
}
