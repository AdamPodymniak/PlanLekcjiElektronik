import 'package:flutter/material.dart';

import '/utils/theming.dart';

class WeekdayRow extends StatefulWidget {
  final Function(int) onSelect;
  const WeekdayRow({required this.onSelect, super.key});

  @override
  State<WeekdayRow> createState() => _WeekdayRowState();
}

class _WeekdayRowState extends State<WeekdayRow> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
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

    return GestureDetector(
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
    );
  }
}
