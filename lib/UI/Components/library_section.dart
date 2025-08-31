import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:ebook/Model/library.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LibrarySection extends StatelessWidget {
  const LibrarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // View All button at top left
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [  SizedBox(
              width: 70.w,
              child: Text(
                "Libraries",
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 18.sp,
                ),
              ),
            ),
              GestureDetector(
                onTap: () {
                  Navigation.instance.navigate("/librarySearchScreen");
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black87,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    // mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "View All",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.yellow,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 3.w,
                        color: Colors.yellow,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 16.h,
          // Increased height to accommodate circular images and text
          width: double.infinity,
          child: Consumer<DataProvider>(builder: (context, data, _) {
            final list = data.publicLibraries;
            // Limit to only 3 libraries
            final limitedList = list.take(3).toList();

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: limitedList.length,
              itemBuilder: (context, index) {
                final library = limitedList[index];

                return GestureDetector(
                  onTap: () {
                    Navigation.instance.navigate("/libraryDetails", args: library.id);
                  },
                  child: Container(
                    width: 32.w,
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Circular image container
                        Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[200],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: _buildLibraryImage(library),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        // Title text
                        Text(
                          library.title,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ),
                        ),
                      ],
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

  Widget _buildLibraryImage(Library library) {
    // Check if profilePic or profilePicFile is available and not empty
    final imageUrl = library.profilePic.isNotEmpty
        ? library.profilePic
        : (library.profilePicFile?.isNotEmpty == true
            ? library.profilePicFile!
            : null);

    if (imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: 20.w,
        height: 20.w,
        fit: BoxFit.fill,
        placeholder: (context, url) => Container(
          color: Colors.grey[300],
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!),
            ),
          ),
        ),
        errorWidget: (context, url, error) => _buildFallbackImage(),
      );
    } else {
      return _buildFallbackImage();
    }
  }

  Widget _buildFallbackImage() {
    return Container(
      width: 20.w,
      height: 20.w,
      color: Colors.grey[300],
      child: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 12.w,
          height: 12.w,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.library_books,
              size: 6.w,
              color: Colors.grey[600],
            );
          },
        ),
      ),
    );
  }
}
