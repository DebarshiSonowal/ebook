import 'package:ebook/Networking/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../Helper/navigator.dart';
import '../../../Model/home_banner.dart';

class NotificationBookListScreen extends StatefulWidget {
  const NotificationBookListScreen({super.key, required this.id});
  final int id;
  @override
  State<NotificationBookListScreen> createState() =>
      _NotificationBookListScreenState();
}

class _NotificationBookListScreenState
    extends State<NotificationBookListScreen> {
  bool isLoading = false;
  String title = "", headTitle = "";
  List<Book> books = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          headTitle,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.sp),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: books.length, // Replace with actual book count
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.7,
                      ),
                      itemBuilder: (context, index) {
                        final item = books[index];
                        return GestureDetector(
                          onTap: () {
                            Navigation.instance
                                .navigate('/bookInfo', args: item.id);
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 4,
                            shadowColor: Colors.black12,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12.0),
                                    ),
                                    child: Image.network(
                                      item.profile_pic ?? "",
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, progress) {
                                        if (progress == null) return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: progress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? progress
                                                        .cumulativeBytesLoaded /
                                                    progress.expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
                                        Icons.broken_image,
                                        size: 50,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 8.0),
                                  child: Text(
                                    item.title ?? "",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                )),
    );
  }

  void fetchNotificationBook() async {
    setState(() {
      isLoading = true;
    });
    final response =
        await ApiProvider.instance.getNotificationBookList(widget.id);
    if (response.success ?? false) {
      setState(() {
        books = response.books ?? [];
        title = response.title ?? "";
        headTitle = response.headTitle ?? "";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Books fetched successfully.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Books fetching failed.')),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => fetchNotificationBook());
  }
}
