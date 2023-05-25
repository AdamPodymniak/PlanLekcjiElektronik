import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

import '/utils/theming.dart';
import '/webscrapper/scrapper.dart';

class CategoryItem extends StatelessWidget {
  final String? favClass;
  final String searchingFor;
  final List<AllLessons>? savedLessons;
  final List<LessonData> favClassData;
  final AllLessons data;

  ///[favClass], [favClassData],
  final Function(String?, List<LessonData>) onClick;

  const CategoryItem({
    required this.favClass,
    required this.searchingFor,
    required this.savedLessons,
    required this.favClassData,
    required this.data,
    required this.onClick,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: data.type == searchingFor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(
                '/',
                extra: data,
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(
                right: 55,
                top: 10,
                bottom: 10,
              ),
              child: Text(
                data.title![data.title!.length - 1] == "."
                    ? data.title!.replaceRange(
                        data.title!.length - 1,
                        null,
                        "",
                      )
                    : data.title!,
                style: const TextStyle(
                  color: Theming.whiteTone,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString("favourite", data.title!);

              for (final cls in savedLessons!) {
                if (cls.title == data.title) {
                  onClick(
                    data.title,
                    cls.lessonData,
                  );
                  break;
                }
              }
            },
            icon: Icon(
              data.title == favClass
                  ? Icons.star_rounded
                  : Icons.star_border_rounded,
              color: data.title == favClass
                  ? Colors.yellow
                  : Theming.whiteTone.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}
