import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/utils/theming.dart';
import '/webscrapper/scrapper.dart';

class TimeList extends StatefulWidget {
  final int dayIndex;
  final AllLessons lessons;
  const TimeList({
    required this.dayIndex,
    required this.lessons,
    super.key,
  });

  @override
  State<TimeList> createState() => _TimeListState();
}

class _TimeListState extends State<TimeList> {
  List<String> weekdays = [
    "Poniedziałek",
    "Wtorek",
    "Środa",
    "Czwartek",
    "Piątek",
  ];

  String bottomText(LessonData data, String? type) {
    if (type == "teacher") {
      return "${data.className} • sala: ${data.classroom}";
    }
    if (type == "classroom") {
      return "${data.teacher} • ${data.className}";
    }
    return "${data.teacher} • ${data.classroom}";
  }

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

    //[0] = hour, [1] = minute
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

    final lessonStart = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      int.parse(starts[0]),
      int.parse(starts[1]),
    );

    final lessonEnd = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      int.parse(ends[0]),
      int.parse(ends[1]),
    );

    final now = DateTime.now();
    final isActive = now.isBefore(lessonEnd) && now.isAfter(lessonStart);

    return Visibility(
      visible: data.day == weekdays[widget.dayIndex],
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                useRootNavigator: true,
                backgroundColor: Theming.bgColor,
                builder: (ctx) {
                  return SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 4),
                      child: Column(
                        children: [
                          _eventModalItem(
                            ctx,
                            type: "class",
                            caption: data.className,
                            icon: Icons.calendar_month,
                          ),
                          _eventModalItem(
                            ctx,
                            type: "teacher",
                            caption: data.teacher,
                            icon: Icons.person_rounded,
                          ),
                          _eventModalItem(
                            ctx,
                            type: "classroom",
                            caption: data.classroom,
                            icon: Icons.meeting_room_rounded,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: isActive,
                      child: const Text(
                        "• Teraz",
                        style: TextStyle(
                          color: Theming.greenTone,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      formattedTime,
                      style: TextStyle(
                        color: Theming.whiteTone.withOpacity(isActive ? 1 : 0.6),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Lekcja: ${data.number}",
                      style: const TextStyle(
                        color: Theming.whiteTone,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                            decoration: BoxDecoration(
                              color: isActive ? Colors.lightGreenAccent : Theming.primaryColor,
                              borderRadius: const BorderRadius.only(
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
                              Text(
                                bottomText(data, widget.lessons.type),
                                style: const TextStyle(
                                  color: Theming.whiteTone,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _eventModalItem(
    BuildContext ctx, {
    required String type,
    String? caption,
    required IconData icon,
  }) {
    return Visibility(
      visible: caption != null,
      child: GestureDetector(
        onTap: () async {
          final data = await retrieveDataFromJSON();
          for (final e in data!) {
            if (e.title!.split(" ")[0] == caption) {
              if (mounted) {
                context.push(
                  type == "class"
                      ? "/"
                      : type == "teacher"
                          ? "/teacher-schedule"
                          : "/classroom-schedule",
                  extra: e,
                );
                Navigator.pop(ctx);
              }
              break;
            }
          }
        },
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
              child: Icon(
                icon,
                color: Theming.primaryColor,
                size: 30,
              ),
            ),
            Text(
              caption ?? "",
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
