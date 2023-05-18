import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plan_lekcji/webscrapper/scrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/theming.dart';

class ScaffoldMenu extends StatefulWidget {
  final Widget child;
  const ScaffoldMenu(this.child, {super.key});

  @override
  State<ScaffoldMenu> createState() => _ScaffoldMenuState();
}

class _ScaffoldMenuState extends State<ScaffoldMenu> {
  late int selectedMenuIndex;
  String? favClass;

  List<LessonData> favClassData = [];
  List<Widget> classes = [];
  List<AllLessons>? savedLessons;

  @override
  void initState() {
    super.initState();
    selectedMenuIndex = 0;
    retrieveDataFromJSON().then((jsonVal) {
      if (jsonVal != null) {
        savedLessons = jsonVal;
        var tempClasses = <Widget>[];
        for (int i = 0; i < jsonVal.length; i++) {
          tempClasses.add(
            _classPlaceholder(
              data: jsonVal[i],
            ),
          );
          setState(() => classes = tempClasses);
        }
        return;
      }
      extractAllData().then((val) {
        savedLessons = val;
        var tempClasses = <Widget>[];
        for (int i = 0; i < val.length; i++) {
          tempClasses.add(
            _classPlaceholder(
              data: val[i],
            ),
          );
          setState(() => classes = tempClasses);
        }
      });
    });
    SharedPreferences.getInstance().then((prefs) {
      favClass = prefs.getString("favourite");
      for (final cls in savedLessons!) {
        if (cls.title == favClass) {
          favClassData = cls.lessonData;
          break;
        }
      }
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.go(
          "/",
          extra: AllLessons(
            title: favClass,
            lessonData: favClassData,
          ),
        ),
      );
    });
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        backgroundColor: Theming.primaryColor,
        child: const Icon(
          Icons.menu_rounded,
          color: Theming.whiteTone,
          size: 30,
        ),
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width / 2 + 30,
        backgroundColor: Theming.bgColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Theme(
                data: ThemeData(dividerColor: Colors.transparent),
                child: const DrawerHeader(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                    ),
                    image: DecorationImage(
                      image: AssetImage("assets/elektronik.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: SizedBox(
                    height: 100,
                    width: double.infinity,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "MENU",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theming.whiteTone.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                      _menuItem(
                        0,
                        caption:
                            "Plan lekcji ${favClass != null ? "($favClass)" : ""}",
                        icon: Icons.calendar_month_rounded,
                        route: "/",
                        extra: AllLessons(
                          title: favClass,
                          lessonData: favClassData,
                        ),
                      ),
                      _menuItem(
                        1,
                        caption: "Nauczyciele",
                        icon: Icons.people_alt_rounded,
                        route: "/teachers",
                      ),
                      _menuItem(
                        2,
                        caption: "Sale lekcyjne",
                        icon: Icons.meeting_room_rounded,
                        route: "/classrooms",
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "KLASY",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theming.whiteTone.withOpacity(0.5),
                              fontSize: 12,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              var val = await extractAllData();
                              var tempClasses = <Widget>[];
                              for (int i = 0; i < val.length; i++) {
                                tempClasses.add(
                                  _classPlaceholder(data: val[i]),
                                );
                              }
                              setState(() => classes = tempClasses);
                            },
                            icon: Icon(
                              Icons.refresh,
                              color: Theming.whiteTone.withOpacity(0.5),
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      ...classes,
                      SizedBox(
                        height: MediaQuery.of(context).viewPadding.bottom + 30,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: widget.child,
    );
  }

  Widget _menuItem(
    int index, {
    required String caption,
    required IconData icon,
    required String route,
    Object? extra,
  }) {
    bool isSelected = selectedMenuIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() => selectedMenuIndex = index);
        Navigator.of(context).pop();
        context.go(route, extra: extra);
      },
      child: AnimatedContainer(
        curve: Curves.linearToEaseOut,
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? Theming.primaryColor : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Theming.whiteTone : Theming.primaryColor,
            ),
            const SizedBox(width: 5),
            Text(
              caption,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Theming.whiteTone : Theming.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _classPlaceholder({
    required AllLessons data,
  }) {
    return Visibility(
      visible: data.type == "class",
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              context.go(
                '/',
                extra: data,
              );
              setState(() => selectedMenuIndex = 0);
            },
            child: Text(
              data.title!,
              style: const TextStyle(
                color: Theming.whiteTone,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString("favourite", data.title!);

              for (final cls in savedLessons!) {
                if (cls.title == data.title) {
                  favClassData = cls.lessonData;
                  break;
                }
              }
              setState(() => favClass = data.title!);
            },
            icon: const Icon(
              Icons.star_rounded,
              color: Colors.yellow,
            ),
          ),
        ],
      ),
    );
  }
}
