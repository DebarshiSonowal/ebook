import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook/Model/bookmark.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;

import '../../Model/home_banner.dart';
import '../../Storage/data_provider.dart';

class LibraryCardItem extends StatelessWidget {
  const LibraryCardItem(
      {Key? key,
      required this.data,
      required this.count,
      required this.filteredList,
      required this.filteredBookmarkList})
      : super(key: key);
  final DataProvider data;
  final int count;
  final List<Book> filteredList;
  final List<BookmarkItem> filteredBookmarkList;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: CachedNetworkImage(
        imageUrl: data.libraryTab == 0
            ? filteredList[count].profile_pic ?? ""
            : filteredBookmarkList[count].profile_pic ?? "",
        fit: BoxFit.fill,
      ),
    );
  }
}
