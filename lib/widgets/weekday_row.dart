import 'package:flutter/material.dart';

import '../webscrapper/scrapper.dart';
import '/utils/theming.dart';

class WeekdayRow extends StatefulWidget {
  final List<LessonData> lessons;
  final Function(int) onSelect;
  const WeekdayRow({required this.lessons, required this.onSelect, super.key});

  @override
  State<WeekdayRow> createState() => _WeekdayRowState();
}

class _WeekdayRowState extends State<WeekdayRow> {
  late int selectedIndex;
  late ScrollController scrollCtrl;

  @override
  void initState() {
    super.initState();
    scrollCtrl = ScrollController();
    selectedIndex = DateTime.now().weekday > 5 ? 0 : DateTime.now().weekday - 1;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onSelect(selectedIndex);
      if (selectedIndex >= 3) {
        scrollCtrl.jumpTo(scrollCtrl.position.viewportDimension);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: ListView(
          controller: scrollCtrl,
          scrollDirection: Axis.horizontal,
          children: [
            const SizedBox(width: 15),
            _weekdayBox(0, "Poniedziałek"),
            _weekdayBox(1, "Wtorek"),
            _weekdayBox(2, "Środa"),
            _weekdayBox(3, "Czwartek"),
            _weekdayBox(4, "Piątek"),
            const SizedBox(width: 15),
          ],
        ),
      ),
    );
  }

  ///[weekdayNumber] must be 1 - 5 (monday - friday)
  Widget _weekdayBox(int index, String caption) {
    bool isSelected = selectedIndex == index;

    bool hasLessons = false;
    for (final i in widget.lessons) {
      if (i.day == caption) {
        hasLessons = true;
      }
    }

    return Visibility(
      visible: hasLessons,
      child: GestureDetector(
        onTap: () {
          setState(() => selectedIndex = index);
          widget.onSelect(selectedIndex);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.linearToEaseOut,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(right: 20),
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 15,
          ),
          decoration: BoxDecoration(
            color: isSelected ? Theming.primaryColor : Theming.whiteTone.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            caption.replaceRange(3, null, "."),
            style: const TextStyle(
              color: Theming.whiteTone,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
