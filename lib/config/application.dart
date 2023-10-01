import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AppConfig {
  Map data = {};
  String? path;
  AppConfig({Map? data, this.path}) {
    if (data != null) {
      this.data = data;
    }
    if (path != null) {
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

  dynamic getElse(String key, dynamic fallback, {bool issync = false}) {
    syncFromPath(issync: issync);
    return data.containsKey(key) ? get(key) : fallback;
  }

  bool containsKey(String key, {bool issync = false}) {
    syncFromPath(issync: issync);
    return data.containsKey(key);
  }

  dynamic getOrWrite(String key, dynamic fallback, {bool issync = false}) {
    if (containsKey(key, issync: issync)) {
      return get(key);
    } else {
      return writeKeySync(key, fallback);
    }
  }

  dynamic writeKey(String key, dynamic value) async {
    data[key] = value;
    await File(path!).writeAsString(jsonEncode(data));
    return value;
  }

  dynamic writeKeySync(String key, dynamic value) {
    data[key] = value;
    File(path!).writeAsStringSync(jsonEncode(data));
    return value;
  }
}

AppConfig? globalConfig;

Future<AppConfig> getOrCreateConfig() async {
  return globalConfig ??
      AppConfig(
          path: Platform.isAndroid
              ? "${(await getApplicationSupportDirectory()).path}/app.json"
              : "app.json");
}

Future<void> initConfig() async {
  globalConfig = await getOrCreateConfig();
}

AppConfig getConfigAftInit() {
  return globalConfig!;
}
