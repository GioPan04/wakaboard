import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/pages/profile.dart';
import 'package:flutterwaka/pages/projects.dart';
import 'package:flutterwaka/pages/summary.dart';
import 'package:lucide_icons/lucide_icons.dart';

final _currentPage = StateProvider((ref) => 0);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(_currentPage);

    return Scaffold(
      body: [
        const SummaryPage(),
        const ProjectsPage(),
        const ProfileScreen(),
      ][page],
      bottomNavigationBar: NavigationBar(
        selectedIndex: page,
        onDestinationSelected: (value) =>
            ref.read(_currentPage.notifier).state = value,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(LucideIcons.layoutDashboard),
            label: "Dashboard",
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.code),
            label: "Projects",
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.user),
            label: "Account",
          ),
        ],
      ),
    );
  }
}
