import 'package:flutter/material.dart';
import 'dart:async';

// 防抖

mixin Debounce {
  final Duration duration = Duration(seconds: 2);
  Timer? _timer;
  debounce(VoidCallback action){
    if(_timer != null){
      _timer?.cancel();
    }
    _timer =Timer(duration,action);

  }
}