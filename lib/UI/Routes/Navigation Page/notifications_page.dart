import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../Model/notification_model.dart';
import '../../../Storage/app_storage.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 2.w,
          vertical: 1.h,
        ),
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return ListView.separated(
            itemBuilder: (context, index) {
              final item = data.notifications[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  onTap: () async {
                    if (Storage.instance.isLoggedIn) {
                      read(item?.id, item);
                    } else {
                      if (item.data?.type == "book-list") {
                        var result = await Navigation.instance.navigate(
                            '/notificationBookList',
                            args: item.data?.id);
                        if (result != null) {
                          fetchNotifications();
                        } else {
                          fetchNotifications();
                        }
                      } else {
                        var result = await Navigation.instance
                            .navigate('/bookInfo', args: item.data?.id);
                        if (result != null) {
                          fetchNotifications();
                        } else {
                          fetchNotifications();
                        }
                      }
                    }
                    // if (item.data?.bookFormat == "e-book") {
                    //   Navigation.instance.navigate(path);
                    // } else if (item.data?.bookFormat == "e-note") {
                    //
                    // } else {
                    //
                    // }
                  },
                  contentPadding: EdgeInsets.all(2.w),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (item.data?.type ?? 'UNKNOWN TYPE')
                            .toUpperCase()
                            .replaceAll('-', ' '),
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      SizedBox(
                        width: 70.w,
                        child: Text(
                          "${item.data?.title}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 1.h),
                      Text(
                        item.data?.contributorName == null
                            ? ""
                            : "লেখক: ${item.data?.contributorName}",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16.sp,
                        ),
                      ),
                      item.data?.releasedDate == null
                          ? Container()
                          : SizedBox(height: 0.5.h),
                      Text(
                        item.data?.releasedDate == null
                            ? ""
                            : "প্ৰকাশ: ${item.data?.releasedDate}",
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    item.data?.bookFormat == "e-note"
                        ? Icons.note_alt_sharp
                        : item.data?.bookFormat == "magazine"
                            ? Icons.book_online_sharp
                            : Icons.book,
                    color: Colors.amber,
                    size: 24.sp,
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 1.5.h,
              );
            },
            itemCount: data.notifications.length,
          );
        }),
      ),
    );
  }

  void fetchNotifications() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );

    final response = await ApiProvider.instance
        .fetchNotification(Storage.instance.isLoggedIn);

    Navigator.pop(context); // Dismiss loader

    if (response.success ?? false) {
      Provider.of<DataProvider>(context, listen: false)
          .setNotifications(response.result ?? []);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Notifications fetched successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message ?? 'Failed to fetch notifications'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => fetchNotifications());
  }

  void read(String? id, NotificationItem item) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );

    final response = await ApiProvider.instance.markAsRead(id);

    Navigator.pop(context); // Dismiss loader

    if (response.status ?? false) {
      debugPrint("${item.type}");
      if (item.data?.type == "book-list") {
        var result = await Navigation.instance
            .navigate('/notificationBookList', args: item.data?.id);
        if (result != null) {
          fetchNotifications();
        } else {
          fetchNotifications();
        }
      } else {
        var result = await Navigation.instance
            .navigate('/bookInfo', args: item.data?.id);
        if (result != null) {
          fetchNotifications();
        } else {
          fetchNotifications();
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message ?? 'Failed to mark as read'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
