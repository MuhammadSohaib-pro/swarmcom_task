import 'package:get/get.dart';
import 'package:test_app/views/home_view.dart';

class AppRoutes {
  static const home = '/';

  static final routes = [
    GetPage(
      name: home,
      page: () => const HomeView(),
    ),
  ];
}
