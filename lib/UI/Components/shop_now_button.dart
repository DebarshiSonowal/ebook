import 'package:flutter/material.dart';

import '../../Helper/navigator.dart';

class shopNowButton extends StatelessWidget {
  const shopNowButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 50.h,
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigation.instance.goBack();
          },
          style: ButtonStyle(
            backgroundColor:
            MaterialStateProperty.all(
                Colors.green),
            shape: MaterialStateProperty.all<
                RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(5.0),
                side: const BorderSide(
                    color: Colors.green),
              ),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Shop Now'),
          ),
        ),
      ),
    );
  }
}