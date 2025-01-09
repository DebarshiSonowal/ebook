import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:sizer/sizer.dart';

class winnerOf extends StatelessWidget {
  const winnerOf({
    Key? key,
    required this.i,
  }) : super(key: key);

  final i;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "# Winner of ",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 15.sp,
              ),
        ),
        Text(
          i.name ?? "",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.blueAccent,
                fontSize: 15.sp,
                // fontSize: 11.sp,
              ),
        ),
      ],
    );
  }
}
