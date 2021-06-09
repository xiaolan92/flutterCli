import 'package:dio/dio.dart';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BaseUri {
    late String baseUrl;
    static final bool isProd = bool.fromEnvironment("dart.vm.product");
    BaseUri(){
      // 生产环境
      if(isProd){
        baseUrl = "";
      }else{
        // 开发环境
         baseUrl  = "https://www.hao123.com";
      }

    }
}


class Http {
  static late Dio dio;
  static const int CONNECT_TIMEOUT = 4000;
  static const int RECEIVE_TIMEOUT = 3000;
  static const String CONTENT_TYPE = Headers.formUrlEncodedContentType;
  static const RESPONSE_TYPE = ResponseType.json;
  static late  Response response;

  // 系统错误
  static const List systemErrorType = [
    {"errorType": DioErrorType.connectTimeout, "msg": "连接服务器超时"},
    {"errorType": DioErrorType.sendTimeout, "msg": "发送数据超时"},
    {"errorType": DioErrorType.receiveTimeout, "msg": "接收数据超时"},
    {"errorType": DioErrorType.other, "msg": "连接服务器异常"},
  ];

  // 服务器端错误
  static const List responseErrorType = [
    {"statusCode": 401, "msg": "未登陆,请登陆"},
    {"statusCode": 500, "msg": "服务器错误"}
  ];

  static Future getToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token") ?? "";
      return token;
    } catch (error) {
      print(error);
    }
  }

  static Future<dynamic> request(String  url,
      {Map<String, dynamic>? data, String method = "get"}) async {
    BaseOptions options = BaseOptions(
        baseUrl: BaseUri().baseUrl,
        method: method == "get" ? "get" : "post",
        connectTimeout: CONNECT_TIMEOUT,
        receiveTimeout: RECEIVE_TIMEOUT,
        contentType: CONTENT_TYPE,
        responseType: RESPONSE_TYPE);
    dio = Dio(options);
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options,handler) async {
      dio.lock();
      String token = await getToken();
      options.headers["Authorization"] = 'Bearer ' + token;
      dio.unlock();
      return handler.next(options);
    }, onResponse: (response,handler) async {
      Map data = jsonDecode(response.data);
      if (data["code"] == 200) {
        return handler.resolve(response.data);
      }

      // 自定义错误
      Fluttertoast.showToast(
        msg: "${data['msg']}",
        gravity: ToastGravity.CENTER,
      );
      return handler.reject(data["msg"]);

    }, onError: (DioError error,handler) async {
      var errorType = error.type;
      for (int i = 0; i < systemErrorType.length; i++) {
        if (systemErrorType[i]["errorType"] == errorType) {
          Fluttertoast.showToast(
            msg: systemErrorType[i]["msg"],
            gravity: ToastGravity.CENTER,
          );
          return handler.reject(error);
        }
      }
      if (errorType == DioErrorType.response) {
        var statusCode = error.response?.statusCode;
        for (int i = 0; i < responseErrorType.length; i++) {
          if (responseErrorType[i]["statusCode"] == statusCode) {
            Fluttertoast.showToast(
              msg: responseErrorType[i]["msg"],
              gravity: ToastGravity.CENTER,
            );
            return handler.reject(error);
          }
        }
        Fluttertoast.showToast(
          msg: "网络错误$statusCode",
          gravity: ToastGravity.CENTER,
        );
        return handler.reject(error);
      }
    return handler.reject(error);
    }));
    // 开发环境下
    if(!BaseUri.isProd){
       // 开启请求日志
       dio.interceptors.add(LogInterceptor(responseBody: false));
       // 抓包调试,仅用于开发环境
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
         (client) {
        client.findProxy = (uri) {
         return "PROXY  192.168.43.111:8888";
       };
        // 忽略Https证书校验
        client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
         return true;
       };
     };

    }
    // 请求
    if (method == "get") {
      response = await dio.get(url, queryParameters: data);
    } else {
      response = await dio.post(url, data: data);
    }

    return response;
  }
}
