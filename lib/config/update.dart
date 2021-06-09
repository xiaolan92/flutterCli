import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import './http.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ota_update/ota_update.dart';
import 'package:open_file/open_file.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class Word extends StatelessWidget {
  final String? word;
  const Word({Key? key, @required this.word}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        child: Text("$word"),
        padding: EdgeInsets.all(10),
      ),
    ));
  }
}

class Update extends StatefulWidget {
  String? url;
  Update({Key? key, @required this.url}) : super(key: key);

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  String word = "";
  @override
  void initState() {
    super.initState();
    update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(""),
    );
  }

  _showToast() {
    var overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      return Word(word: word);
    });
    overlayState?.insert(overlayEntry);
    Future.delayed(Duration(seconds: 2)).then((value) {
      overlayEntry.remove();
    });
  }

  update() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    Response res = await Http.request(widget.url= "");
    String remoteVersion = jsonDecode(res.data).version;
    if (version.compareTo(remoteVersion).toString() == "-1") {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("更新提示"),
              content: Text("有新版本更新,请更新"),
              actions: [
                FlatButton(
                  onPressed: () {},
                  child: Text("取消")),
                FlatButton(
                    onPressed: () {
                      downLoad();
                    },
                    child: Text("确定"))
              ],
            );
          });
    }
  }

  downLoad() async {
    Directory appDocdir = await getApplicationSupportDirectory();
    String appDocPath = appDocdir.path;
    if (Platform.isIOS) {
      String url = "";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
    if (Platform.isAndroid) {
      String url = "";
      try {
        OtaUpdate().execute(url).listen((OtaEvent event) {
          switch (event.status) {
            case OtaStatus.DOWNLOADING:
              setState(() {
                word = "下载中,下载进度:${event.value}%";
              });
              _showToast();
              break;
            case OtaStatus.INSTALLING:
              setState(() {
                word = "安装中";
              });
              _showToast();
              OpenFile.open("$appDocPath/new.apk");
              break;
            case OtaStatus.PERMISSION_NOT_GRANTED_ERROR:
              setState(() {
                word = "更新失败，无法获取权限";
              });
              _showToast();
              break;
            default:
              setState(() {
                word = "更新失败，请稍后再试";
              });
              _showToast();
          }
        });
      } catch (error) {
        setState(() {
          word = "更新失败，请稍后再试";
        });
        _showToast();
      }
    }
  }
}
