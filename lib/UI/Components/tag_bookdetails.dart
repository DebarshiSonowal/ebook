import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:sizer/sizer.dart';

class Tag_BookDetails extends StatelessWidget {
  const Tag_BookDetails({
    Key? key,
    required this.i,
  }) : super(key: key);

  final i;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Text(
        i.name ?? "",
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}
