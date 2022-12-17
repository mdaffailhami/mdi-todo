import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdi_todo/business_logic/cubits/tasks_cubit.dart';
import 'package:mdi_todo/business_logic/cubits/theme_mode_cubit.dart';
import 'package:mdi_todo/data/repositories/task_repository.dart';
import 'package:mdi_todo/data/repositories/theme_mode_repository.dart';

import 'components/app_bar.dart';
import 'components/task_form_dialog.dart';
import 'tabs/active_task_list_tab.dart';
import 'tabs/completed_task_list_tab.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late TabController tabController;
  final currentTabIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);

    tabController.addListener(() {
      if (!tabController.indexIsChanging) return;

      currentTabIndex.value = tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeModeCubit()),
        BlocProvider(create: (context) => TasksCubit()),
      ],
      child: BlocBuilder<ThemeModeCubit, ThemeModeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MDI Todo',
            themeMode: state.themeMode,
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              colorSchemeSeed: const Color(0xFF00579E),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorSchemeSeed: const Color(0xFF00579E),
            ),
            home: ValueListenableBuilder(
              valueListenable: currentTabIndex,
              builder: (context, value, child) {
                return Scaffold(
                  floatingActionButton: value == 0
                      ? FloatingActionButton(
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => const MyTaskFormDialog.add(),
                          ),
                          tooltip: 'Add task',
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          child: Icon(
                            Icons.add,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        )
                      : null,
                  body: child,
                );
              },
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [MyAppBar(tabController: tabController)];
                },
                body: TabBarView(
                  controller: tabController,
                  children: const [
                    MyActiveTaskListTab(),
                    MyCompletedTaskListTab(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
