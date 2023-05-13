import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/theming.dart';

class ScaffoldMenu extends StatefulWidget {
  final Widget child;
  const ScaffoldMenu(this.child, {super.key});

  @override
  State<ScaffoldMenu> createState() => _ScaffoldMenuState();
}

class _ScaffoldMenuState extends State<ScaffoldMenu> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
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
        child: Column(
          children: [
            Theme(
              data: ThemeData(dividerColor: Colors.transparent),
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                  ),
                  image: DecorationImage(
                    image: AssetImage("assets/elektronik.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: const BoxDecoration(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
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
                      caption: "Wyszukiwarka",
                      icon: Icons.search_rounded,
                      route: "/browser",
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "KLASY",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theming.whiteTone.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() => selectedIndex = index);
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
}
