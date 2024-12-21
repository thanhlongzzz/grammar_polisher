import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../generated/assets.dart';
import '../../../utils/extensions/go_router_extension.dart';
import '../../../navigation/app_router.dart';

class HomeNavigation extends StatefulWidget {
  final Widget child;

  const HomeNavigation({super.key, required this.child});

  static const routes = [
    RoutePaths.home,
    RoutePaths.notifications,
    RoutePaths.review,
    RoutePaths.settings,
  ];

  static const icons = [
    Assets.svgHome,
    Assets.svgNotifications,
    Assets.svgBook,
    Assets.svgSettings,
  ];

  static const labels = [
    "Home",
    "Notifications",
    "Review",
    "Settings",
  ];

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouter.of(context).currentRoute;
    final selectedIndex = HomeNavigation.routes.indexOf(currentRoute);
    final selectedColor = Theme.of(context).primaryColor;
    final unselectedColor = Theme.of(context).unselectedWidgetColor;

    return Scaffold(
      body: Column(
        children: [
          Expanded(child: widget.child),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        currentIndex: selectedIndex == -1 ? 0 : selectedIndex,
        selectedFontSize: 12,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        onTap: _onSelect,
        items: List.generate(
          4,
          (index) => BottomNavigationBarItem(
            icon: SvgPicture.asset(
              HomeNavigation.icons[index],
              colorFilter: ColorFilter.mode(
                index == selectedIndex ? selectedColor : unselectedColor,
                BlendMode.srcIn,
              ),
              height: 24,
            ),
            label: HomeNavigation.labels[index],
          ),
        ),
      ),
    );
  }

  void _onSelect(int value) {
    context.go(HomeNavigation.routes[value]);
  }
}
