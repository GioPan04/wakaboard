import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/pages/profile.dart';
import 'package:flutterwaka/pages/projects.dart';
import 'package:flutterwaka/pages/summary.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutterwaka/extensions/datetime.dart';

final _currentPage = StateProvider((ref) => 0);

final format = DateFormat('dd/MM/yyyy');

class HomePage extends ConsumerWidget {
  static const List<String> _titles = ['This week', 'Projects', 'Profile'];

  const HomePage({super.key});

  Future<void> _selectRange(BuildContext context, WidgetRef ref) async {
    final currentRange = ref.read(summaryRangeProvider);
    final updatedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.fromMillisecondsSinceEpoch(0),
      lastDate: DateTime.now(),
      initialDateRange: currentRange,
    );

    ref.read(summaryRangeProvider.notifier).state =
        updatedRange ?? currentRange;
  }

  bool _thisWeek(DateTimeRange range) =>
      range.end.isSameDay(DateTime.now()) &&
      range.start.isSameDay(range.end.subtract(const Duration(days: 6)));

  String _title(int page, DateTimeRange range) {
    if (page != 0) return _titles[page];
    if (_thisWeek(range)) {
      return "Last 7 days";
    }
    if (range.start.isSameDay(range.end)) {
      return format.format(range.start);
    }
    return "${format.format(range.start)} - ${format.format(range.end)}";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(_currentPage);
    final range = ref.watch(summaryRangeProvider);

    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(LucideIcons.gitCommit),
                title: const Text('Timeline'),
                onTap: () => context.push('/timeline'),
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(_title(page, range)),
        actions: [
          if (page == 0) ...[
            if (!_thisWeek(range))
              IconButton(
                onPressed: () => ref.invalidate(summaryRangeProvider),
                icon: const Icon(LucideIcons.x),
              ),
          ]
        ],
      ),
      body: [
        const SummaryPage(),
        const ProjectsPage(),
        const ProfileScreen(),
      ][page],
      floatingActionButton: page != 0
          ? null
          : FloatingActionButton.large(
              tooltip: "Select a date range",
              onPressed: () => _selectRange(context, ref),
              child: const Icon(LucideIcons.calendar),
            ),
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
