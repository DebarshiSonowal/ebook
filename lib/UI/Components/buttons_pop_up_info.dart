import 'package:ebook/Model/enote_banner.dart';
import 'package:ebook/Model/library_book_details.dart';
import 'package:ebook/Storage/app_storage.dart';
import 'package:ebook/UI/Routes/Navigation%20Page/book_details.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Constants/constance_data.dart';
import '../../Helper/navigator.dart';
import '../../Model/bookmark.dart';
import '../../Model/home_banner.dart';
import '../../Storage/data_provider.dart';

class ButtonsPopUpInfo extends StatelessWidget {
  const ButtonsPopUpInfo({
    Key? key,
    required this.data,
    required this.is_ebook,
  }) : super(key: key);
  final bool is_ebook;
  final Book data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 4.5.h,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // initiatePaymentProcess(widget.data.id);
                Navigation.instance.navigate('/bookInfo', args: data.id);
                // if (data.book_format == "magazine") {
                //   Navigation.instance
                //       .navigate('/magazineArticles', args: data.id ?? 0);
                // } else {
                //   Navigation.instance.navigate('/bookInfo', args: data.id);
                //   // Navigation.instance.navigate('/reading',
                //   //     args: data.id ?? 0);
                // }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              child: Text(
                'View Details',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 2.h,
                      color: Colors.black,
                    ),
              ),
            ),
          ),
          (data.is_bought ?? false)
              ? is_ebook
                  ? Container()
                  : SizedBox(
                      width: 1.w,
                    )
              : SizedBox(
                  width: 1.w,
                ),
          (data.is_bought ?? false)
              ? is_ebook
                  ? Container()
                  : viewArticlesButton(data: data)
              : addToButton(data: data),
        ],
      ),
    );
  }
}

class viewArticlesButton extends StatelessWidget {
  const viewArticlesButton({
    super.key,
    required this.data,
  });

  final Book data;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          // Navigation.instance
          //     .navigate('/bookInfo', args: data.id);

          if ((Provider.of<DataProvider>(
                          Navigation.instance.navigatorKey.currentContext ??
                              context,
                          listen: false)
                      .profile !=
                  null) &&
              Storage.instance.isLoggedIn) {
            Navigation.instance
                .navigate('/magazineArticles', args: data.id ?? 0);
          } else {
            ConstanceData.showAlertDialog(context);
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
        ),
        child: Text(
          "View Articles",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 2.h,
                color: Colors.black,
              ),
        ),
      ),
    );
  }
}

class addToButton extends StatelessWidget {
  const addToButton({
    super.key,
    required this.data,
  });

  final Book data;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          if ((Provider.of<DataProvider>(
                          Navigation.instance.navigatorKey.currentContext ??
                              context,
                          listen: false)
                      .profile !=
                  null) &&
              Storage.instance.isLoggedIn) {
            debugPrint(
                "${data.subscriptions.isNotEmpty} ${data.book_format != "e-book"}");
            if ((Provider.of<DataProvider>(
                        Navigation.instance.navigatorKey.currentContext ??
                            context,
                        listen: false)
                    .cartData
                    ?.items
                    .where(
                        (element) => (element.item_id ?? 0) == (data.id ?? 0))
                    .isNotEmpty ??
                false)) {
              Navigation.instance.navigate("/cartPage");
            } else {
              if (data.subscriptions.isNotEmpty &&
                  data.book_format != "e-book") {
                Navigation.instance
                    .navigate("/subscription_pop_up", args: data.id);
              } else {
                ConstanceData.addtocart(context, data.id);
              }
            }
          } else {
            ConstanceData.showAlertDialog(context);
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
        ),
        child: Consumer<DataProvider>(builder: (context, repo, _) {
          return Text(
            (repo.cartData?.items
                        .where((element) =>
                            (element.item_id ?? 0) == (data.id ?? 0))
                        .isNotEmpty ??
                    false)
                ? 'Go To Cart'
                : 'Add To Cart',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 2.h,
                  color: Colors.black,
                ),
          );
        }),
      ),
    );
  }
}

//Data

class ButtonsDataPopUpInfo extends StatelessWidget {
  const ButtonsDataPopUpInfo({
    Key? key,
    required this.data,
    required this.is_ebook,
  }) : super(key: key);
  final bool is_ebook;
  final LibraryBookDetailsModel data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 4.5.h,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // initiatePaymentProcess(widget.data.id);
                Navigation.instance.navigate('/bookInfo', args: data.id);
                // if (data.book_format == "magazine") {
                //   Navigation.instance
                //       .navigate('/magazineArticles', args: data.id ?? 0);
                // } else {
                //   Navigation.instance.navigate('/bookInfo', args: data.id);
                //   // Navigation.instance.navigate('/reading',
                //   //     args: data.id ?? 0);
                // }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              child: Text(
                'View Details',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 2.h,
                      color: Colors.black,
                    ),
              ),
            ),
          ),
          // (data.is_bought ?? false)
          //     ? is_ebook
          //         ? Container()
          //         : SizedBox(
          //             width: 1.w,
          //           )
          //     : SizedBox(
          //         width: 1.w,
          //       ),
          (data.is_bought ?? false)
              ? is_ebook
                  ? Container()
                  : viewArticlesDataButton(data: data)
              : addToDataButton(data),
        ],
      ),
    );
  }
}

class viewArticlesDataButton extends StatelessWidget {
  const viewArticlesDataButton({
    super.key,
    required this.data,
  });

  final LibraryBookDetailsModel data;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          // Navigation.instance
          //     .navigate('/bookInfo', args: data.id);

