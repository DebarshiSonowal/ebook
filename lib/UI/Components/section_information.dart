import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class SectionInformation extends StatelessWidget {
  final String name;
  final String data;
  final TextEditingController controller;
  final int type;
  final Function(String date) dateChanged;

  const SectionInformation(
      {Key? key,
      required this.name,
      required this.data,
      required this.controller,
      required this.type,
      required this.dateChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.headline5,
        ),
        SizedBox(
          height: (type == 0 || type == 1 || type == 2) ? 0.2.h : 0.5.h,
        ),
        (type == 0 || type == 1 || type == 2)
            ? TextField(
                controller: controller,
                keyboardType: type == 0
                    ? TextInputType.name
                    : (type == 1
                        ? TextInputType.emailAddress
                        : TextInputType.phone),
                cursorColor: Colors.white,
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      fontSize: 17.sp,
                    ),
              )
            : GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    fieldHintText: "",
                    helpText: "",
                    context: context,
                    initialDate: DateTime.now(),
                    initialEntryMode: DatePickerEntryMode.input,
                    //get today's date
                    firstDate: DateTime(1900, 1, 1),
                    //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime.now(),
                  );
                  dateChanged(DateFormat('dd-MM-yyyy').format(pickedDate!));
                },
                child: Text(
                  data,
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        fontSize: 17.sp,
                      ),
                ),
              ),
        SizedBox(
          height: (type == 0 || type == 1 || type == 2) ? 0.2.h : 1.h,
        ),
        Divider(
          color: Colors.grey.shade200,
          thickness: 0.5,
        ),
        SizedBox(
          height: 1.h,
        ),
      ],
    );
  }
}
