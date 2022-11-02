import 'package:ebook/Constants/constance_data.dart';
import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        child: Consumer<DataProvider>(
          builder: (context,current,_) {
            return Container(
                color:  Colors.black54,
              height: double.infinity,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Center(
                    child: ListView.builder(
                      shrinkWrap: true,
                        itemCount: current.categoryList![current.currentIndex].length,
                        itemBuilder: (cont, ind) {
                          var data = current.categoryList![current.currentIndex][ind];
                          return GestureDetector(
                            onTap: (){
                              Navigation.instance.navigate('/selectCategories',
                                  args: '${data.title},${data.id}');
                            },
                            child: Container(
                              height: 10.h,
                              child: Center(
                                child: Text(
                                  data.title??"",
                                  style: Theme.of(context).textTheme.headline4?.copyWith(
                                    color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
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
            );
          }
        ),
      ),
    );
  }
}
