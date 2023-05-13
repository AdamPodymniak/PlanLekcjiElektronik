import 'package:flutter/material.dart';
import 'package:plan_lekcji/utils/theming.dart';

class TimeList extends StatelessWidget {
  const TimeList({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _event(
                context,
                time: "7:10 - 7:55",
                lesson: "J. polski",
                teacher: "Zbysio Matysia",
                roomNumber: "107",
              ),
              _event(
                context,
                time: "8:00 - 8:45",
                lesson: "J. polski",
                teacher: "oke",
                roomNumber: "107",
              ),
              _event(
                context,
                time: "8:55 - 9:40",
                lesson: "J. polski",
                teacher: "oke",
                roomNumber: "107",
              ),
              _event(
                context,
                time: "9:50 - 10:35",
                lesson: "J. polski",
                teacher: "oke",
                roomNumber: "107",
              ),
              _event(
                context,
                time: "10:45 - 11:30",
                lesson: "J. polski",
                teacher: "oke",
                roomNumber: "107",
              ),
              _event(
                context,
                time: "11:40 - 12:25",
                lesson: "J. polski",
                teacher: "oke",
                roomNumber: "107",
              ),
              SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _event(
    BuildContext ctx, {
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
