import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cool_alert/cool_alert.dart';
import 'package:ebook/Constants/constance_data.dart';
import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:ebook/Utility/share_helper.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../../Model/home_banner.dart';
import '../../Components/book_item.dart';

class CategorySpecificPage extends StatefulWidget {
  final String content;

  const CategorySpecificPage({
    required this.content,
  });

  @override
  State<CategorySpecificPage> createState() => _CategorySpecificPageState();
}

class _CategorySpecificPageState extends State<CategorySpecificPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => fetchBooks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.content.split(",")[0] ?? "",
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 19.sp,
                color: Colors.black,
              ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await ShareHelper.shareText(
                  'https://play.google.com/store/apps/details?id=com.tsinfosec.ebook.ebook',
                  context: context);
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: 1.h,
        ),
        height: double.infinity,
        width: double.infinity,
        color: ConstanceData.primaryColor,
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return GridView.builder(
            shrinkWrap: true,
            itemCount: data.searchResults.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.4.sp,
                crossAxisCount: 2,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 2.h),
            itemBuilder: (BuildContext context, int index) {
              var book = data.searchResults[index];
              return BookItem(
                data: book,
                index: index,
                show: (bookData) {
                  ConstanceData.show(context, bookData);
                },
              );
            },
          );
        }),
      ),
    );
  }

  fetchBooks() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.search(
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext!,
                listen: false)
            .formats![Provider.of<DataProvider>(
                    Navigation.instance.navigatorKey.currentContext!,
                    listen: false)
                .currentTab]
            .productFormat,
        widget.content.split(",")[1],
        "",
        "",
        "",
        "");
    if (response.success ?? false) {
      Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setSearchResult(response.books);
    } else {
      Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setSearchResult([]);
      // CoolAlert.show(
      //   context: context,
      //   type: CoolAlertType.warning,
      //   text: "Something went wrong",
      // );
    }
  }

  void addtocart(context, id) async {
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
    Fluttertoast.showToast(msg: "Something went wrong");
  }
}
