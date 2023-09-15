import 'package:educational_app/core/common/app/provider/course_of_the_day_notifier.dart';
import 'package:educational_app/core/common/app/provider/tab_navigator.dart';
import 'package:educational_app/core/common/app/provider/user_provider.dart';
import 'package:educational_app/src/auth/domain/entities/user.dart';
import 'package:educational_app/src/course/domain/entities/course.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension ContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get size => mediaQuery.size;

  double get width => size.width;

  double get height => size.height;

  UserProvider get userProvider => read<UserProvider>();

  LocalUser? get currentUser => userProvider.user;

  TabNavigator get tabNavigator => read<TabNavigator>();

  Course? get courseOfTheDay => read<CourseOfTheDayNotifier>().courseOfTheDay;

  void pop() => tabNavigator.pop();

  void push(Widget page) => tabNavigator.push(TabItem(child: page));
}
