import 'package:flutter/material.dart' hide ModalBottomSheetRoute;

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
              .displayLarge
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
