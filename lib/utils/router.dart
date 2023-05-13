import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/scaffold_menu.dart';
import '../routes/schedule_page.dart';
import '../routes/browser_page.dart';

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
              childWidget: const SchedulePage(),
            );
          },
        ),
        GoRoute(
          path: '/browser',
          pageBuilder: (_, state) {
            return pageTransition(
              state: state,
              childWidget: const BrowserPage(),
            );
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
