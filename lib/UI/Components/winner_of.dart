import 'package:flutter/material.dart' hide ModalBottomSheetRoute;

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
        Text("# Winner of ", style: Theme.of(context).textTheme.headlineSmall
            // ?.copyWith(fontSize: 11.sp),
            ),
        Text(
          i.name ?? "",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.blueAccent,
                // fontSize: 11.sp,
              ),
        ),
      ],
    );
  }
}
