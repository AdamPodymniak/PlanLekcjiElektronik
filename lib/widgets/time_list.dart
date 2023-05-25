import 'package:flutter/material.dart';

import '/utils/theming.dart';
import '/webscrapper/scrapper.dart';

class TimeList extends StatefulWidget {
  final String day;
  final AllLessons lessons;
  const TimeList({
    required this.day,
    required this.lessons,
    super.key,
  });

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
              for (final e in widget.lessons.lessonData) _event(data: e),
              SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _event({
    required LessonData data,
  }) {
    final times = data.hour.split("-");
    final starts = [
      times[0].split(":")[0],
      times[0].split(":")[1],
    ];
    final ends = [
      times[1].split(":")[0],
      times[1].split(":")[1],
    ];

    //formatted times
    final formStart = "${int.parse(starts[0]) < 10 ? "0" : ""}${starts[0].trim()}:${starts[1]}";
    final formEnd = "${int.parse(ends[0]) < 10 ? "0" : ""}${ends[0].trim()}:${ends[1]}";
    final formattedTime = "$formStart - $formEnd";

    return Visibility(
      visible: data.day == widget.day,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Text(
                formattedTime,
                style: TextStyle(
                  color: Theming.whiteTone.withOpacity(0.6),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
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
                          data.name,
                          style: const TextStyle(
                            color: Theming.whiteTone,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              data.teacher ?? "",
                              style: const TextStyle(
                                color: Theming.whiteTone,
                              ),
                            ),
                            Text(
                              data.classroom != null ? " • sala ${data.classroom}" : "",
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
      ),
    );
  }
}
