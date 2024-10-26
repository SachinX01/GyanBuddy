// ignore_for_file: deprecated_member_use

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gyanbuddy/cubit/index_cubit.dart';
import 'package:gyanbuddy/pages/about.dart';
import 'package:gyanbuddy/pages/explore/explore.dart';
import 'package:gyanbuddy/pages/favorite.dart';
import 'package:gyanbuddy/pages/home.dart';
import 'package:gyanbuddy/widgets/navbar/navbar.dart';
import 'package:gyanbuddy/services/user_data_service.dart';
import 'dart:async';

class MainHome extends StatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MainHome({
    super.key,
    this.savedThemeMode,
  });

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> with WidgetsBindingObserver {
  late PageController _pageController;
  DateTime? currentBackPressTime;
  DateTime? _pausedTime;
  final UserDataService _userDataService = UserDataService();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addObserver(this);
    _userDataService.updateUserActivity();

    Timer.periodic(Duration(minutes: 1), (timer) {
      if (_pausedTime == null) {
        _userDataService.updateTotalUsageTime(60);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_pausedTime != null) {
      final now = DateTime.now();
      final elapsedSeconds = now.difference(_pausedTime!).inSeconds;
      _userDataService.updateTotalUsageTime(elapsedSeconds);
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      _pausedTime = DateTime.now();
    } else if (state == AppLifecycleState.resumed && _pausedTime != null) {
      final now = DateTime.now();
      final elapsedSeconds = now.difference(_pausedTime!).inSeconds;
      _userDataService.updateTotalUsageTime(elapsedSeconds);
      _pausedTime = null;
    }
  }

  bool _onBackPressed(bool canPop) {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: "Press back again to exit",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      canPop = false;
    } else {
      canPop = true;
    }
    return canPop;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: _onBackPressed,
      child: AdaptiveTheme(
        light: ThemeData.light(),
        dark: ThemeData.dark(),
        initial: widget.savedThemeMode ?? AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => BlocProvider(
          create: (context) => IndexCubit(),
          child: BlocBuilder<IndexCubit, int>(
            builder: (context, index) {
              return Scaffold(
                body: PageView(
                  controller: _pageController,
                  children: const [
                    MyHomePage(),
                    ExplorePage(),
                    FavoritePage(),
                    AboutPage(),
                  ],
                  onPageChanged: (index) {
                    context.read<IndexCubit>().changeIndex(index);
                  },
                ),
                bottomNavigationBar:
                    BottomNavBar(pageController: _pageController),
              );
            },
          ),
        ),
      ),
    );
  }
}
