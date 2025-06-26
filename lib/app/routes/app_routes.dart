// lib/app/routes/app_routes.dart
part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  // Add other routes here when you define them (if not commented out in app_pages)
  static const SETTINGS = _Paths.SETTINGS;
  static const MENU = _Paths.MENU;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  // Add other paths here when you define them (if not commented out in app_pages)
  static const SETTINGS = '/settings';
  static const MENU = '/menu';
}
