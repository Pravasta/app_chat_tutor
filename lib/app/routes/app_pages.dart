import 'package:get/get.dart';

import '../modules/changeprofile/bindings/changeprofile_binding.dart';
import '../modules/changeprofile/views/changeprofile_view.dart';
import '../modules/chatsroom/bindings/chatsroom_binding.dart';
import '../modules/chatsroom/views/chatsroom_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/introduction/bindings/introduction_binding.dart';
import '../modules/introduction/views/introduction_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/search/bindings/search_binding.dart';
import '../modules/search/views/search_view.dart';
import '../modules/updatestatus/bindings/updatestatus_binding.dart';
import '../modules/updatestatus/views/updatestatus_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.INTRODUCTION,
      page: () => const IntroductionView(),
      binding: IntroductionBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.CHATSROOM,
      page: () => ChatsroomView(),
      binding: ChatsroomBinding(),
    ),
    GetPage(
      name: _Paths.UPDATESTATUS,
      page: () => UpdatestatusView(),
      binding: UpdatestatusBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH,
      page: () => SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: _Paths.CHANGEPROFILE,
      page: () => ChangeprofileView(),
      binding: ChangeprofileBinding(),
    ),
  ];
}
