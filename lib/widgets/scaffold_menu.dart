import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../webscrapper/scrapper.dart';
import '../widgets/glass_morphism.dart';
import '../utils/theming.dart';
import '../widgets/scaffoldmenu_widgets/search_item.dart';
import '../widgets/scaffoldmenu_widgets/category_list.dart';

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

  List<AllLessons> results = [];
  List<Widget> searchItems = [];

  late String searchingFor;
  late String selectedCategory;

  late bool isRefreshing;

  @override
  void initState() {
    super.initState();
    selectedMenuIndex = 0;
    searchingFor = "class";
    selectedCategory = "KLASY";
    _searchCtrl = TextEditingController();
    isRefreshing = false;
    retrieveDataFromJSON().then((jsonVal) {
      if (jsonVal != null) {
        savedLessons = jsonVal;
        final tempItems = <AllLessons>[];
        for (int i = 0; i < jsonVal.length; i++) {
          tempItems.add(jsonVal[i]);
          setState(() => results = tempItems);
        }
        return;
      }
      isRefreshing = true;
      extractAllData().then((val) {
        savedLessons = val;
        var tempItems = <AllLessons>[];
        for (int i = 0; i < val.length; i++) {
          tempItems.add(val[i]);
          setState(() {
            results = tempItems;
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
    }

    SystemNavigator.pop(animated: true);
    return true;
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
          width: MediaQuery.of(context).size.width / 2 + 40,
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
                                      SearchItem(
                                        searchingFor: searchingFor,
                                        data: e,
                                      ),
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
                              decoration: InputDecoration(
                                isCollapsed: true,
                                hintText: "Szukaj",
                                hintStyle: const TextStyle(
                                  fontSize: 14,
                                ),
                                icon: _searchCtrl.text.isEmpty
                                    ? const Icon(
                                        Icons.search_rounded,
                                        color: Theming.primaryColor,
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() => _searchCtrl.clear());
                                        },
                                        child: const Icon(
                                          Icons.close_rounded,
                                          color: Colors.red,
                                        ),
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
                          caption: "Plan lekcji ${favClass != null ? "($favClass)" : ""}",
                          icon: Icons.calendar_month_rounded,
                          route: "/",
                          searchType: "class",
                          category: "KLASY",
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
                          searchType: "teacher",
                          category: "NAUCZYCIELE",
                        ),
                        _menuItem(
                          2,
                          caption: "Sale lekcyjne",
                          icon: Icons.meeting_room_rounded,
                          route: "/classrooms",
                          searchType: "classroom",
                          category: "SALE LEKCYJNE",
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedCategory,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theming.whiteTone.withOpacity(0.5),
                                fontSize: 12,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                setState(() => isRefreshing = true);
                                final val = await extractAllData();
                                final tempClasses = <AllLessons>[];
                                for (int i = 0; i < val.length; i++) {
                                  tempClasses.add(val[i]);
                                }
                                setState(() {
                                  results = tempClasses;
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
                                ? CategoryList(
                                    category: searchingFor,
                                    results: results,
                                    onClassClick: (className, classData) {
                                      setState(() => favClass = className);
                                      favClassData = classData;
                                    },
                                  )
                                : Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: searchItems,
                                    ),
                                  ),
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
      ),
    );
  }

  Widget _menuItem(
    int index, {
    required String caption,
    required IconData icon,
    required String route,
    required String category,
    String searchType = "class",
    Object? extra,
  }) {
    bool isSelected = selectedMenuIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMenuIndex = index;
          searchingFor = searchType;
          selectedCategory = category;
        });
        context.go(route, extra: extra);
      },
      child: AnimatedContainer(
        curve: Curves.linearToEaseOut,
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? Theming.primaryColor : Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: isSelected ? Colors.black.withOpacity(0.3) : Colors.transparent,
              blurRadius: 4,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
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
}
