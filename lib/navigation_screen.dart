import 'package:flutter/material.dart';
import 'home_tab.dart';
import 'wallpaper_tab.dart';
import 'clips_tab.dart';
import 'profile_tab.dart';
import 'app_localizations.dart';
import 'audio_helper.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Play authentic temple bell chime on launch if enabled
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AudioHelper.playTempleBell();
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.currentLanguage,
      builder: (context, currentLang, _) {
        final List<Widget> tabs = [
          HomeTab(onTabSelected: _onTabSelected),
          const WallpaperTab(),
          const ClipsTab(),
          const ProfileTab(),
        ];

        return Scaffold(
          body: tabs[_currentIndex],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home),
                label: AppLanguage.tr('nav_home'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.wallpaper_outlined),
                selectedIcon: const Icon(Icons.wallpaper),
                label: AppLanguage.tr('nav_wallpapers'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.play_circle_outline),
                selectedIcon: const Icon(Icons.play_circle),
                label: AppLanguage.tr('nav_clips'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.person_outline),
                selectedIcon: const Icon(Icons.person),
                label: AppLanguage.tr('nav_profile'),
              ),
            ],
          ),
        );
      },
    );
  }
}
