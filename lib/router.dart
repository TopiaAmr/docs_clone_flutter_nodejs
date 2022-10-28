import 'package:docs_clone_flutter/screens/home_screen.dart';
import 'package:docs_clone_flutter/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final signinRoute = RouteMap(
  routes: {
    '/': (route) => const MaterialPage(child: LoginScreen()),
  },
);

final authedRoutes = RouteMap(
  routes: {
    '/': (route) => const MaterialPage(child: HomeScreen()),
  },
);
