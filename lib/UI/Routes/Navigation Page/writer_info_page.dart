import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Helper/navigator.dart';
import '../../../Storage/data_provider.dart';

class WritersInfoPage extends StatelessWidget {
  const WritersInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
         "Account Information",
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .headline1
              ?.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,

      ),
    );
  }
}
