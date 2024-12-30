import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../core/failure.dart';
import '../../../generated/assets.dart';
import '../../../utils/app_snack_bar.dart';
import '../../../utils/extensions/go_router_extension.dart';
import '../../../navigation/app_router.dart';
import '../home/bloc/home_bloc.dart';
import '../notifications/bloc/notifications_bloc.dart';

class HomeNavigation extends StatefulWidget {
  final Widget child;

  const HomeNavigation({super.key, required this.child});

  static const routes = [
    RoutePaths.home,
    RoutePaths.vocabulary,
    RoutePaths.notifications,
    RoutePaths.review,
    RoutePaths.settings,
  ];

  static const icons = [
    Assets.svgHome,
    Assets.svgVocabulary,
    Assets.svgNotifications,
    Assets.svgStar,
    Assets.svgSettings,
  ];

  static const labels = [
    "Grammar AI",
    "Oxford Words",
    "Reminders",
    "Review",
    "Settings",
  ];

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  @override
  Widget build(BuildContext context) {
    final homeState = context.watch<HomeBloc>().state;

    final isLoading = homeState.isLoading;

    final colorScheme = Theme.of(context).colorScheme;

    final currentRoute = GoRouter.of(context).currentRoute;
    final selectedIndex = HomeNavigation.routes.indexOf(currentRoute);
    final selectedColor = Theme.of(context).primaryColor;
    final unselectedColor = Theme.of(context).unselectedWidgetColor;

    return MultiBlocListener(
      listeners: [
        BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            _handleError(context, state.failure);
          },
        ),
      ],
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(child: widget.child),
              ],
            ),
            if (isLoading)
              Container(
                color: Colors.white.withAlpha(100),
                alignment: Alignment.center,
                child: LoadingAnimationWidget.threeArchedCircle(
                  color: colorScheme.primary,
                  size: 48,
                ),
              )
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
            HomeNavigation.labels.length,
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
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    context.read<NotificationsBloc>().add(const NotificationsEvent.requestPermissions());
  }

  void _onSelect(int value) {
    context.go(HomeNavigation.routes[value]);
  }

  _handleError(BuildContext context, Failure? failure) {
    if (failure != null) {
      AppSnackBar.showError(context, failure.message);
    }
  }
}
