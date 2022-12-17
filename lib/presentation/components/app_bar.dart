import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdi_todo/business_logic/cubits/theme_mode_cubit.dart';

class MyAppBar extends StatelessWidget {
  final TabController tabController;
  const MyAppBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      centerTitle: true,
      surfaceTintColor: Theme.of(context).colorScheme.background,
      actions: [
        BlocBuilder<ThemeModeCubit, ThemeModeState>(
          builder: (context, state) {
            if (state.themeMode == ThemeMode.light) {
              return IconButton(
                tooltip: 'Change theme to Dark Mode',
                onPressed: () => BlocProvider.of<ThemeModeCubit>(context)
                    .changeThemeMode(ThemeMode.dark),
                icon: const Icon(Icons.light_mode_outlined),
              );
            }

            if (state.themeMode == ThemeMode.dark) {
              return IconButton(
                tooltip: 'Change theme to System Mode',
                onPressed: () => BlocProvider.of<ThemeModeCubit>(context)
                    .changeThemeMode(ThemeMode.system),
                icon: const Icon(Icons.dark_mode_outlined),
              );
            }

            return IconButton(
              tooltip: 'Change theme to Light Mode',
              onPressed: () => BlocProvider.of<ThemeModeCubit>(context)
                  .changeThemeMode(ThemeMode.light),
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
            Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
        indicatorColor: Theme.of(context).colorScheme.primary,
        tabs: const [
          Tab(icon: Icon(Icons.list), text: 'Active Tasks'),
          Tab(icon: Icon(Icons.done), text: 'Completed Tasks'),
        ],
      ),
    );
  }
}
