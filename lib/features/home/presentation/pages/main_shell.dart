import 'package:flutter/material.dart';
import '../../../../shared/widgets/bottom_nav.dart';
import 'home_feed_page.dart';
import '../../../search/presentation/pages/search_page.dart';
import '../../../sell/presentation/pages/sell_page.dart';
import '../../../inbox/presentation/pages/inbox_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';

/// Main Shell with Bottom Navigation
/// Equivalent to React's Index.tsx
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeFeedPage(),
    SearchPage(),
    SellPage(),
    InboxPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
