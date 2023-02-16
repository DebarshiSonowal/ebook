import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Constants/constance_data.dart';
import '../../Helper/navigator.dart';
import '../../Networking/api_provider.dart';
import '../../Storage/app_storage.dart';
import '../../Storage/data_provider.dart';

class BuyButton extends StatelessWidget {
  final int id;
  Function onTap;

  BuyButton(this.id, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: double.infinity,
        height: 4.5.h,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  if ((Provider.of<DataProvider>(
                      Navigation.instance.navigatorKey
                          .currentContext ??
                          context,
                      listen: false)
                      .profile !=
                      null) &&
                      Storage.instance.isLoggedIn) {
                    onTap();
                  } else {
                    ConstanceData.showAlertDialog(context);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                child: Text(
                  'Buy Now',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                    fontSize: 2.h,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 1.w,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Navigation.instance
                  //     .navigate('/bookInfo', args: data.id);

                  if ((Provider.of<DataProvider>(
                      Navigation.instance.navigatorKey
                          .currentContext ??
                          context,
                      listen: false)
                      .profile !=
                      null) &&
                      Storage.instance.isLoggedIn) {
                    addtocart(context, id);
                  } else {
                    ConstanceData.showAlertDialog(context);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                child: Text(
                  'Add To Cart',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                    fontSize: 2.h,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addtocart(context, id) async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.addToCart(id, '1');
    if (response.status ?? false) {
      Provider.of<DataProvider>(
          Navigation.instance.navigatorKey.currentContext ?? context,
          listen: false)
          .setToCart(response.cart?.items ?? []);
      Provider.of<DataProvider>(
          Navigation.instance.navigatorKey.currentContext!,
          listen: false)
          .setCartData(response.cart!);
      Navigation.instance.goBack();
      showSuccess(context);
    } else {
      Navigation.instance.goBack();
      showError(context);
    }
  }

  void showSuccess(context) {
    // var snackBar = SnackBar(
    //   elevation: 0,
    //   behavior: SnackBarBehavior.floating,
    //   backgroundColor: Colors.transparent,
    //   content: AwesomeSnackbarContent(
    //     title: 'Added to cart',
    //     message: 'The following book is added to cart',
    //     contentType: ContentType.success,
    //   ),
    // );
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Fluttertoast.showToast(msg: "The following book is added to cart");
  }

  void showError(context) {
    // var snackBar = SnackBar(
    //   elevation: 0,
    //   behavior: SnackBarBehavior.floating,
    //   backgroundColor: Colors.transparent,
    //   content: AwesomeSnackbarContent(
    //     title: 'Failed',
    //     message: 'Something went wrong',
    //     contentType: ContentType.failure,
    //   ),
    // );
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Fluttertoast.showToast(msg: "The following book is added to cart");
  }
}