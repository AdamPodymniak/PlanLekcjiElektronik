import 'package:flutter/material.dart';

import '../utils/theming.dart';
import '../widgets/browserpage/searchbar.dart';

class BrowserPage extends StatelessWidget {
  const BrowserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theming.bgColor,
      body: Stack(
        children: [
          Column(
            children: const [
              SizedBox(height: 150),
            ],
          ),
          SearchBar(
            onFinish: (text) {},
          ),
        ],
      ),
    );
  }
}
