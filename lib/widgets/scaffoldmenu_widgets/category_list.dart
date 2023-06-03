import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/webscrapper/scrapper.dart';
import '/utils/theming.dart';

class CategoryList extends StatefulWidget {
  final String category;
  final List<AllLessons> results;
  final Function(String?, List<LessonData>) onClassClick;
  const CategoryList({
    required this.category,
    required this.results,
    required this.onClassClick,
    super.key,
  });

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  String? favClass;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SharedPreferences.getInstance().then((prefs) {
        setState(() => favClass = prefs.getString("favourite"));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final e in widget.results) wrapper(e),
        ],
      ),
    );
  }

  Widget wrapper(AllLessons data) {
    bool isFavourite = data.title == favClass;

    return Visibility(
      visible: data.type == widget.category,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (data.type == "class") {
                context.go("/", extra: data);
                return;
              }

              context.push("/", extra: data);
            },
            child: Text(
              data.title!.split(" ")[0][data.title!.split(" ")[0].length - 1] == "."
                  ? data.title!.replaceRange(
                      data.title!.split(" ")[0].length - 1,
                      null,
                      "",
                    )
                  : data.title!.split(" ")[0],
              style: const TextStyle(
                color: Theming.whiteTone,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Visibility(
            visible: data.type == "class",
            child: IconButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString("favourite", data.title!);
                setState(() => favClass = data.title);
                widget.onClassClick(
                  data.title,
                  data.lessonData,
                );
              },
              icon: Icon(
                isFavourite ? Icons.star_rounded : Icons.star_border_rounded,
                color: isFavourite ? Colors.yellow : Theming.whiteTone.withOpacity(0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
