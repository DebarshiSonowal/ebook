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
    _loadLibraryDetails();
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
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
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
          const SizedBox(height: 32),
          _buildInfoCard(
            icon: Icons.library_books,
            title: 'Library Type',
            content: data?.libraryType ?? '',
          ),
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
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
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
          const SizedBox(width: 16),
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
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
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
          const SizedBox(height: 12),
          Text(
            data?.about ?? '',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade300,
              height: 1.6,
            ),
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
                  const SizedBox(height: 20),
                  Consumer<DataProvider>(
                    builder: (context, data, _) {
                      if (data.libraries.isEmpty) {
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'Library Collection',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

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
                  Navigation.instance
                      .navigate('/bookDetailsScreen', args: book.id);
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
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Services',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              (data?.memberRequestUrl != null && (data?.is_member ?? 0) == 0)
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
              data?.bookPublishRequestUrl != null
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
        padding: EdgeInsets.symmetric(vertical: 2.h),
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
            Icon(
              icon,
              color: Colors.white,
              size: 21.sp,
            ),
            SizedBox(height: 2.w),
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
