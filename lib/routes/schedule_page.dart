import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/theming.dart';
import '../widgets/schedule_widgets/weekday_row.dart';
import '../widgets/schedule_widgets/time_list.dart';
import '../webscrapper/scrapper.dart';

class SchedulePage extends StatefulWidget {
  final AllLessons data;
  const SchedulePage({
    required this.data,
    super.key,
  });

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(
      length: 5,
      vsync: this,
      initialIndex: DateTime.now().weekday > 5 ? 0 : DateTime.now().weekday - 1,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theming.bgColor,
      body: NestedScrollView(
        headerSliverBuilder: (_, isScrolled) => [
          SliverAppBar(
            backgroundColor: Theming.bgColor,
            surfaceTintColor: Theming.bgColor,
            shadowColor: Theming.bgColor,
            pinned: true,
            centerTitle: true,
            expandedHeight: 140,
            leading: Visibility(
              visible: context.canPop(),
              child: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Theming.whiteTone,
                  size: 20,
                ),
              ),
            ),
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
                  ctrl: _tabCtrl,
                  lessons: widget.data.lessonData,
                ),
              ),
            ),
          ),
        ],
        body: TimeList(
          lessons: widget.data,
          ctrl: _tabCtrl,
        ),
      ),
    );
  }
}
