import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class LibrarySection extends StatelessWidget {
  const LibrarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 2.w),
        //   child: SizedBox(
        //     width: 80.w,
        //     child: Text(
        //       "Libraries",
        //       overflow: TextOverflow.ellipsis,
        //       maxLines: 2,
        //       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        //             color: Colors.white,
        //             fontSize: 16.sp,
        //           ),
        //     ),
        //   ),
        // ),
        SizedBox(
          height: 2.h,
        ),
        SizedBox(
          height: 5.h,
          width: double.infinity,
          child: Consumer<DataProvider>(builder: (context, data, _) {
            final list = data.publicLibraries;
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: list.length + 1, // +1 for the "All" item
              itemBuilder: (context, index) {
                // First item is "All"
                if (index == 0) {
                  return GestureDetector(
                    onTap: () {
                      Navigation.instance.navigate("/librarySearchScreen");
                    },
                    child: Container(
                      width: 40.w,
                      margin: EdgeInsets.symmetric(horizontal: 1.w),
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.4.h),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "All libraries",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }
                // Regular library items (index - 1 because of the "All" item)
                final libraryIndex = index - 1;
                return GestureDetector(
                  onTap: () {
                    Navigation.instance.navigate("/libraryDetails",
                        args: list[libraryIndex].id);
                  },
                  child: Container(
                    width: 40.w,
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.4.h),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        list[libraryIndex].title,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
