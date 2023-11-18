import 'package:get/get.dart';
import 'package:greengrocer/src/constants/page_routes.dart';
import 'package:greengrocer/src/pages/auth/view/sign_in_screen.dart';
import 'package:greengrocer/src/pages/auth/view/sign_up_screen.dart';
import 'package:greengrocer/src/pages/base/base_screen.dart';
import 'package:greengrocer/src/pages/base/binding/navigation_binding.dart';
import 'package:greengrocer/src/pages/cart/binding/cart_binding.dart';
import 'package:greengrocer/src/pages/home/binding/home_binding.dart';
import 'package:greengrocer/src/pages/orders/binding/orders_binding.dart';
import 'package:greengrocer/src/pages/product/product_screen.dart';
import 'package:greengrocer/src/pages/splash/splash_screen.dart';

abstract class AppPages {
  static final pages = <GetPage>[
    GetPage(
      page: () => ProductScreen(),
      name: PageRoutes.productRoute,
    ),
    GetPage(
      page: () => const SplashScreen(),
      name: PageRoutes.splashRoute,
    ),
    GetPage(
      page: () => SignInScreen(),
      name: PageRoutes.signinRoute,
    ),
    GetPage(
      page: () => SignUpScreen(),
      name: PageRoutes.signupRoute,
    ),
    GetPage(
        page: () => const BaseScreen(),
        name: PageRoutes.baseRoute,
        bindings: [
          NavigationBinding(),
          HomeBinding(),
          CartBinding(),
          OrdersBinding(),
        ])
  ];
}
