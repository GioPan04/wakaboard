import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/pages/profile.dart';
import 'package:flutterwaka/pages/projects.dart';
import 'package:flutterwaka/pages/summary.dart';
import 'package:flutterwaka/widgets/cancellable_fab.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutterwaka/extensions/datetime.dart';

final _currentPage = StateProvider((ref) => 0);
final _showFab = StateProvider((ref) => true);

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

  bool _onScroll(UserScrollNotification n, WidgetRef ref, bool current) {
    final res = switch (n.direction) {
      ScrollDirection.forward => true,
      ScrollDirection.reverse => false,
      ScrollDirection.idle => current
    };

    ref.read(_showFab.notifier).state = res;

    return false;
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
    final showFab = ref.watch(_showFab);

    return Scaffold(
      appBar: AppBar(
        title: Text(_title(page, range)),
      ),
      body: [
        NotificationListener<UserScrollNotification>(
          onNotification: (n) => _onScroll(n, ref, showFab),
          child: const SummaryPage(),
        ),
        const ProjectsPage(),
        const ProfileScreen(),
      ][page],
      floatingActionButton: page != 0
          ? null
          : CancellableFAB(
              onPrimaryTapped: () => _selectRange(context, ref),
              onCancelTapped: () => ref.invalidate(summaryRangeProvider),
              primary: const Icon(LucideIcons.calendar),
              cancel: const Icon(LucideIcons.x),
              open: !_thisWeek(range) && showFab,
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
