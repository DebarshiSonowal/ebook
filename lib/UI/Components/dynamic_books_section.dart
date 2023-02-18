import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Constants/constance_data.dart';
import '../../Storage/data_provider.dart';
import 'books_section.dart';

class DynamicBooksSection extends StatelessWidget {
  const DynamicBooksSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (cont, index) {
          return Consumer<DataProvider>(
              builder: (context, data, _) {
                return BooksSection(
                  title:
                  data.homeSection![data.currentTab][index].title ??
                      'Bestselling Books',
                  list:
                  data.homeSection![data.currentTab][index].book ??
                      [],
                  show: (data) {
                    ConstanceData.show(context, data);
                  },
                );
              });
        },
        separatorBuilder: (cont, ind) {
          return SizedBox(
            height: 0.1.h,
          );
        },
        itemCount: Provider.of<DataProvider>(context)
            .homeSection![
        Provider.of<DataProvider>(context).currentTab]
            .length);
  }
}