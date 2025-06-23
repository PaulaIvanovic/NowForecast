// This file only defines constants.

part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const SETTINGS = _Paths.SETTINGS;
  static const MENU = _Paths.MENU;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const SETTINGS = '/settings';
  static const MENU = '/menu';
}
