import 'package:educational_app/core/common/app/provider/tab_navigator.dart';
import 'package:educational_app/core/common/views/persistant_view.dart';
import 'package:educational_app/core/services/injection_container.dart';
import 'package:educational_app/src/course/features/videos/presentaation/cubit/video_cubit.dart';
import 'package:educational_app/src/course/presentation/cubit/course_cubit.dart';
import 'package:educational_app/src/home/presentation/views/home_view.dart';
import 'package:educational_app/src/profile/presentation/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class DashboardController extends ChangeNotifier {
  List<int> _indexHistory = [0];
  final List<Widget> _screens = [
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        TabItem(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => sl<CourseCubit>(),
              ),
              BlocProvider(
                create: (context) => sl<VideoCubit>(),
              ),
            ],
            child: const HomeView(),
          ),
        ),
      ),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigator(TabItem(child: const Placeholder())),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigator(TabItem(child: const Placeholder())),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigator(TabItem(child: const ProfileView())),
      child: const PersistentView(),
    ),
  ];

  List<Widget> get screens => _screens;
  int _currentIndex = 3;

  int get currentIndex => _currentIndex;

  void changeIndex(int index) {
    if (_currentIndex == index) return;
    _currentIndex = index;
    _indexHistory.add(index);
    notifyListeners();
  }

  void goBack() {
    if (_indexHistory.length == 1) return;
    _indexHistory.removeLast();
    _currentIndex = _indexHistory.last;
    notifyListeners();
  }

  void resetIndex() {
    _indexHistory = [0];
    _currentIndex = 0;
    notifyListeners();
  }
}
