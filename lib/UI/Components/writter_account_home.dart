import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class WriterAccountHome extends StatelessWidget {
  final String name, picture, saluation, contributor;

  WriterAccountHome(this.name, this.picture, this.saluation, this.contributor);

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
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.network(
                      picture,
                      height: 10.h,
                      width: 20.w,
                    ) ??
                    Image.asset(
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
                  contributor ?? 'AUTHOR',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
            "${saluation} ${name}" ?? 'Simon & Schuster',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 2.h,
                ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Text(
            '1 TITLE',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 1.5.h,
                ),
          ),
        ],
      ),
    );
  }
}
