import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareHelper {
  /// Share text content with iOS-compatible positioning
  static Future<ShareResult> shareText(
    String text, {
    String? subject,
    BuildContext? context,
    Rect? sharePositionOrigin,
  }) async {
    if (Platform.isIOS) {
      // For iOS, we MUST provide sharePositionOrigin
      Rect rect;

      if (sharePositionOrigin != null) {
        rect = sharePositionOrigin;
      } else {
        // Use a safe default position that should always work
        rect = _getSafeDefaultPosition(context);
      }

      debugPrint("iOS Share position: $rect");

      return await Share.share(
        text,
        subject: subject,
        sharePositionOrigin: rect,
      );
    } else {
      // For Android and other platforms
      return await Share.share(
        text,
        subject: subject,
      );
    }
  }

  /// Share URL with iOS-compatible positioning
  static Future<ShareResult> shareUri(
    Uri uri, {
    BuildContext? context,
    Rect? sharePositionOrigin,
  }) async {
    if (Platform.isIOS) {
      // For iOS, we MUST provide sharePositionOrigin
      Rect rect;

      if (sharePositionOrigin != null) {
        rect = sharePositionOrigin;
      } else {
        // Use a safe default position that should always work
        rect = _getSafeDefaultPosition(context);
      }

      return await Share.shareUri(
        uri,
        sharePositionOrigin: rect,
      );
    } else {
      // For Android and other platforms
      return await Share.shareUri(uri);
    }
  }

  /// Get a valid share position from context
  static Rect _getValidSharePosition(BuildContext context) {
    try {
      final box = context.findRenderObject() as RenderBox?;
      if (box != null && box.hasSize) {
        final position = box.localToGlobal(Offset.zero);
        final size = box.size;

        // Ensure we have valid dimensions
        if (size.width > 0 && size.height > 0) {
          return Rect.fromLTWH(
            position.dx,
            position.dy,
            size.width,
            size.height,
          );
        }
      }
    } catch (e) {
      debugPrint('Error getting share position from context: $e');
    }

    // Fallback to default position
    return _getDefaultSharePosition();
  }

  /// Get default share position for iOS (center of screen with reasonable size)
  static Rect _getDefaultSharePosition() {
    // Use a reasonable default that should work on most devices
    return const Rect.fromLTWH(
      100, // x position
      200, // y position
      200, // width
      100, // height
    );
  }

  /// Get a safe default position that should work on all iOS devices
  static Rect _getSafeDefaultPosition(BuildContext? context) {
    if (context != null) {
      try {
        final mediaQuery = MediaQuery.of(context);
        final screenWidth = mediaQuery.size.width;
        final screenHeight = mediaQuery.size.height;
        final safeAreaTop = mediaQuery.padding.top;

        // Position the share popup in the upper-right area, but safely within bounds
        return Rect.fromLTWH(
          screenWidth * 0.5, // Center horizontally
          safeAreaTop + 100, // Below safe area + some padding
          screenWidth * 0.4, // 40% of screen width
          100, // Fixed height
        );
      } catch (e) {
        debugPrint('Error getting screen dimensions: $e');
      }
    }

    // Ultimate fallback - should work on all devices
    return const Rect.fromLTWH(200, 200, 300, 100);
  }

  /// Validate and fix rect dimensions to ensure they're non-zero
  static Rect _validateRect(Rect rect) {
    double x = rect.left;
    double y = rect.top;
    double width = rect.width;
    double height = rect.height;

    // Ensure non-zero, positive dimensions
    if (width <= 0) width = 200;
    if (height <= 0) height = 100;

    // Ensure position is reasonable (not negative)
    if (x < 0) x = 100;
    if (y < 0) y = 200;

    return Rect.fromLTWH(x, y, width, height);
  }

  /// Convenience method for app bar share buttons
  static Future<ShareResult> shareFromAppBar(
    String text, {
    required BuildContext context,
    String? subject,
  }) async {
    if (Platform.isIOS) {
      final mediaQuery = MediaQuery.of(context);
      final screenWidth = mediaQuery.size.width;
      final safeAreaTop = mediaQuery.padding.top;

      // Position near the typical app bar share button location
      final rect = Rect.fromLTWH(
        screenWidth - 150, // Near right edge
        safeAreaTop + kToolbarHeight / 2, // Middle of app bar height
        100, // Width
        50, // Height
      );

      return await shareText(
        text,
        subject: subject,
        context: context,
        sharePositionOrigin: rect,
      );
    } else {
      return await shareText(text, subject: subject, context: context);
    }
  }

  /// Convenience method for floating action buttons or bottom buttons
  static Future<ShareResult> shareFromBottom(
    String text, {
    required BuildContext context,
    String? subject,
  }) async {
    if (Platform.isIOS) {
      final mediaQuery = MediaQuery.of(context);
      final screenWidth = mediaQuery.size.width;
      final screenHeight = mediaQuery.size.height;

      // Position in bottom area
      final rect = Rect.fromLTWH(
        screenWidth * 0.3, // Center-ish horizontally
        screenHeight - 200, // Near bottom
        screenWidth * 0.4, // 40% width
        100, // Height
      );

      return await shareText(
        text,
        subject: subject,
        context: context,
        sharePositionOrigin: rect,
      );
    } else {
      return await shareText(text, subject: subject, context: context);
    }
  }

  /// Legacy method - now just calls shareText
  @deprecated
  static Rect? getSharePositionFromContext(BuildContext context) {
    return _getSafeDefaultPosition(context);
  }

  /// Legacy method - now just calls _getSafeDefaultPosition
  @deprecated
  static Rect getDefaultSharePosition([BuildContext? context]) {
    return _getSafeDefaultPosition(context);
  }
}
