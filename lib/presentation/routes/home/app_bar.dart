import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mdi_todo/presentation/notifiers/theme_mode_notifier.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatelessWidget {
  final TabController tabController;

  const MyAppBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      centerTitle: true,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.surface,
        statusBarIconBrightness:
            Theme.of(context).brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light,
      ),
      actions: [
        Consumer<ThemeModeNotifier>(
          builder: (context, themeMode, child) {
            if (themeMode.value == ThemeMode.light) {
              return IconButton(
                tooltip: 'Change theme to Dark Mode',
                onPressed: () {
                  context.read<ThemeModeNotifier>().change(ThemeMode.dark);
                },
                icon: const Icon(Icons.light_mode_outlined),
              );
            }

            if (themeMode.value == ThemeMode.dark) {
              return IconButton(
                tooltip: 'Change theme to System Mode',
                onPressed: () {
                  context.read<ThemeModeNotifier>().change(ThemeMode.system);
                },
                icon: const Icon(Icons.dark_mode_outlined),
              );
            }

            return IconButton(
              tooltip: 'Change theme to Light Mode',
              onPressed: () {
                context.read<ThemeModeNotifier>().change(ThemeMode.light);
              },
              icon: const Icon(Icons.auto_awesome_outlined),
            );
          },
        ),
        const SizedBox(width: 2),
      ],
      title: Text(
        'MDI Todo',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
      bottom: TabBar(
        controller: tabController,
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor:
            Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        indicatorColor: Theme.of(context).colorScheme.primary,
        tabs: const [
          Tab(icon: Icon(Icons.list), text: 'Active Tasks'),
          Tab(icon: Icon(Icons.done), text: 'Completed Tasks'),
        ],
      ),
    );
  }
}
