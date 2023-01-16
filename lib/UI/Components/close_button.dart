import 'package:flutter/material.dart';

import '../../Constants/constance_data.dart';
import '../../Helper/navigator.dart';

class CloseButtonCustom extends StatelessWidget {
  const CloseButtonCustom({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ConstanceData.secondaryColor.withOpacity(0.97),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  Navigation.instance.goBack();
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}