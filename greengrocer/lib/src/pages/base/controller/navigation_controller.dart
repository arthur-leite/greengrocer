import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/enums/navigation_tab_enum.dart';

class NavigationController extends GetxController {
  late PageController _pageController;
  late RxInt _currentIndex;

  PageController get pageController => _pageController;
  int get currentIndex => _currentIndex.value;

  @override
  void onInit() {
    super.onInit();

    _initNavigation(
        pageController: PageController(
          initialPage: NavigationTabEnum.home.index,
        ),
        currentIndex: NavigationTabEnum.home.index);
  }

  void _initNavigation(
      {required PageController pageController, required int currentIndex}) {
    _pageController = pageController;
    _currentIndex = currentIndex.obs;
  }

  void navigatePageView(int page) {
    if (_currentIndex.value == page) return;

    _pageController.jumpToPage(page);

    _currentIndex.value = page;
  }
}
