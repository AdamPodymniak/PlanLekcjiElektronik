import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plan_lekcji/webscrapper/scrapper.dart';

import '../utils/theming.dart';

class ScaffoldMenu extends StatefulWidget {
  final Widget child;
  const ScaffoldMenu(this.child, {super.key});

  @override
  State<ScaffoldMenu> createState() => _ScaffoldMenuState();
}

class _ScaffoldMenuState extends State<ScaffoldMenu> {
  late int selectedMenuIndex;
  int? selectedClassIndex;

  List<Widget> classes = [];

  @override
  void initState() {
    super.initState();
    selectedMenuIndex = 0;
    retrieveDataFromJSON().then((jsonVal) {
      if (jsonVal != null) {
        var tempClasses = <Widget>[];
        for (int i = 0; i < jsonVal.length; i++) {
          tempClasses.add(
            _classPlaceholder(
              i,
              data: jsonVal[i],
            ),
          );
          setState(() => classes = tempClasses);
        }
        return;
      }
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
                      Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width - 100,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Theming.whiteTone,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const TextField(
                          cursorColor: Theming.primaryColor,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.only(
                              bottom: 3,
                              right: 5,
                            ),
                            hintText: "Nauczyciel / Sala",
                            hintStyle: TextStyle(fontSize: 15),
                            prefixIcon: Padding(
                              padding: EdgeInsets.zero,
                              child: Icon(
                                Icons.search_rounded,
                                color: Theming.primaryColor,
                                size: 24,
                              ),
                            ),
                            border: InputBorder.none,
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
                        caption: "Plan lekcji",
                        icon: Icons.calendar_month_outlined,
                        route: "/",
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
                                  _classPlaceholder(
                                    i,
                                    data: val[i],
                                  ),
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
                      SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 30),
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
  }) {
    bool isSelected = selectedMenuIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() => selectedMenuIndex = index);
        Navigator.of(context).pop();
        context.go(route);
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

  Widget _classPlaceholder(int index, {required AllLessons data}) {
    bool isSelected = selectedClassIndex == index;

    return Visibility(
      visible: data.type == "class",
      child: Row(
        children: [
          Visibility(
            visible: isSelected,
            child: Container(
              height: 5,
              width: 5,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.go(
                '/',
                extra: data,
              );

              //TODO fix it
              setState(() {
                selectedClassIndex = index;
                selectedMenuIndex = 0;
              });
            },
            child: Text(
              data.title!,
              style: TextStyle(
                color: isSelected ? Theming.primaryColor : Theming.whiteTone,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
