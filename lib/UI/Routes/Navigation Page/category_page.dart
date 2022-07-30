import 'package:ebook/Constants/constance_data.dart';
import 'package:ebook/Helper/navigator.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: SafeArea(
        child: Container(
            color:  Colors.black54,
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Expanded(
                child: Center(
                  child: ListView.builder(
                    shrinkWrap: true,
                      itemCount: ConstanceData.category.length,
                      itemBuilder: (cont, ind) {
                        var data = ConstanceData.category[ind];
                        return Container(
                          height: 10.h,
                          child: Center(
                            child: Text(
                              data,
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                        );
                      }),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigation.instance.goBack();
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white
                  ),
                  padding: EdgeInsets.all(2),
                  margin: EdgeInsets.only(bottom: 10.h),
                  child: Icon(
                    Icons.clear,
                    color: Colors.black,
                    size: 5.h,
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
