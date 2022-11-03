import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Model/writer.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Components/book_item.dart';

class WriterInfo extends StatefulWidget {
  final int id;

  WriterInfo(this.id);

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
                    data.writerDetails?.name ?? "",
                    data.writerDetails?.profile_pic ?? "",
                    data.writerDetails?.salutation ?? "",
                    data.writerDetails?.contributor_name ?? ""),
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  'About',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                      fontSize: 2.5.h,
                      // color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    data.writerDetails?.about ??
                        'Simon & Schuster is the author of Macmillan Dictionary for Children,'
                            ' a Simon & Schuster book',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tags',
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    fontSize: 2.h,
                                    // color: Colors.grey.shade200,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 4.h,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (var i in data.writerDetails?.tags ?? [])
                        GestureDetector(
                          onTap: () {
                            Navigation.instance.goBack();
                            Navigation.instance
                                .navigate('/searchWithTag', args: i.toString());
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Text(
                              i.name ?? "",
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Awards',
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    fontSize: 2.h,
                                    // color: Colors.grey.shade200,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 4.h,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (var i in data.writerDetails?.awards ?? [])
                        GestureDetector(
                          onTap: () {
                            Navigation.instance.goBack();
                            Navigation.instance.navigate('/searchWithAuthor',
                                args: i.toString());
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Text(
                              i.name ?? "",
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Books by ${data.writerDetails?.name}',
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    fontSize: 2.h,
                                    // color: Colors.grey.shade200,
                                  ),
                        ),
                        Text(
                          'More >',
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    fontSize: 1.5.h,
                                    color: Colors.blueAccent,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                SizedBox(
                  height: 35.h,
                  child: ListView.builder(
                      itemCount: data.writerDetails?.books.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (cont, count) {
                        var current = data.writerDetails?.books[count];
                        return BookItem(data: current!, index: count);
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
    final response = await ApiProvider.instance.fetchWriterDetails(widget.id);
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

class WriterAccountHome extends StatelessWidget {
  final String name, picture, saluation, contributor;

  WriterAccountHome(this.name, this.picture, this.saluation, this.contributor);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 30.h,
      color: Colors.grey.shade900,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.network(
                      picture,
                      height: 10.h,
                      width: 20.w,
                    ) ??
                    Image.asset(
                      'assets/images/user.png',
                      fit: BoxFit.fill,
                      height: 10.h,
                      width: 20.w,
                    ),
              ),
              Container(
                padding: EdgeInsets.all(4),
                color: Colors.white,
                child: Text(
                  contributor ?? 'AUTHOR',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                      fontSize: 1.5.h,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            "${saluation} ${name}" ?? 'Simon & Schuster',
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  fontSize: 2.h,
                ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Text(
            '1 TITLE',
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  fontSize: 1.5.h,
                ),
          ),
        ],
      ),
    );
  }
}