          if ((Provider.of<DataProvider>(
                          Navigation.instance.navigatorKey.currentContext ??
                              context,
                          listen: false)
                      .profile !=
                  null) &&
              Storage.instance.isLoggedIn) {
            Navigation.instance
                .navigate('/magazineArticles', args: data.id ?? 0);
          } else {
            ConstanceData.showAlertDialog(context);
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
        ),
        child: Text(
          "View Articles",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 2.h,
                color: Colors.black,
              ),
        ),
      ),
    );
  }
}

class addToDataButton extends StatelessWidget {
  final LibraryBookDetailsModel data;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          if ((Provider.of<DataProvider>(
                          Navigation.instance.navigatorKey.currentContext ??
                              context,
                          listen: false)
                      .profile !=
                  null) &&
              Storage.instance.isLoggedIn) {
            if ((Provider.of<DataProvider>(
                        Navigation.instance.navigatorKey.currentContext ??
                            context,
                        listen: false)
                    .cartData
                    ?.items
                    .where(
                        (element) => (element.item_id ?? 0) == (data.id ?? 0))
                    .isNotEmpty ??
                false)) {
              Navigation.instance.navigate("/cartPage");
            } else {
              // if (data.subscriptions.isNotEmpty &&
              //     data.book_format != "e-book") {
              //   Navigation.instance
              //       .navigate("/subscription_pop_up", args: data.id);
              // } else {
              //   ConstanceData.addtocart(context, data.id);
              // }
            }
          } else {
            ConstanceData.showAlertDialog(context);
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
        ),
        child: Consumer<DataProvider>(builder: (context, repo, _) {
          return Text(
            (repo.cartData?.items
                        .where((element) =>
                            (element.item_id ?? 0) == (data.id ?? 0))
                        .isNotEmpty ??
                    false)
                ? 'Go To Cart'
                : 'Add To Cart',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 2.h,
                  color: Colors.black,
                ),
          );
        }),
      ),
    );
  }

  addToDataButton(this.data);
}

//Enote
class ButtonsEnotePopUpInfo extends StatelessWidget {
  const ButtonsEnotePopUpInfo({
    Key? key,
    required this.data,
    required this.is_ebook,
  }) : super(key: key);
  final bool is_ebook;
  final EnoteBanner data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 4.5.h,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // initiatePaymentProcess(widget.data.id);
                Navigation.instance.navigate('/bookInfo', args: data.id);
                // if (data.book_format == "magazine") {
                //   Navigation.instance
                //       .navigate('/magazineArticles', args: data.id ?? 0);
                // } else {
                //   Navigation.instance.navigate('/bookInfo', args: data.id);
                //   // Navigation.instance.navigate('/reading',
                //   //     args: data.id ?? 0);
                // }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              child: Text(
                'View Details',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 2.h,
                      color: Colors.black,
                    ),
              ),
            ),
          ),
          (data.isBought ?? false)
              ? is_ebook
                  ? Container()
                  : SizedBox(
                      width: 1.w,
                    )
              : SizedBox(
                  width: 1.w,
                ),
          (data.isBought ?? false)
              ? is_ebook
                  ? Container()
                  : viewEnotesButton(data: data)
              : addEnotesToButton(data: data),
        ],
      ),
    );
  }
}

class viewEnotesButton extends StatelessWidget {
  const viewEnotesButton({
    super.key,
    required this.data,
  });

  final EnoteBanner data;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          // Navigation.instance
          //     .navigate('/bookInfo', args: data.id);

          if ((Provider.of<DataProvider>(
                          Navigation.instance.navigatorKey.currentContext ??
                              context,
                          listen: false)
                      .profile !=
                  null) &&
              Storage.instance.isLoggedIn) {
            Navigation.instance
                .navigate('/magazineArticles', args: data.id ?? 0);
          } else {
            ConstanceData.showAlertDialog(context);
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
        ),
        child: Text(
          "View Articles",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 2.h,
                color: Colors.black,
              ),
        ),
      ),
    );
  }
}

class addEnotesToButton extends StatelessWidget {
  const addEnotesToButton({
    super.key,
    required this.data,
  });

  final EnoteBanner data;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          if ((Provider.of<DataProvider>(
                          Navigation.instance.navigatorKey.currentContext ??
                              context,
                          listen: false)
                      .profile !=
                  null) &&
              Storage.instance.isLoggedIn) {
            debugPrint(
                "${data.subscriptions.isNotEmpty} ${data.bookFormat != "e-book"}");
            if ((Provider.of<DataProvider>(
                        Navigation.instance.navigatorKey.currentContext ??
                            context,
                        listen: false)
                    .cartData
                    ?.items
                    .where(
                        (element) => (element.item_id ?? 0) == (data.id ?? 0))
                    .isNotEmpty ??
                false)) {
              Navigation.instance.navigate("/cartPage");
            } else {
              if (data.subscriptions.isNotEmpty &&
                  data.bookFormat != "e-book") {
                Navigation.instance
                    .navigate("/subscription_pop_up", args: data.id);
              } else {
                ConstanceData.addtocart(context, data.id);
              }
            }
          } else {
            ConstanceData.showAlertDialog(context);
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
        ),
        child: Consumer<DataProvider>(builder: (context, repo, _) {
          return Text(
            (repo.cartData?.items
                        .where((element) =>
                            (element.item_id ?? 0) == (data.id ?? 0))
                        .isNotEmpty ??
                    false)
                ? 'Go To Cart'
                : 'Add To Cart',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 2.h,
                  color: Colors.black,
                ),
          );
        }),
      ),
    );
  }
}
