import 'package:flutter/material.dart';
import 'package:plan_lekcji/utils/theming.dart';

class SearchBar extends StatelessWidget {
  final Function(TextEditingController) onFinish;
  const SearchBar({
    required this.onFinish,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Theming.bgColor,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
          top: 25,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Theming.whiteTone.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.delete_outline,
                color: Theming.primaryColor,
                size: 28,
              ),
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width - 100,
              padding: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Theming.whiteTone,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const TextField(
                cursorColor: Theming.primaryColor,
                decoration: InputDecoration(
                  hintText: "Wyszukaj nauczyciela lub salę",
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Theming.primaryColor,
                    size: 28,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
