import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class WriterInfo extends StatefulWidget {
  final int id;

  WriterInfo(this.id);

  @override
  State<WriterInfo> createState() => _WriterInfoState();
}

class _WriterInfoState extends State<WriterInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              WriterAccountHome(),
              SizedBox(
                height: 3.h,
              ),
              Text(
                'About',
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(
                    fontSize: 2.5.h,
                    // color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 2.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  'Simon & Schuster is the author of Macmillan Dictionary for Children,'
                      ' a Simon & Schuster book',
                  style: Theme.of(context)
                      .textTheme
                      .headline5,
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Books by Simon & Schuster',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                          fontSize: 2.h,
                          // color: Colors.grey.shade200,
                        ),
                      ),
                      Text(
                        'More >',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                          fontSize: 1.5.h,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WriterAccountHome extends StatelessWidget {
  const WriterAccountHome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 30.h,
      color: Colors.grey.shade900,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/user.png',
                  fit: BoxFit.fill,
                  height: 10.h,
                  width: 20.w,
                ),
              ),
              Container(
                padding: EdgeInsets.all(4),
                color: Colors.white,
                child: Text(
                  'AUTHOR',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(
                          fontSize: 1.5.h,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            'Simon & Schuster',
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  fontSize: 2.h,
                ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Text(
            '1 TITLE',
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  fontSize: 1.5.h,
                ),
          ),
        ],
      ),
    );
  }
}
