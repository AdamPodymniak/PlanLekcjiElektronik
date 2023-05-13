import 'package:flutter/material.dart';

import '../utils/theming.dart';

class BrowserPage extends StatelessWidget {
  const BrowserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Theming.bgColor,
    );
  }
}
