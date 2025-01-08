import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import '../../Constants/constance_data.dart';
import 'package:sizer/sizer.dart';

import '../../Helper/navigator.dart';

class TypeBar extends StatefulWidget {
  const TypeBar({Key? key}) : super(key: key);

  @override
  State<TypeBar> createState() => _TypeBarState();
}

class _TypeBarState extends State<TypeBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 4.h,
      child: Row(
        children: [
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (var i in ConstanceData.optionList)
                  Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Text(
                      i,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigation.instance.navigate('/categories');
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Text(
                'All Categories',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
