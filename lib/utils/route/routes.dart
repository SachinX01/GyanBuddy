import 'package:flutter/material.dart';
import 'package:gyanbuddy/landing_page.dart';
import 'package:gyanbuddy/auth/login_screen.dart';
import 'package:gyanbuddy/auth/signup_screen.dart';
import 'package:gyanbuddy/wrapper.dart';
import 'package:gyanbuddy/pages/about.dart';
import 'package:gyanbuddy/pages/explore.dart';
import 'package:gyanbuddy/pages/explore/quiz.dart';
import 'package:gyanbuddy/pages/favorite.dart';
import 'package:gyanbuddy/pages/fruits.dart';
import 'package:gyanbuddy/pages/home.dart';
import 'package:gyanbuddy/pages/main_home.dart';
import 'package:gyanbuddy/pages/modules/animals.dart';
import 'package:gyanbuddy/pages/modules/numbers.dart';
import 'package:gyanbuddy/pages/modules/atoz.dart';
import 'package:gyanbuddy/pages/modules/birds.dart';
import 'package:gyanbuddy/pages/modules/colours.dart';
import 'package:gyanbuddy/pages/modules/flowers.dart';
import 'package:gyanbuddy/pages/modules/occupation.dart';
import 'package:gyanbuddy/pages/modules/parts.dart';
import 'package:gyanbuddy/pages/modules/planets.dart';
import 'package:gyanbuddy/pages/modules/seasons.dart';
import 'package:gyanbuddy/pages/modules/shapes.dart';
import 'package:gyanbuddy/utils/route/page_transition.dart';
import 'package:gyanbuddy/utils/route/route_constant.dart';
import 'package:gyanbuddy/pages/user_profile.dart';

import '../../pages/explore/drawingboard.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AllRoutesConstant.homeRoute:
        return fadePageRoute(const MyHomePage());
      case AllRoutesConstant.exploreRoute:
        return fadePageRoute(const ExplorePage());
      case AllRoutesConstant.atozRoute:
        return fadePageRoute(const AtoZ());
      case AllRoutesConstant.birdsRoute:
        return fadePageRoute(BirdsPage());
      case AllRoutesConstant.shapesRoute:
        return fadePageRoute(const ShapesPage());
      case AllRoutesConstant.partsRoute:
        return fadePageRoute(const PartsPage());
      case AllRoutesConstant.solarRoute:
        return fadePageRoute(PlanetsPage());
      case AllRoutesConstant.animalRoute:
        return fadePageRoute(AnimalsPage());
      case AllRoutesConstant.numberRoute:
        return fadePageRoute(const NumbersPage());
      case AllRoutesConstant.colourRoute:
        return fadePageRoute(const ColoursPage());
      case AllRoutesConstant.aboutRoute:
        return fadePageRoute(const AboutPage());
      case AllRoutesConstant.flowerRoute:
        return fadePageRoute(const FlowerPage());
      case AllRoutesConstant.favoriteRoute:
        return fadePageRoute(const FavoritePage());
      case AllRoutesConstant.quizRoute:
        return fadePageRoute(const Quiz());
      case AllRoutesConstant.drawingboardRoute:
        return fadePageRoute(const DrawingBoardPage());
      case AllRoutesConstant.seasonRoute:
        return fadePageRoute(const SeasonsPage());
      case AllRoutesConstant.occupationRoute:
        return fadePageRoute(OccupationPage());
      case AllRoutesConstant.fruitRoute:
        return fadePageRoute(FruitsPage());
      case AllRoutesConstant.userProfile:
        return fadePageRoute(const UserProfilePage());

      // Auth pages with slide-up transition
      case AllRoutesConstant.loginRoute:
        return authPageRoute(const LoginScreen());
      case AllRoutesConstant.signupRoute:
        return authPageRoute(const SignupScreen());

      // Pages with default transition
      case AllRoutesConstant.landingRoute:
        return MaterialPageRoute(builder: (_) => const LandingPage());
      case AllRoutesConstant.mainhomeRoute:
        return MaterialPageRoute(builder: (_) => const MainHome());
      case AllRoutesConstant.wrapperRoute:
        return MaterialPageRoute(builder: (_) => const Wrapper());

      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('No route found'),
            ),
          ),
        );
    }
  }
}
