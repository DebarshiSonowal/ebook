import 'package:ebook/Storage/common_provider.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Constants/constance_data.dart';
import '../../Model/home_section.dart';
import '../../Storage/data_provider.dart';
import 'books_section.dart';

class DynamicBooksSection extends StatelessWidget {
  const DynamicBooksSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<CommonProvider, DataProvider>(
      builder: (context, commonData, dataProvider, _) {
        List<HomeSection> currentSection = [];

        switch (dataProvider.currentTab) {
          case 0:
            currentSection = commonData.eBookSection;
            break;
          case 1:
            currentSection = commonData.magazineSection;
            break;
          case 2:
            currentSection = commonData.eNotesSection;
            break;
        }

        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (cont, index) {
            return BooksSection(
              title: currentSection[index].title ?? 'Bestselling Books',
              list: currentSection[index].book ?? [],
              show: (data) {
                ConstanceData.show(context, data);
              },
            );
          },
          separatorBuilder: (cont, ind) {
            return SizedBox(
              height: 0.1.h,
            );
          },
          itemCount: currentSection.length,
        );
      },
    );
  }
}

class DynamicEnotesSection extends StatelessWidget {
  const DynamicEnotesSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, _) {
        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (cont, index) {
            return BooksSection(
              title: dataProvider.enotesSection[index].title ??
                  'Bestselling Books',
              list: dataProvider.enotesSection[index].books ?? [],
              show: (data) {
                ConstanceData.show(context, data);
              },
            );
          },
          separatorBuilder: (cont, ind) {
            return SizedBox(
              height: 0.1.h,
            );
          },
          itemCount: dataProvider.enotesSection.length,
        );
      },
    );
  }
}
