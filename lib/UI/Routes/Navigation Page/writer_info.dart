import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../Constants/constance_data.dart';
import '../../Components/book_item.dart';
import '../../Components/writter_account_home.dart';

class WriterInfo extends StatefulWidget {
  final String id;

  const WriterInfo(
    this.id,
  );

  @override
  State<WriterInfo> createState() => _WriterInfoState();
}

class _WriterInfoState extends State<WriterInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return SingleChildScrollView(
            child: Column(
              children: [
                WriterAccountHome(
                    int.parse(widget.id.toString().split(",")[1] ?? "0") == 0
                        ? ("${data.writerDetails?.name}")
                        : ("${data.writerDetails?.title}"),
                    data.writerDetails?.profile_pic ?? "",
                    data.writerDetails?.salutation ?? "",
                    data.writerDetails?.contributor_name ?? ""),
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  'About',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 2.5.h,
                      // color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                data.writerDetails?.about == ""
                    ? Container()
                    : SizedBox(
                        height: 1.h,
                      ),
                data.writerDetails?.about == ""
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          data.writerDetails?.about ??
                              'Simon & Schuster is the author of Macmillan Dictionary for Children,'
                                  ' a Simon & Schuster book',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                              ),
                        ),
                      ),
                SizedBox(
                  height: 1.h,
                ),
                (data.writerDetails?.tags ?? []).isEmpty
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tags',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontSize: 2.h,
                                      // color: Colors.grey.shade200,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                (data.writerDetails?.tags ?? []).isEmpty
                    ? Container()
                    : SizedBox(
                        height: 4.h,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: [
                            for (var i in data.writerDetails?.tags ?? [])
                              GestureDetector(
                                onTap: () {
                                  Navigation.instance.goBack();
                                  Navigation.instance.navigate('/searchWithTag',
                                      args: i.toString());
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                  ),
                                  child: Text(
                                    i.name ?? "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                SizedBox(
                  height: 2.h,
                ),
                (data.writerDetails?.awards ?? []).isEmpty
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Awards',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontSize: 2.h,
                                      // color: Colors.grey.shade200,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                (data.writerDetails?.awards ?? []).isEmpty
                    ? Container()
                    : SizedBox(
                        height: 4.h,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: [
                            for (var i in data.writerDetails?.awards ?? [])
                              GestureDetector(
                                onTap: () {
                                  Navigation.instance.goBack();
                                  Navigation.instance.navigate(
                                      '/searchWithAuthor',
                                      args: i.toString());
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: Text(
                                    i.name ?? "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                SizedBox(
                  height: 2.h,
                ),
                (data.writerDetails?.books
                                .where((element) =>
                                    element.book_format == "e-book")
                                .toList() ??
                            [])
                        .isEmpty
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Books',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontSize: 2.h,
                                      // color: Colors.grey.shade200,
                                    ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  'More >',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontSize: 1.5.h,
                                        color: Colors.blueAccent,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                (data.writerDetails?.books
                                .where((element) =>
                                    element.book_format == "e-book")
                                .toList() ??
                            [])
                        .isEmpty
                    ? Container()
                    : SizedBox(
                        height: 1.h,
                      ),
                (data.writerDetails?.books
                                .where((element) =>
                                    element.book_format == "e-book")
                                .toList() ??
                            [])
                        .isEmpty
                    ? Container()
                    : SizedBox(
                        height: 35.h,
                        child: ListView.builder(
                            itemCount: data.writerDetails?.books
                                .where((element) =>
                                    element.book_format == "e-book")
                                .length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (cont, count) {
                              var current = data.writerDetails?.books
                                  .where((element) =>
                                      element.book_format == "e-book")
                                  .toList()[count];
                              return BookItem(
                                data: current!,
                                index: count,
                                show: (data) {
                                  ConstanceData.show(context, data);
                                },
                              );
                            }),
                      ),
                SizedBox(
                  height: 2.h,
                ),
                if ((data.writerDetails?.books
                            .where(
                                (element) => element.book_format == "magazine")
                            .toList() ??
                        [])
                    .isEmpty)
                  Container()
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Magazines',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontSize: 2.h,
                                  // color: Colors.grey.shade200,
                                ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'More >',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontSize: 1.5.h,
                                    color: Colors.blueAccent,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                (data.writerDetails?.books
                                .where((element) =>
                                    element.book_format == "magazine")
                                .toList() ??
                            [])
                        .isEmpty
                    ? Container()
                    : SizedBox(
                        height: 1.h,
                      ),
                (data.writerDetails?.books
                                .where((element) =>
                                    element.book_format == "magazine")
                                .toList() ??
                            [])
                        .isEmpty
                    ? Container()
                    : SizedBox(
                        height: 35.h,
                        child: ListView.builder(
                            itemCount: data.writerDetails?.books
                                .where((element) =>
                                    element.book_format == "magazine")
                                .length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (cont, count) {
                              var current = data.writerDetails?.books
                                  .where((element) =>
                                      element.book_format == "magazine")
                                  .toList()[count];
                              return BookItem(
                                data: current!,
                                index: count,
                                show: (data) {
                                  ConstanceData.show(context, data);
                                },
                              );
                            }),
                      ),
              ],
            ),
          );
        }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => fetchDetails());
  }

  fetchDetails() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.fetchWriterDetails(
        widget.id.toString().split(",")[0], widget.id.toString().split(",")[1]);
    if (response.success ?? false) {
      Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setWriterDetails(response.writer_details);
    } else {
      Navigation.instance.goBack();
    }
  }
}
