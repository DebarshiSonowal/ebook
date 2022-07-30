import 'package:awesome_icons/awesome_icons.dart';
import 'package:ebook/Model/review.dart';

import 'package:flutter/material.dart';

import '../Model/book.dart';
import '../Model/category.dart';

class ConstanceData {
  static const primaryColor = Colors.black;
  static const secondaryColor = Color(0xff0E0E0E);
  static const cardColor = Color(0xff6E10BB);
  static const fontFamily = 'SF';
  static const primaryFont =
      'assets/fonts/assets/fonts/SF-Pro-Display-Regular.otf';
  static const secondaryFont =
      'assets/fonts/assets/fonts/SF-Pro-Display-Semibold.otf';

  static const splashTime = 5;

  static const optionList = ['e-books', 'books'];

  static final iconList = [
    Category('Motivation', FontAwesomeIcons.flag),
    Category('Horror', FontAwesomeIcons.skullCrossbones),
    Category('Love', FontAwesomeIcons.heart),
    Category('All', FontAwesomeIcons.boxes),
  ];

  static const pages = [
    'Account Information',
    'FAQs & Support',
    'Audio Player Settings',
    'Language Preference',
    'Downloads',
    'Notification Settings',
    'Privacy',
    'Invite Friends',
    'Open Source Licenses',
  ];

  static const banner = [
    "https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1740&q=80",
    "https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1740&q=80",
    "https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1740&q=80"
  ];

  static final bestselling = [
    Book(
        'Principles of Economics',
        'Adam Smith',
        'https://images.unsplash.com/photo-1585624882829-f92c2d4cd89d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8dGVzdGluZ3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60',
        4.5),
    Book(
        'Engineering Mathematics',
        'Ambeshwar Phukan',
        'https://images.unsplash.com/photo-1596496181848-3091d4878b24?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fHRlc3Rpbmd8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60',
        5),
    Book(
        'Let\' Us C',
        'Unknown',
        'https://images.unsplash.com/photo-1600267204026-85c3cc8e96cd?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTh8fHRlc3Rpbmd8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60',
        4),
    Book(
        'Flutter',
        'Google',
        'https://images.unsplash.com/photo-1528845922818-cc5462be9a63?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjB8fHRlc3Rpbmd8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60',
        3),
  ];

  static final critics = [
    Book(
        'Lord of the rings',
        'CJlewis',
        'https://cdn.pixabay.com/photo/2019/03/01/18/32/night-4028339__340.jpg',
        4.9),
    Book(
        'Harry Potter',
        'JKRowling',
        'https://cdn.pixabay.com/photo/2019/08/02/14/41/fantasy-4379818__340.jpg',
        4.7),
    Book(
        'Chronicles of Narnia',
        'CJlewis',
        'https://cdn.pixabay.com/photo/2020/03/15/13/49/temple-4933682__480.jpg',
        4.4),
    Book(
        'Game of Thrones',
        'A.Singh',
        'https://cdn.pixabay.com/photo/2018/02/21/09/35/steampunk-3169877__480.jpg',
        4.1),
  ];

  static final category = ['All', 'Love', 'Horror', 'Motivation'];

  static const primaryIcon = 'assets/images/ebook.png';
  static const humanImage = 'assets/images/user.png';
  static const emptyImage = 'assets/images/shelves.png';
  static const searchIcon = FontAwesomeIcons.search;
  static const homeIcon = FontAwesomeIcons.home;
  static const libraryIcon = FontAwesomeIcons.book;
  static const storeIcon = FontAwesomeIcons.shoppingCart;
  static const moreIcon = FontAwesomeIcons.hamburger;

  static final reviews=[
    Review(
      'Dek','Great books', 4.5,
    ),
    Review(
      'Dek1','Great books1', 4.1,
    ),
    Review(
      'Dek2','Great books2', 4.3,
    ),
    Review(
      'Dek4','Great books6', 4.6,
    ),
  ];

  static const categories=[
    'Motivation',
    'Novel',
    'Love',
    'Children',
    // 'More ->'
  ];

  static const testing="Lorem Ipsum is simply dummy text of the printing and typesetting industry."
      " Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,"
      " when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";
}
