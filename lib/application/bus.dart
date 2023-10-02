import 'package:eat_in_cczu/application/config.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

// 依赖总线，负责共享配置与日志实例，同时持有一个存储用容器
class ApplicationBus {
  AppConfig config;
  Logger logger;
  ApplicationBus(this.config, this.logger);
  Map<String, dynamic> holder = {};
  void updateToHolder(String key, dynamic value) {
    holder[key] = value;
  }

  V getfromHolderElse<V>(String key, V fallback) {
    return holder.containsKey(key) ? holder[key] : fallback;
  }
}

AppConfig config({BuildContext? context}) {
  return Provider.of<ApplicationBus>(
          context ?? globalApplicationKey.currentState!.overlay!.context,
          listen: false)
      .config;
}

Logger logger({BuildContext? context}) {
  return Provider.of<ApplicationBus>(
          context ?? globalApplicationKey.currentState!.overlay!.context,
          listen: false)
      .logger;
}

final GlobalKey<NavigatorState> globalApplicationKey =
    GlobalKey<NavigatorState>();

Future<String> getAndroidPath() async {
  return (await getExternalStorageDirectory() ??
          await getApplicationSupportDirectory())
      .path;
}
