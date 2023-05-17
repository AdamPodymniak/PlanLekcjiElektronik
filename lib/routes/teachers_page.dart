import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../webscrapper/scrapper.dart';
import '../utils/theming.dart';

class TeachersPage extends StatefulWidget {
  const TeachersPage({super.key});

  @override
  State<TeachersPage> createState() => _TeachersPageState();
}

class _TeachersPageState extends State<TeachersPage> {
  List<Widget> teachers = [];

  @override
  void initState() {
    super.initState();
    retrieveDataFromJSON().then((jsonVal) {
      if (jsonVal != null) {
        var tempTeachers = <Widget>[];
        for (int i = 0; i < jsonVal.length; i++) {
          tempTeachers.add(
            _teacherPlaceholder(data: jsonVal[i]),
          );
        }
        setState(() => teachers = tempTeachers);
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theming.bgColor,
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            backgroundColor: Theming.bgColor,
            surfaceTintColor: Theming.bgColor,
            shadowColor: Theming.bgColor,
            pinned: true,
            centerTitle: true,
            expandedHeight: 60,
            title: Text(
              "Nauczyciele",
              style: TextStyle(
                color: Theming.primaryColor,
                fontWeight: FontWeight.bold,
                backgroundColor: Theming.bgColor,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewPadding.bottom + 30,
              ),
              child: Column(children: teachers),
            ),
          ),
        ],
      ),
    );
  }

  Widget _teacherPlaceholder({required AllLessons data}) {
    return Visibility(
      visible: data.type == "teacher",
      child: GestureDetector(
        onTap: () => context.push(
          "/teacher-schedule",
          extra: data,
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                top: 10,
                bottom: 10,
                right: 10,
              ),
              decoration: BoxDecoration(
                color: Theming.primaryColor.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Theming.primaryColor,
                size: 30,
              ),
            ),
            Text(
              data.title!,
              style: const TextStyle(
                color: Theming.whiteTone,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
