import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../Constants/constance_data.dart';
import '../../../Helper/navigator.dart';
import '../../../Model/bookmark.dart';
import '../../../Model/home_banner.dart';
import '../../../Networking/api_provider.dart';
import '../../../Storage/data_provider.dart';
import '../../Components/library_card_item.dart';

class SpecificLibraryPage extends StatefulWidget {
  const SpecificLibraryPage({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<SpecificLibraryPage> createState() => _SpecificLibraryPageState();
}

class _SpecificLibraryPageState extends State<SpecificLibraryPage>
    with TickerProviderStateMixin {
  TabController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Provider.of<DataProvider>(context, listen: false)
              .libraries
              .firstWhere((e) => e.id == widget.id)
              .title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 17.sp,
          ),
        ),
      ),
      body: Container(
        color: ConstanceData.primaryColor,
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 0.7.h, horizontal: 2.w),
        child: Consumer<DataProvider>(builder: (cont, data, _) {
          return GridView.builder(
              itemCount: data.library.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 2.5,
                crossAxisSpacing: 10.w,
              ),
              itemBuilder: (context, count) {
                var current = data.library[count];
                return GestureDetector(
                  onTap: () {
                    // Navigation.instance.navigate('/reading',
                    //     args: (data.myBooks[count].id) ?? 0);
                    // Navigation.instance
                    //     .navigate('/bookDetails', args: current.id ?? 0);
                    ConstanceData.showBookDetails(context, current);
                  },
                  child: Card(
                    child: CachedNetworkImage(
                      imageUrl: current.profile_pic ?? "",
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              });
        }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _controller = TabController(
      length: 2,
      vsync: this,
    );
    Future.delayed(Duration.zero, () {
      fetchData();
    });
  }

  void fetchData() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getLibraryBookList(widget.id);
    if (response.status ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setLibraryBooks(response.details ?? []);
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
    }
  }
}
