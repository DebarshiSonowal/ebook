import 'package:cool_alert/cool_alert.dart';
import 'package:ebook/Constants/constance_data.dart';
import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Components/book_item.dart';

class CategorySpecificPage extends StatefulWidget {
  final String content;

  CategorySpecificPage({required this.content});

  @override
  State<CategorySpecificPage> createState() => _CategorySpecificPageState();
}

class _CategorySpecificPageState extends State<CategorySpecificPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.content.split(",")[0] ?? "",
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headline1?.copyWith(
                color: Colors.white,
              ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: ConstanceData.primaryColor,
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return GridView.builder(
            shrinkWrap: true,
            itemCount: data.search_results.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.52.sp,
                crossAxisCount: 2,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 2.h),
            itemBuilder: (BuildContext context, int index) {
              var book = data.search_results[index];
              return BookItem(data: book, index: index);
            },
          );
        }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => fetchBooks());
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
      CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        text: "Something went wrong",
      );
    }
  }
}
