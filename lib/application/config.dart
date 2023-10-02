import 'dart:convert';
import 'dart:io';

import 'package:eatincczu/application/bus.dart';

class AppConfig {
  Map data = {};
  String? path;
  AppConfig({Map? data, this.path}) {
    if (data != null) {
      this.data = data;
    }
    if (path != null) {
      if (!File(path!).existsSync()) {
        File(path!).writeAsStringSync("{}");
      }
      this.data = jsonDecode(File(path!).readAsStringSync());
    }
  }

  void syncFromPath({bool issync = true}) {
    if (path == null || !issync) {
      return;
    }
    data = jsonDecode(File(path!).readAsStringSync());
  }

  dynamic get(String key, {bool issync = false}) {
    syncFromPath(issync: issync);
    return data[key];
  }

  V getElse<V>(String key, V fallback, {bool issync = false}) {
    syncFromPath(issync: issync);
    return data.containsKey(key) ? get(key) : fallback;
  }

  bool containsKey(String key, {bool issync = false}) {
    syncFromPath(issync: issync);
    return data.containsKey(key);
  }

  V getOrWrite<V>(String key, V fallback, {bool issync = false}) {
    if (containsKey(key, issync: issync)) {
      return get(key);
    } else {
      return writeKeySync(key, fallback);
    }
  }

  Future<V> writeKey<V>(String key, V value) async {
    data[key] = value;
    await File(path!).writeAsString(jsonEncode(data));
    return value;
  }

  V writeKeySync<V>(String key, V value) {
    data[key] = value;
    File(path!).writeAsStringSync(jsonEncode(data));
    return value;
  }
}

Future<AppConfig> createConfig() async {
  return AppConfig(
      path: Platform.isAndroid
          ? "${await getAndroidPath()}/app.json"
          : "app.json");
}
