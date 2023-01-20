import 'package:get/get.dart';

import 'package:gps_track/app/modules/dashboard/bindings/dashboard_binding.dart';
import 'package:gps_track/app/modules/dashboard/views/dashboard_view.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/map_setup/bindings/map_setup_binding.dart';
import '../modules/map_setup/views/map_setup_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.DASHBOARD;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.MAP_SETUP,
      page: () => const MapSetupView(),
      binding: MapSetupBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
  ];
}
