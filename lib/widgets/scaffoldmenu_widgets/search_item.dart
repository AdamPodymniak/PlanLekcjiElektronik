import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/webscrapper/scrapper.dart';
import '/utils/theming.dart';

class SearchItem extends StatelessWidget {
  final String searchingFor;
  final AllLessons data;
  const SearchItem({
    required this.searchingFor,
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: searchingFor == data.type,
      child: TextButton(
        onPressed: () {
          Navigator.pop(context);
          if (data.type == "class") {
            context.go("/", extra: data);
            return;
          }

          if (data.type == "teacher") {
            context.push("/teacher-schedule", extra: data);
            return;
          }

          if (data.type == "classroom") {
            context.push("/classroom-schedule", extra: data);
            return;
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(
            right: 55,
            top: 10,
            bottom: 10,
          ),
          child: Text(
            data.title!,
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
