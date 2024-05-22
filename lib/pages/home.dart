import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/pages/projects.dart';
import 'package:flutterwaka/pages/summary.dart';
import 'package:flutterwaka/pages/timeline.dart';
import 'package:flutterwaka/providers/localization.dart';
import 'package:flutterwaka/providers/logged_user.dart';
import 'package:flutterwaka/providers/settings/dashboard.dart';
import 'package:flutterwaka/widgets/avatar.dart';
import 'package:flutterwaka/widgets/cancellable_fab.dart';
import 'package:flutterwaka/widgets/dialogs/profile.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutterwaka/extensions/datetime.dart';

final _currentPage = StateProvider((ref) => 0);
final _previousPage = StateProvider<int>((ref) {
  ref.listen(_currentPage, (previous, next) {
    ref.controller.state = previous ?? 0;
  });

  return 0;
});
final _showFab = StateProvider((ref) {
  ref.watch(summaryRangeProvider);
  return true;
});
final _shouldShowCancel = Provider<bool>((ref) {
  final currentRange = ref.watch(summaryRangeProvider);
  final defaultRange = ref.watch(dashboardSettingsProvider).range;
  final now = DateTime.now();
  final locale = ref.watch(localeProvider);
  final localization = DateFormat.yMMMMEEEEd(Intl.canonicalizedLocale(
    locale.toString(),
  ));

  return !currentRange.end.isSameDay(now) ||
      !currentRange.start.isSameDay(
        defaultRange.buildRange(
            now, (localization.dateSymbols.FIRSTDAYOFWEEK + 1) % 7),
      );
});

final format = DateFormat('dd/MM/yyyy');

class HomePage extends ConsumerWidget {
  static const List<String> _titles = ['This week', 'Projects', 'Timeline'];

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

  void _openAccount(BuildContext context) {
    showDialog(context: context, builder: (c) => const ProfileDialog());
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
    final previousPage = ref.watch(_previousPage);
    final range = ref.watch(summaryRangeProvider);
    final avatar = ref.watch(profilePicProvider).valueOrNull;
    final showFab = ref.watch(_showFab);

    return Scaffold(
      appBar: AppBar(
        title: Text(_title(page, range)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => _openAccount(context),
              child: Avatar(
                image: avatar,
                radius: 18,
              ),
            ),
          )
        ],
      ),
      body: PageTransitionSwitcher(
        reverse: page < previousPage,
        duration: Durations.long1,
        transitionBuilder: (child, anim, secAnim) => SharedAxisTransition(
          animation: anim,
          secondaryAnimation: secAnim,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
        ),
        child: [
          NotificationListener<UserScrollNotification>(
            onNotification: (n) => _onScroll(n, ref, showFab),
            child: SummaryPage(
              onSelectPeriod: () => _selectRange(context, ref),
            ),
          ),
          const ProjectsPage(),
          const TimelinePage(),
        ][page],
      ),
      floatingActionButton: _buildFab(page, ref, context, range, showFab),
      bottomNavigationBar: _buildNavigationBar(page, ref),
    );
  }

  Widget? _buildFab(
    int page,
    WidgetRef ref,
    BuildContext context,
    DateTimeRange range,
    bool showClear,
  ) {
    final shouldShowCancel = ref.watch(_shouldShowCancel);
    if (page != 0) return null;

    return CancellableFAB(
      onPrimaryTapped: () => _selectRange(context, ref),
      onCancelTapped: () => ref.invalidate(summaryRangeProvider),
      primary: const Icon(LucideIcons.calendar),
      cancel: const Icon(LucideIcons.x),
      open: shouldShowCancel && showClear,
    );
  }

  Widget _buildNavigationBar(int page, WidgetRef ref) {
    return NavigationBar(
      selectedIndex: page,
      onDestinationSelected: (value) =>
          ref.read(_currentPage.notifier).state = value,
      // labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
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
          icon: Icon(LucideIcons.gitCommit),
          label: "Timeline",
        ),
      ],
    );
  }
}
