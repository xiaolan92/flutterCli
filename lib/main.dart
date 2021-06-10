import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';


void main()=>runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return ScreenUtilInit(
         designSize: Size(750,1334),
         builder: () => MaterialApp(
           debugShowCheckedModeBanner: false,
           theme: ThemeData(
             primaryColor: Colors.white
           ),
           home: Scaffold(
             appBar: AppBar(
               title: Text("LOGO  ABCEX"),
               elevation: 0,
               actions: <Widget>[
                 IconButton(icon: Icon(IconData(0xe613,fontFamily: "iconfont"),color: Colors.blue,size: 47.sp,), onPressed: (){

                 }),
               ],
             ),
             body: Container(
                   width: 690.w,
                   margin: EdgeInsets.symmetric(horizontal: 30.w),
               child: Column(
                 children: <Widget>[
                   SizedBox(
                     height: 3.h,
                   ),
                   swiper(),
                   notice()
                 ],
               )
             )
           ),
         ),
     );
  }
  // 轮播图
  Widget swiper (){
    return Container(
      width: double.infinity,
      height: 260.h,
      child: Swiper(
       itemBuilder: ( BuildContext context,int index){
         return new Image.network(
        "https://via.placeholder.com/690x260",
        fit: BoxFit.fill,
        );
        },
       itemCount: 3,
       autoplay: true,
       autoplayDelay: 4000,
       pagination:SwiperPagination(),
     )
    );
  }
  // 通知
  Widget notice (){
    return Container(
      width: double.infinity,
      height: 38.h,
      margin: EdgeInsets.symmetric(vertical:20.h),
      child: Row(
        crossAxisAlignment:CrossAxisAlignment.center ,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(IconData(0xe61a,fontFamily: "iconfont"),color: Colors.blue),
          Container(
            width: 590.w,
            child: Swiper(
            itemBuilder: (BuildContext context,int index){
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 15.w,),
                  Text("$index",style: TextStyle(fontSize: 30.sp)),
                ],
              );
            },
            itemCount: 4,
            autoplay: true,
            autoplayDelay: 4000,
            scrollDirection: Axis.vertical,
          ),
          ),
          Icon(Icons.chevron_right,color: Color.fromRGBO(0, 0, 0, 0.3),size: 50.sp)

        ],
      ),
    );
  }
}