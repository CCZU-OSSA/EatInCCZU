import 'dart:convert';
import 'dart:io';

class AppConfig {
  Map? data;
  String? path;
  AppConfig({this.data, this.path, String? strData}) {
    data ??= jsonDecode(strData ?? "{}");
  }

  void syncFromPath() async {
    if (path == null) {
      return;
    }
    data = jsonDecode(await File(path!).readAsString());
  }

  dynamic get(String key) {
    return data![key];
  }

  dynamic getElse(String key, dynamic fallback) {
    return data!.containsKey(key) ? get(key) : fallback;
  }

  void writeKey(String key, dynamic value) async {
    data![key] = value;
    await File(path!).writeAsString(jsonEncode(data!));
  }
}

AppConfig? globalConfig;

AppConfig getOrCreateConfig() {
  return globalConfig ?? AppConfig(path: "app.json");
}
