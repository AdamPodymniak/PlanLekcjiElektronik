import 'package:flutter/material.dart';
import 'package:plan_lekcji/webscrapper/scrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  int weekdayIndex = 0;
  List<String> weekdays = [
    "Poniedziałek",
    "Wtorek",
    "Środa",
    "Czwartek",
    "Piątek",
  ];

  String? favClass;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      favClass = prefs.getString("favourite");
    });
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
