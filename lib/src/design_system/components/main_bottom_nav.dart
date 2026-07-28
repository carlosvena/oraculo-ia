import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oraculo_ia/src/app/router/app_route.dart';

/// Barra de accesos rápidos, igual en espíritu a la que tenía la versión
/// anterior de la app: Hoy / Mi curso / Practicar / Explorar / Mi progreso.
class MainBottomNav extends StatelessWidget {
  const MainBottomNav({required this.currentIndex, super.key});

  final int currentIndex;

  static const _destinations = <_NavDestination>[
    _NavDestination('Hoy', Icons.today_outlined, AppRoute.mission),
    _NavDestination('Mi curso', Icons.school_outlined, AppRoute.knowledgeMap),
    _NavDestination('Practicar', Icons.science_outlined, AppRoute.promptLab),
    _NavDestination('Explorar', Icons.explore_outlined, AppRoute.catalog),
    _NavDestination('Mi progreso', Icons.person_outline, AppRoute.progress),
  ];

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        if (index == currentIndex) return;
        context.go(_destinations[index].route);
      },
      destinations: [
        for (final destination in _destinations)
          NavigationDestination(
            icon: Icon(destination.icon),
            label: destination.label,
          ),
      ],
    );
  }
}

class _NavDestination {
  const _NavDestination(this.label, this.icon, this.route);
  final String label;
  final IconData icon;
  final String route;
}
