import 'package:flutter/material.dart';

// 函数节流

mixin Throttle {
  int _lastTime = 0;
  final int _interval = 2000;
  throttle(VoidCallback action){
    if(DateTime.now().millisecondsSinceEpoch - _lastTime > _interval){
       _lastTime = DateTime.now().millisecondsSinceEpoch;
      action();

    }

  }
}