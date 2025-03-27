import 'package:awesome_icons/awesome_icons.dart';
import 'package:ebook/Model/library_model.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:ebook/Storage/app_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Constants/constance_data.dart';
import '../../../Helper/navigator.dart';
import '../../../Model/library_book_details.dart';
import '../../../Storage/data_provider.dart';

class LibraryDetailsScreen extends StatefulWidget {
  const LibraryDetailsScreen({super.key, required this.id});
  final int id;
  @override
  State<LibraryDetailsScreen> createState() => _LibraryDetailsScreenState();
}

class _LibraryDetailsScreenState extends State<LibraryDetailsScreen> {
  LibraryResult? data;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchLibraryData();
    _loadLibraryDetails();
  }

  Future<void> fetchLibraryData() async {
    final response = await ApiProvider.instance.getPublicLibraryList();
    if (response.success) {
      Provider.of<DataProvider>(context, listen: false)
          .setPublicLibraries(response.result ?? []);
    } else {}
  }

  Future<void> _loadLibraryDetails() async {
    try {
      final response =
          await ApiProvider.instance.getPublicLibraryDetails(widget.id);
      if (!mounted) return;

      if (response.success && response.result != null) {
        setState(() {
          data = response.result!;
        });
      } else {
        _showSnackBar('Could not load library details');
      }
    } catch (e) {
      _showSnackBar('Failed to load library details');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red.shade800,
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        if (data?.profilePic.isNotEmpty == true)
          Hero(
            tag: 'library_${widget.id}',
            child: Container(
              height: 280,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(data!.profilePic),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5),
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
          ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.9),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetails() {
    return Container(
      // decoration: BoxDecoration(
      //   color: Colors.grey.shade900,
      //   borderRadius: BorderRadius.circular(20),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withOpacity(0.3),
      //       spreadRadius: 5,
      //       blurRadius: 7,
      //       offset: const Offset(0, 3),
      //     ),
      //   ],
      // ),
      margin: EdgeInsets.symmetric(
        horizontal: 2.w,
      ),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data?.title ?? '',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.sp,
                  color: Colors.white,
                ),
          ),
          SizedBox(height: 2.h),
          _buildInfoCard(
            icon: Icons.library_books,
            title: 'Library Type',
            content: data?.libraryType ?? '',
          ),
          SizedBox(height: 1.h),
          _buildInfoCard(
            icon: Icons.person,
            title: 'Owner',
            content: data?.ownerName ?? '',
          ),
          // _buildContactSection(),
          _buildButtons(),
          if (data?.about != null) _buildAboutSection(),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    if (content.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.symmetric(
        horizontal: 4.w,
        vertical: 1.5.h,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white70),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade800.withOpacity(0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 16),
          if (data?.mobile != null)
            _buildContactItem(Icons.phone, data?.mobile ?? ''),
          if (data?.whatsappNo != null)
            _buildContactItem(
                FontAwesomeIcons.whatsapp, data?.whatsappNo ?? ''),
          if (data?.email != null)
            _buildContactItem(Icons.email, data?.email ?? ''),
          if (data?.address != null)
            _buildContactItem(Icons.location_on, data?.address ?? ''),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade300),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.grey.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
          SizedBox(height: 1.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data?.about ?? '',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade300,
                  height: 1.6,
                ),
              ),
              if ((data?.about?.length ?? 0) > 100)
                Padding(
                  padding: EdgeInsets.only(top: 1.h),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.black,
                          title: Text(
                            'About',
                            style: TextStyle(
                              fontSize: 19.sp,
                              height: 1.6,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: SingleChildScrollView(
                            child: Text(
                              data?.about ?? '',
                              style: TextStyle(
                                fontSize: 14.sp,
                                height: 1.6,
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.blue.shade300,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(color: Colors.blue.shade300),
                                ),
                              ),
                              child: Text(
                                'Close',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text(
                      'Read more',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.blue.shade300,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildDetails(),
                  SizedBox(height: 1.h),
                  Consumer<DataProvider>(
                    builder: (context, data, _) {
                      if (data.publicLibraries.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'No books available',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Library Collection',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Navigate to view all books
                                    Navigation.instance.navigate(
                                        '/libraryBooks',
                                        args:
                                            data.publicLibraries.first.id ?? 0);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        'View All Books',
                                        style: TextStyle(
                                          color: Colors.blue.shade300,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.arrow_forward,
                                        size: 16.sp,
                                        color: Colors.blue.shade300,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 1.h),

                          // E-Books Section
                          _buildBookSection(
                            context,
                            "E-Books",
                            data.library
                                .where((e) =>
                                    e.book_format?.toLowerCase() == "e-book")
                                .toList(),
                          ),

                          // Magazines Section
                          _buildBookSection(
                            context,
                            "Magazines",
                            data.library
                                .where((e) =>
                                    e.book_format?.toLowerCase() == "magazine")
                                .toList(),
                          ),

                          // E-Notes Section
                          _buildBookSection(
                            context,
                            "E-Notes",
                            data.library
                                .where((e) =>
                                    e.book_format?.toLowerCase() == "e-note")
                                .toList(),
                          ),

                          const SizedBox(height: 30),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildBookSection(
      BuildContext context, String title, List<LibraryBookDetailsModel> books) {
    if (books.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return GestureDetector(
                onTap: () {
                  // Navigation.instance
                  //     .navigate('/bookDetailsScreen', args: book.id);
                  Navigation.instance.navigate('/bookInfo', args: book.id);
                },
                child: Container(
                  width: 120,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 4.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          child: book.profile_pic != null &&
                                  book.profile_pic!.isNotEmpty
                              ? Image.network(
                                  book.profile_pic!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey.shade700,
                                      child: const Icon(
                                        Icons.book,
                                        color: Colors.white54,
                                        size: 40,
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  color: Colors.grey.shade700,
                                  child: const Icon(
                                    Icons.book,
                                    color: Colors.white54,
                                    size: 40,
                                  ),
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          book.title ?? 'Untitled',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void fetchData() async {
    // Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getLibraryBookList(widget.id);
    if (response.status ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setLibraryBooks(response.details ?? []);
      // Navigation.instance.goBack();
    } else {
      // Navigation.instance.goBack();
    }
  }

  Widget _buildButtons() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              (data?.memberRequestUrl != null &&
                      data?.memberRequestUrl.isNotEmpty == true &&
                      (data?.is_member ?? 0) == 0)
                  ? Expanded(
                      child: _buildActionButton(
                        icon: Icons.person_add,
                        label: 'Become a Member',
                        onTap: () {
                          if (Storage.instance.isLoggedIn) {
                            launch(Uri.parse(data!.memberRequestUrl));
                          } else {
                            ConstanceData.showAlertDialog(context);
                          }
                        },
                        color: Colors.blue.shade700,
                      ),
                    )
                  : Container(),
              const SizedBox(width: 12),
              data?.bookPublishRequestUrl != null &&
                      data!.bookPublishRequestUrl.isNotEmpty
                  ? Expanded(
                      child: _buildActionButton(
                        icon: Icons.upload_file,
                        label: 'Publish Book',
                        onTap: () {
                          if (Storage.instance.isLoggedIn) {
                            launch(Uri.parse(data!.bookPublishRequestUrl));
                          } else {
                            ConstanceData.showAlertDialog(context);
                          }
                        },
                        color: Colors.green.shade700,
                      ),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> launch(Uri url) async {
    if (!await canLaunchUrl(url)) {
      _showSnackBar('Could not open the link');
      return;
    }
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      _showSnackBar('Failed to open link: ${e.toString()}');
    }
  }
}
