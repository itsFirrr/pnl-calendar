import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'features/calendar/calendar_screen.dart';
import 'features/day_detail/day_detail_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/statistics/statistics_screen.dart';
import 'features/trade_detail/trade_detail_screen.dart';

final _router = GoRouter(
  initialLocation: '/calendar',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          HomeShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/calendar',
            builder: (context, state) => const CalendarScreen(),
            routes: [
              GoRoute(
                path: 'day/:date',
                builder: (context, state) => DayDetailScreen(
                    date: DateTime.parse(state.pathParameters['date']!)),
              ),
              // 'trade/new' harus di atas 'trade/:id' supaya tidak tertangkap
              // sebagai id.
              GoRoute(
                path: 'trade/new',
                builder: (context, state) {
                  final date = state.uri.queryParameters['date'];
                  return TradeDetailScreen(
                      initialDate: date == null ? null : DateTime.parse(date));
                },
              ),
              GoRoute(
                path: 'trade/:id',
                builder: (context, state) => TradeDetailScreen(
                    tradeId: int.parse(state.pathParameters['id']!)),
              ),
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/statistics',
            builder: (context, state) => const StatisticsScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ]),
      ],
    ),
  ],
);

class KalenderPnlApp extends StatelessWidget {
  const KalenderPnlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Kalender PNL',
      theme: AppTheme.light,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        // Tap tab yang sedang aktif kembali ke root tab tersebut.
        onDestinationSelected: (index) => navigationShell.goBranch(index,
            initialLocation: index == navigationShell.currentIndex),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined),
              selectedIcon: Icon(Icons.calendar_month),
              label: 'Kalender'),
          NavigationDestination(
              icon: Icon(Icons.insights_outlined),
              selectedIcon: Icon(Icons.insights),
              label: 'Statistik'),
          NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Pengaturan'),
        ],
      ),
    );
  }
}
