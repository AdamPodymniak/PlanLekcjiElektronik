import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:plan_lekcji/webscrapper/scrapper.dart';
import 'package:plan_lekcji/widgets/glass_morphism.dart';
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
  late TextEditingController _searchCtrl;

  String? favClass;
  List<LessonData> favClassData = [];
  List<AllLessons>? savedLessons;

  List<Widget> classes = [];
  List<Widget> searchItems = [];

  late String searchingFor;

  late bool isRefreshing;

  @override
  void initState() {
    super.initState();
    selectedMenuIndex = 0;
    searchingFor = "class";
    _searchCtrl = TextEditingController();
    isRefreshing = false;
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
      isRefreshing = true;
      extractAllData().then((val) {
        savedLessons = val;
        var tempClasses = <Widget>[];
        for (int i = 0; i < val.length; i++) {
          tempClasses.add(
            _classPlaceholder(
              data: val[i],
            ),
          );
          setState(() {
            classes = tempClasses;
            isRefreshing = false;
          });
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

  @override
  void dispose() {
    super.dispose();
    _searchCtrl.dispose();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime backButtonPressedTime = DateTime.now();

  Future<bool> _doubleTapBack(BuildContext context) async {
    final diff = DateTime.now().difference(backButtonPressedTime);
    backButtonPressedTime = DateTime.now();

    if (diff >= const Duration(seconds: 2)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          dismissDirection: DismissDirection.horizontal,
          elevation: 0,
          content: GlassMorphism(
            blur: 20,
            opacity: 0.1,
            borderRadius: BorderRadius.circular(30),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                "Kliknij jeszcze raz, aby wyjść",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      );
      return false;
    } else {
      SystemNavigator.pop(animated: true);
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _doubleTapBack(context),
      child: Scaffold(
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
                        Container(
                          height: 40,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: Theming.whiteTone,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: TextField(
                              onChanged: (val) {
                                searchItems = [];
                                final tempSearches = <Widget>[];
                                for (final e in savedLessons!) {
                                  if (e.title!.contains(val.toUpperCase())) {
                                    tempSearches.add(
                                      _searchItem(data: e),
                                    );
                                  }
                                }
                                if (val.isEmpty) {
                                  setState(() => searchItems = []);
                                  return;
                                }
                                setState(() => searchItems = tempSearches);
                              },
                              controller: _searchCtrl,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                              cursorColor: Theming.primaryColor,
                              cursorHeight: 20,
                              decoration: const InputDecoration(
                                isCollapsed: true,
                                hintText: "Szukaj",
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                ),
                                icon: Icon(
                                  Icons.search_rounded,
                                  color: Theming.primaryColor,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
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
                          searchType: "class",
                        ),
                        _menuItem(
                          1,
                          caption: "Nauczyciele",
                          icon: Icons.people_alt_rounded,
                          route: "/teachers",
                          searchType: "teacher",
                        ),
                        _menuItem(
                          2,
                          caption: "Sale lekcyjne",
                          icon: Icons.meeting_room_rounded,
                          route: "/classrooms",
                          searchType: "classroom",
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
                                setState(() => isRefreshing = true);
                                var val = await extractAllData();
                                var tempClasses = <Widget>[];
                                for (int i = 0; i < val.length; i++) {
                                  tempClasses.add(
                                    _classPlaceholder(data: val[i]),
                                  );
                                }
                                setState(() {
                                  classes = tempClasses;
                                  isRefreshing = false;
                                });
                              },
                              icon: Icon(
                                Icons.refresh,
                                color: Theming.whiteTone.withOpacity(0.5),
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        isRefreshing
                            ? const Padding(
                                padding: EdgeInsets.only(top: 30),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Theming.primaryColor,
                                  ),
                                ),
                              )
                            : searchItems.isEmpty
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: classes,
                                    ),
                                  )
                                : Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: searchItems,
                                    ),
                                  ),
                        SizedBox(
                          height:
                              MediaQuery.of(context).viewPadding.bottom + 30,
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
      ),
    );
  }

  Widget _menuItem(
    int index, {
    required String caption,
    required IconData icon,
    required String route,
    String searchType = "class",
    Object? extra,
  }) {
    bool isSelected = selectedMenuIndex == index;

    return GestureDetector(
      onTap: () {
        searchingFor = searchType;
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
    bool isFavourite = data.title! == favClass;

    return Visibility(
      visible: data.type == "class",
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
              setState(() => selectedMenuIndex = 0);
            },
            child: Padding(
              padding: const EdgeInsets.only(
                right: 55,
                top: 10,
                bottom: 10,
              ),
              child: Text(
                data.title![data.title!.length - 1] == "."
                    ? data.title!.replaceRange(data.title!.length - 1, null, "")
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
                  favClassData = cls.lessonData;
                  break;
                }
              }
              setState(() => favClass = data.title!);
            },
            icon: Icon(
              isFavourite ? Icons.star_rounded : Icons.star_border_rounded,
              color: isFavourite
                  ? Colors.yellow
                  : Theming.whiteTone.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchItem({required AllLessons data}) {
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
