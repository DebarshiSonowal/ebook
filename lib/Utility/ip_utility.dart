import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class IpUtility {
  IpUtility._();

  static Future<String?> getPublicIp() async {
    try {
      final dio = Dio();
      final response = await dio.get('https://api.ipify.org');
      if (response.statusCode == 200) {
        return response.data.toString();
      }
    } catch (e) {
      debugPrint('Error fetching public IP: $e');
    }
    return null;
  }
}
