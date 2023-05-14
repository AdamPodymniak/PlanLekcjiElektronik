import 'package:flutter/material.dart';

import '/utils/theming.dart';
import '/webscrapper/scrapper.dart';

class TimeList extends StatefulWidget {
  final List<LessonData> lessons;
  const TimeList(this.lessons, {super.key});

  @override
  State<TimeList> createState() => _TimeListState();
}

class _TimeListState extends State<TimeList> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final e in widget.lessons)
                _event(
                  time: e.hour,
                  lesson: e.name,
                  teacher: e.teacher!,
                  roomNumber: e.classroom!,
                ),
              SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _event({
    required String time,
    required String lesson,
    required String teacher,
    required String roomNumber,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Text(
              time,
              style: TextStyle(
                color: Theming.whiteTone.withOpacity(0.3),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 15),
            Container(
              padding: const EdgeInsets.only(
                right: 15,
              ),
              decoration: BoxDecoration(
                color: Theming.whiteTone.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Container(
                    height: 80,
                    width: 5,
                    decoration: const BoxDecoration(
                      color: Theming.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson,
                        style: const TextStyle(
                          color: Theming.whiteTone,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            teacher,
                            style: const TextStyle(
                              color: Theming.whiteTone,
                            ),
                          ),
                          Text(
                            " • sala $roomNumber",
                            style: const TextStyle(
                              color: Theming.whiteTone,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}
