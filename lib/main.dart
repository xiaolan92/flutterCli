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
                   swiper()
                 ],
               )
             )
           ),
         ),
     );
  }
  // 轮播图
  Widget swiper (){
     return Swiper(
       itemBuilder: ( BuildContext context,int index){
         return Image.network("http://via.placeholder.com/350x150",fit:BoxFit.fill);

       },
       itemCount: 3,
       pagination:SwiperPagination(),
        control: SwiperControl(),
     );
  }
}