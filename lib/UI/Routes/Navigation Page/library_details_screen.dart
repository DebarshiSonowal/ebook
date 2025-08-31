import 'package:ebook/Model/library_model.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:ebook/Storage/app_storage.dart';
import 'package:ebook/Utility/share_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
  bool _showReviewForm = false;
  final _reviewController = TextEditingController();
  double _rating = 5.0;
  bool _isSubmittingReview = false;

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

  void _showSnackBar(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor:
            isSuccess ? Colors.green.shade700 : Colors.red.shade800,
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
                    Colors.black.withOpacity(0.2),
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
                  Colors.black.withOpacity(0.3),
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
          SizedBox(height: 1.h),
          Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.amber,
                size: 20.sp,
              ),
              SizedBox(width: 2.w),
              Text(
                data?.averageRating ?? '0.0',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ), 
              Text(
                ' / 5.0',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade400,
                ),
              ),
              SizedBox(width: 4.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  data?.libraryType ?? '',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          _buildStatsRow(),
          SizedBox(height: 2.h),
          _buildInfoCard(
            icon: Icons.person,
            title: 'Owner',
            content: data?.ownerName ?? '',
          ),
          _buildButtons(),
          if (data?.about != null) _buildAboutSection(),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            icon: Icons.menu_book,
            count: '${data?.noOfBooks ?? 0}',
            label: 'Books',
          ),
        ),
        Expanded(
          child: _buildStatItem(
            icon: Icons.group,
            count: '${data?.totalMembers ?? 0}',
            label: 'Members',
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String count,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.blue.shade300,
          size: 20.sp,
        ),
        SizedBox(width: 3.w),
        Text(
          count,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey.shade400,
          ),
        ),
      ],
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
  void dispose() {
    _reviewController.dispose();
    super.dispose();
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
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              _shareLibrary();
            },
          ),
        ],
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
                    builder: (context, listData, _) {
                      if (data == null || listData.library.isEmpty) {
                        return const SizedBox.shrink();
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
                                    Navigation.instance.navigate(
                                        '/libraryBooks',
                                        args:
                                            data?.id?? 0);
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
                          _buildBookSection(
                            context,
                            "E-Books", 
                            listData.library
                                .where((e) =>
                                    e.book_format?.toLowerCase() == "e-book")
                                .toList(),
                          ),
                          _buildBookSection(
                            context,
                            "Magazines",
                            listData.library
                                .where((e) =>
                                    e.book_format?.toLowerCase() == "magazine")
                                .toList(),
                          ),
                          _buildBookSection(
                            context,
                            "E-Notes",
                            listData.library
                                .where((e) =>
                                    e.book_format?.toLowerCase() == "e-note")
                                .toList(),
                          ),
                        ],
                      );
                    },
                  ),
                  // Reviews Section
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.reviews,
                                  color: Colors.blue.shade300,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  'Reviews (${data?.totalReview ?? 0})',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            if (data?.showReviewForm == true &&
                                Storage.instance.isLoggedIn)
                              ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _showReviewForm = !_showReviewForm;
                                  });
                                },
                                icon: Icon(
                                  _showReviewForm
                                      ? Icons.close
                                      : Icons.rate_review,
                                  size: 16.sp,
                                ),
                                label: Text(
                                  _showReviewForm ? 'Cancel' : 'Write Review',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _showReviewForm
                                      ? Colors.red.shade600
                                      : Colors.amber.shade700,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 1.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (_showReviewForm && data?.showReviewForm == true)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
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
                            'Leave a Review',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Rating',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Row(
                            children: [
                              RatingBar.builder(
                                initialRating: _rating,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemSize: 7.w,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 1.w),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  setState(() {
                                    _rating = rating;
                                  });
                                },
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                '${_rating.toStringAsFixed(1)} / 5.0',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Your Review',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          TextField(
                            controller: _reviewController,
                            maxLines: 4,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                            decoration: InputDecoration(
                              hintText:
                                  'Share your thoughts about this library...',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 13.sp,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade700,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 2.h),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _isSubmittingReview
                                      ? null
                                      : () async {
                                          if (_reviewController.text
                                              .trim()
                                              .isEmpty) {
                                            _showSnackBar(
                                                'Please write a review');
                                            return;
                                          }

                                          setState(() {
                                            _isSubmittingReview = true;
                                          });
                                          final response = await ApiProvider
                                              .instance
                                              .addLibraryReview(
                                                  _reviewController.text.trim(),
                                                  _rating,
                                                  widget.id);
                                          if (response.status ?? false) {
                                            _showSnackBar(
                                                'Review submitted successfully!',
                                                isSuccess: true);
                                            setState(() {
                                              _showReviewForm = false;
                                              _reviewController.clear();
                                              _rating = 5.0;
                                              _isSubmittingReview = false;
                                            });
                                            await _loadLibraryDetails();
                                          } else {
                                            _showSnackBar(response.message ??
                                                'Failed to submit review');
                                            setState(() {
                                              _isSubmittingReview = false;
                                            });
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade600,
                                    foregroundColor: Colors.white,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 1.5.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: _isSubmittingReview
                                      ? CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : Text(
                                          'Submit Review',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 2.h),
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
    final response = await ApiProvider.instance.getLibraryBookList(widget.id);
    if (response.status ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setLibraryBooks(response.details ?? []);
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
              if ((data?.memberRequestUrl != null &&
                      data?.memberRequestUrl.isNotEmpty == true &&
                      (data?.is_member ?? 0) == 0) &&
                  (data?.bookPublishRequestUrl != null &&
                      data!.bookPublishRequestUrl.isNotEmpty))
                const SizedBox(width: 8),
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
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Loading..."),
              ],
            ),
          );
        },
      );

      // Launch with in-app web view (no URL bar)
      await launchUrl(
        url,
        mode: LaunchMode.inAppWebView,
        webViewConfiguration: WebViewConfiguration(
          enableJavaScript: true,
          enableDomStorage: true,
          headers: {
            'User-Agent':
                'Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36',
          },
        ),
      );

      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      // Close loading dialog on error
      if (mounted) {
        Navigator.of(context).pop();
        _showSnackBar('Failed to load content');
      }
    }
  }

  void _shareLibrary() async {
    if (data == null) return;

    try {
      final shareUrl = 'https://tratri.in/link?format=library&id=${data!.id}';

      await ShareHelper.shareText(shareUrl, context: context);
    } catch (e) {
      debugPrint('Error sharing library: $e');
      _shareWithFallback();
    }
  }

  void _shareWithFallback() async {
    if (data == null) return;

    try {
      // Enhanced fallback with better formatting for social media
      final shareText = '''
📚 ${data!.title ?? "Amazing Library"}

Discover thousands of books, magazines, and e-notes in our digital library!

🔗 Open Library: https://tratri.in/link?format=library&id=${data!.id}

📱 Get the App: https://play.google.com/store/apps/details?id=com.tsinfosec.ebook.ebook

#DigitalLibrary #eBooks #Learning
''';

      await ShareHelper.shareText(shareText, context: context);
    } catch (e) {
      debugPrint('Error in fallback sharing: $e');
      // Ultimate fallback
      await ShareHelper.shareText(
        '📚 Check out our digital library! https://tratri.in/link?format=library&id=${data!.id} \n\nDownload the app: https://play.google.com/store/apps/details?id=com.tsinfosec.ebook.ebook',
        context: context,
      );
    }
  }
}
