import 'dart:io';
import 'dart:ui';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:eat_in_cczu/application/bus.dart';
import 'package:eat_in_cczu/application/config.dart';
import 'package:eat_in_cczu/application/log.dart';
import 'package:eat_in_cczu/pages/eatwhat.dart';
import 'package:eat_in_cczu/pages/personal.dart';
import 'package:eat_in_cczu/pages/widgets/markdown.dart';
import 'package:eat_in_cczu/pages/setting.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

void main() async {
  Logger.level = Level.all;
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows) {
    if (await File("winfont").exists()) {
      await loadFontFromList(await File("winfont").readAsBytes(),
          fontFamily: "winfont");
    }
  }

  runApp(Provider<ApplicationBus>.value(
    value: ApplicationBus(await createConfig(), await createLogger()),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        navigatorKey: globalApplicationKey,
        title: 'CCZU今天吃什么',
        theme: ThemeData(
            colorScheme: lightColorScheme ??
                ColorScheme.fromSeed(seedColor: Colors.pink.shade200),
            useMaterial3: true,
            fontFamily: Platform.isWindows ? "winfont" : ""),
        darkTheme: ThemeData(
            colorScheme: darkColorScheme ??
                ColorScheme.fromSeed(seedColor: Colors.pink.shade700),
            useMaterial3: true,
            fontFamily: Platform.isWindows ? "winfont" : ""),
        themeMode: ThemeMode.system,
        home: const MyHomePage(),
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _title;

  static ListView home = ListView(
    children: [
      const Card(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 20,
              ),
              Icon(Icons.info),
              SizedBox(
                width: 20,
              ),
              Expanded(
                  child: Text(
                "本应用的开发与CCZU，即常州大学官方没有任何直接关系。本应用不会主动联网，无需担心泄漏你的个人信息。请勿到任何无关场所提及本应用",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              )),
              SizedBox(
                width: 20,
              ),
            ],
          ),
        ),
      ),
      asyncMarkdownBody("resource/text/home.md")
    ],
  );
  final routes = {
    "/": (context) => home,
    "/settings": (context, cb) => Setting(callback: cb),
    "/eatwhat": (context) => const EatWhat(),
    "/personal": (context) => const Personal()
  };

  final _navigatorKey = GlobalKey<NavigatorState>();
  void callbackSetState() {
    setState(() {});
  }

  void pushPage(BuildContext context, String name, String title,
      {bool ispop = true}) {
    setState(() {
      _title = title;
      _navigatorKey.currentState?.pushNamed(name);
      if (ispop) {
        Navigator.of(context).pop(context);
      }
      logger().i("goto $_title");
    });
  }

  void pushIndex(BuildContext context, int index, {bool ispop = true}) => [
        () => pushPage(context, "/", "🏠Home", ispop: ispop),
        () => pushPage(context, "/eatwhat", "😋EatWhat", ispop: ispop),
        () => pushPage(context, "/personal", "🧑‍🎓Personal", ispop: ispop),
        () => pushPage(context, "/settings", "🔧Settings", ispop: ispop)
      ][index]();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
            child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration:
                  BoxDecoration(color: Theme.of(context).colorScheme.onPrimary),
              child: const Text("🗺️导航栏",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30)),
            ),
            ListTile(
                leading: const Icon(Icons.home),
                title: const Text("主页",
                    style: TextStyle(fontWeight: FontWeight.w700)),
                onTap: () => pushIndex(context, 0)),
            const Divider(),
            ListTile(
                leading: const Icon(Icons.restaurant),
                title: const Text("吃什么",
                    style: TextStyle(fontWeight: FontWeight.w700)),
                onTap: () => pushIndex(context, 1)),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("个人",
                  style: TextStyle(fontWeight: FontWeight.w700)),
              onTap: () => pushIndex(context, 2),
            ),
            const Divider(),
            ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("设置",
                    style: TextStyle(fontWeight: FontWeight.w700)),
                onTap: () => pushIndex(context, 3)),
          ],
        )),
        bottomNavigationBar:
            config(context: context).getElse("bottom_route", false)
                ? BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    items: const [
                      BottomNavigationBarItem(
                          label: "Home", icon: Icon(Icons.home)),
                      BottomNavigationBarItem(
                          label: "EatWhat", icon: Icon(Icons.restaurant)),
                      BottomNavigationBarItem(
                          label: "Personal", icon: Icon(Icons.person)),
                      BottomNavigationBarItem(
                        label: "Settings",
                        icon: Icon(Icons.settings),
                      )
                    ],
                    onTap: (value) => pushIndex(context, value, ispop: false),
                  )
                : null,
        body: Navigator(
            key: _navigatorKey,
            initialRoute: "/",
            onGenerateRoute: (settings) {
              return settings.name == "/settings"
                  ? MaterialPageRoute(
                      builder: (context) =>
                          routes[settings.name]!(context, callbackSetState))
                  : MaterialPageRoute(
                      builder: (context) => routes[settings.name]!(context));
            }),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            _title ?? "🏠Home",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ));
  }
}
