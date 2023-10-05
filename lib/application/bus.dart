import 'dart:io';

import 'package:eatincczu/application/config.dart';
import 'package:eatincczu/data/typed.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

// 依赖总线，负责共享配置与日志实例，同时持有一个存储用容器
class ApplicationBus {
  AppConfig config;
  Logger logger;
  EateryList? eateryList;
  ApplicationBus(this.config, this.logger, {this.eateryList});
  Map<String, dynamic> holder = {};
  void updateToHolder(String key, dynamic value) {
    holder[key] = value;
  }

  V getfromHolderElse<V>(String key, V fallback) {
    return holder.containsKey(key) ? holder[key] : fallback;
  }

  static ApplicationBus instance({BuildContext? context}) {
    return Provider.of(context ?? globalApplicationKey.currentContext!,
        listen: false);
  }
}

EateryList eateryList({BuildContext? context}) {
  return Provider.of<ApplicationBus>(
              context ?? globalApplicationKey.currentContext!,
              listen: false)
          .eateryList ??
      EateryList();
}

AppConfig config({BuildContext? context}) {
  return Provider.of<ApplicationBus>(
          context ?? globalApplicationKey.currentContext!,
          listen: false)
      .config;
}

Logger logger({BuildContext? context}) {
  return Provider.of<ApplicationBus>(
          context ?? globalApplicationKey.currentContext!,
          listen: false)
      .logger;
}

final GlobalKey globalApplicationKey = GlobalKey();

final GlobalKey<NavigatorState> globalNavigatorKey =
    GlobalKey<NavigatorState>();

Future<String> getPlatPath() async {
  if (Platform.isWindows) {
    return ".";
  }
  return (await tryGetExternalStorageDirectory() ??
          await getApplicationSupportDirectory())
      .path;
}

Future<String> getPlatCachePath() async {
  if (Platform.isWindows) {
    return ".";
  }
  return (await tryGetExternalCacheDirectory() ??
          await getApplicationCacheDirectory())
      .path;
}

Future<Directory?> tryGetExternalStorageDirectory() async {
  try {
    return await getExternalStorageDirectory();
  } catch (e) {
    return null;
  }
}

Future<Directory?> tryGetExternalCacheDirectory() async {
  try {
    return (await getExternalCacheDirectories())?[0];
  } catch (e) {
    return null;
  }
}
