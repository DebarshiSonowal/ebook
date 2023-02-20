import 'package:ebook/UI/Routes/Auth/registration_page.dart';
import 'package:ebook/UI/Routes/Navigation%20Page/account_page.dart';
import 'package:ebook/UI/Routes/Navigation%20Page/book_info.dart';
import 'package:ebook/UI/Routes/Navigation%20Page/home_page.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;

import '../UI/Components/loading_dialog.dart';
import '../UI/Routes/Auth/login_otp_verify.dart';
import '../UI/Routes/Auth/login_page.dart';
import '../UI/Routes/Auth/registration_otp_verify.dart';
import '../UI/Routes/Navigation Page/account_information.dart';
import '../UI/Routes/Navigation Page/book_details.dart';
import '../UI/Routes/Navigation Page/cart_page.dart';
import '../UI/Routes/Navigation Page/category_page.dart';
import '../UI/Routes/Navigation Page/category_specific_page.dart';
import '../UI/Routes/Navigation Page/coupon_page.dart';
import '../UI/Routes/Navigation Page/magazine_articles.dart';
import '../UI/Routes/Navigation Page/magazine_details.dart';
import '../UI/Routes/Navigation Page/reading_page.dart';
import '../UI/Routes/Navigation Page/search_page.dart';
import '../UI/Routes/Navigation Page/writer_info.dart';
import '../UI/Routes/OnBoarding/splash_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return FadeTransitionPageRouteBuilder(page: SplashScreen());
    // case '/onboarding':
    //   return FadeTransitionPageRouteBuilder(page: OnBoardingPage());

    // login pages
    case '/login':
      return FadeTransitionPageRouteBuilder(page: LoginPage());
    case '/signup':
      return FadeTransitionPageRouteBuilder(page: RegistrationPage());
    case '/verifyOtpLogin':
      return FadeTransitionPageRouteBuilder(page: LoginOtpVerify());
    case '/verifyOtpSignup':
      return FadeTransitionPageRouteBuilder(page: RegisterationOTPVerify());
    case '/bookDetails':
      return FadeTransitionPageRouteBuilder(
          page: BookDetails(settings.arguments as String));
    case '/reading':
      return FadeTransitionPageRouteBuilder(
          page: ReadingPage(settings.arguments as int));
    case '/magazineDetails':
      return FadeTransitionPageRouteBuilder(
          page: MagazineDetailsPage(settings.arguments as String));
    case '/magazineArticles':
      return FadeTransitionPageRouteBuilder(
          page: MagazineArticles(settings.arguments as int));

    case '/bookInfo':
      return FadeTransitionPageRouteBuilder(
          page: BookInfo(settings.arguments as int));
    case '/categories':
      return FadeTransitionPageRouteBuilder(page: CategoryPage());
      case '/selectCategories':
      return FadeTransitionPageRouteBuilder(page: CategorySpecificPage(
        content: settings.arguments as String,
      ));

    case '/accountDetails':
      return FadeTransitionPageRouteBuilder(page: AccountPage());

    case '/accountInformation':
      return FadeTransitionPageRouteBuilder(page: AccountInformation());

    case '/loadingDialog':
      return FadeTransitionPageRouteBuilder(page: LoadingDialog());
    case '/couponPage':
      return FadeTransitionPageRouteBuilder(page: CouponPage());
    case '/writerInfo':
      return FadeTransitionPageRouteBuilder(
          page: WriterInfo(settings.arguments as String));
    case '/readingDialog':
      return FadeTransitionPageRouteBuilder(page: ReadingDialog(settings.arguments as String));
    case '/cartPage':
      return FadeTransitionPageRouteBuilder(page: CartPage());
    case '/search':
      return FadeTransitionPageRouteBuilder(page: SearchPage());
    case '/searchWithTag':
      return FadeTransitionPageRouteBuilder(
          page: SearchPage(
        tags: (settings.arguments as String),
        authors: "",
      ));
    case '/searchWithAuthor':
      return FadeTransitionPageRouteBuilder(
          page: SearchPage(
        tags: "",
        authors: (settings.arguments as String),
      ));
    //Main
    case '/main':
      return FadeTransitionPageRouteBuilder(page: HomePage());

    default:
      return MaterialPageRoute(builder: (_) {
        return const Scaffold(
          body: Center(
            child: Text('404 Page not found'),
          ),
        );
      });
  }
}

class FadeTransitionPageRouteBuilder extends PageRouteBuilder {
  final Widget page;

  FadeTransitionPageRouteBuilder({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          opaque: false,
          barrierColor: null,
          barrierLabel: null,
          maintainState: true,
          transitionDuration: Duration(milliseconds: 100),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
