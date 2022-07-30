import 'package:flutter/material.dart';

import '../../../Constants/constance_data.dart';

class Librarypage extends StatefulWidget {
  const Librarypage({Key? key}) : super(key: key);

  @override
  State<Librarypage> createState() => _LibrarypageState();
}

class _LibrarypageState extends State<Librarypage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ConstanceData.primaryColor,
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Text('Library'),
      ),
    );
  }
}
