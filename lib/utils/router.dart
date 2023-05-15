import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../webscrapper/scrapper.dart';
import '../widgets/scaffold_menu.dart';
import '../routes/schedule_page.dart';
import '../routes/teachers_page.dart';
import '../routes/classrooms_page.dart';

GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (_, __, child) => ScaffoldMenu(child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (_, state) {
            return pageTransition(
              state: state,
              childWidget: SchedulePage(
                data: state.extra as AllLessons? ??
                    AllLessons(
                      title: "Plan lekcji",
                      lessonData: [],
                    ),
              ),
            );
          },
        ),
        GoRoute(
          path: '/teachers',
          pageBuilder: (_, state) {
            return pageTransition(
              state: state,
              childWidget: const TeachersPage(),
            );
          },
        ),
        GoRoute(
          path: '/classrooms',
          pageBuilder: (_, state) {
            return pageTransition(state: state, childWidget: const ClassroomsPage());
          },
        ),
      ],
    ),
  ],
);

CustomTransitionPage pageTransition({
  required GoRouterState state,
  required Widget childWidget,
}) {
  const Duration animDuration = Duration(milliseconds: 100);

  return CustomTransitionPage(
    key: state.pageKey,
    child: childWidget,
    transitionDuration: animDuration,
    reverseTransitionDuration: animDuration,
    transitionsBuilder: (_, animation, __, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}
