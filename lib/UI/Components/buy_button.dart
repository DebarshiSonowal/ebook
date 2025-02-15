import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
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
  bool isBought;
  Function onTap;

  BuyButton(this.id, this.onTap, this.isBought);

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
                onPressed: () => ((Provider.of<DataProvider>(
                                    Navigation.instance.navigatorKey
                                            .currentContext ??
                                        context,
                                    listen: false)
                                .profile !=
                            null) &&
                        Storage.instance.isLoggedIn)
                    ? onTap()
                    : ConstanceData.showAlertDialog(context)
                // if () {
                //
                // } else {
                // ConstanceData.showAlertDialog(context);
                // }
                ,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                child: Text(
                  'Buy Now',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 15.sp,
                        color: Colors.black,
                      ),
                ),
              ),
            ),
            isBought
                ? Container()
                : SizedBox(
                    width: 1.w,
                  ),
            isBought
                ? Container()
                : Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigation.instance
                        //     .navigate('/bookInfo', args: data.id);

                        if (Provider.of<DataProvider>(
                                    Navigation.instance.navigatorKey
                                            .currentContext ??
                                        context,
                                    listen: false)
                                .cartData
                                ?.items
                                .where((element) =>
                                    (element.item_id ?? 0) == (id ?? 0))
                                .isNotEmpty ??
                            false) {
                          Navigation.instance.navigate("/cartPage");
                        } else {
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
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                      ),
                      child: Text(
                        (Provider.of<DataProvider>(
                                        Navigation.instance.navigatorKey
                                                .currentContext ??
                                            context,
                                        listen: false)
                                    .cartData
                                    ?.items
                                    .where((element) =>
                                        (element.item_id ?? 0) == (id ?? 0))
                                    .isNotEmpty ??
                                false)
                            ? 'Go To Cart'
                            : 'Add To Cart',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontSize: 15.sp,
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
