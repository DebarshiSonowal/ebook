import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Model/book_category.dart';
import '../Model/book_details.dart';
import '../Model/book_format.dart';
import '../Model/generic_response.dart';
import '../Model/home_banner.dart';
import '../Model/home_section.dart';

class ApiProvider {
  ApiProvider._();

  static final ApiProvider instance = ApiProvider._();

  final String baseUrl = "https://tratri.in/api";
  final String path = "/books";

  Dio? dio;

  BaseOptions option =
      BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    // 'APP-KEY': ConstanceData.app_key
  });

  Future<BookFormatResponse> fetchBookFormat() async {
    var url = "${baseUrl}${path}/formats";
    dio = Dio(option);
    debugPrint(url.toString());

    try {
      Response? response = await dio?.get(url);
      debugPrint("book format response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return BookFormatResponse.fromJson(response?.data);
      } else {
        debugPrint("book format error: ${response?.data}");
        return BookFormatResponse.withError(
            response?.data['message'] ?? "Something went wrong");
      }
    } on DioError catch (e) {
      debugPrint("book format response: ${e.response}");
      return BookFormatResponse.withError(e.message.toString());
    }
  }

  Future<BookCategoryResponse> fetchBookCategory(String format) async {
    var url = "${baseUrl}$path/categories/${format}";
    dio = Dio(option);
    debugPrint(url.toString());
    try {
      Response? response = await dio?.get(url.toString());
      debugPrint("book category response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return BookCategoryResponse.fromJson(response?.data);
      } else {
        debugPrint("book category error: ${response?.data}");
        return BookCategoryResponse.withError(
            response?.data['message'] ?? "Something went wrong");
      }
    } on DioError catch (e) {
      debugPrint("book category response: ${e.response}");
      return BookCategoryResponse.withError(e.message.toString());
    }
  }

  Future<HomeBannerResponse> fetchHomeBanner(String format) async {
    var url = "${baseUrl}$path/home-banners/${format}";
    dio = Dio(option);
    debugPrint(url.toString());
    try {
      Response? response = await dio?.get(url.toString());
      debugPrint("home-banners response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return HomeBannerResponse.fromJson(response?.data);
      } else {
        debugPrint("home-banners error: ${response?.data}");
        return HomeBannerResponse.withError(
            response?.data['message'] ?? "Something went wrong");
      }
    } on DioError catch (e) {
      debugPrint("home-banners response: ${e.response}");
      return HomeBannerResponse.withError(e.message.toString());
    }
  }

  Future<HomeSectionResponse> fetchHomeSections(String format) async {
    var url = "${baseUrl}$path/home-sections/${format}";
    dio = Dio(option);
    debugPrint(url.toString());
    try {
      Response? response = await dio?.get(url.toString());
      debugPrint("home-sections response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return HomeSectionResponse.fromJson(response?.data);
      } else {
        debugPrint("home-sections error: ${response?.data}");
        return HomeSectionResponse.withError(
            response?.data['message'] ?? "Something went wrong");
      }
    } on DioError catch (e) {
      debugPrint("home-sections response: ${e.response}");
      return HomeSectionResponse.withError(e.message.toString());
    }
  }

  Future<BookDetailsResponse> fetchBookDetails(String id) async {
    var url = "${baseUrl}$path/detail/${id}";
    dio = Dio(option);
    debugPrint(url.toString());
    try {
      Response? response = await dio?.get(url.toString());
      debugPrint("BookDetails response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return BookDetailsResponse.fromJson(response?.data);
      } else {
        debugPrint("BookDetails error: ${response?.data}");
        return BookDetailsResponse.withError(
            response?.data['message'] ?? "Something went wrong");
      }
    } on DioError catch (e) {
      debugPrint("BookDetails response: ${e.response}");
      return BookDetailsResponse.withError(e.message.toString());
    }
  }
}
