import 'dart:io';
import 'dart:ui';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:eatincczu/application/bus.dart';
import 'package:eatincczu/application/config.dart';
import 'package:eatincczu/application/log.dart';
import 'package:eatincczu/data/typed.dart';
import 'package:eatincczu/pages/eatwhat.dart';
import 'package:eatincczu/pages/editor.dart';
import 'package:eatincczu/pages/personal.dart';
import 'package:eatincczu/pages/widgets/markdown.dart';
import 'package:eatincczu/pages/setting.dart';
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
  EateryList eateryList;
  File eatryfile = File("${await getPlatPath()}/eaterylist.json");
  if (await eatryfile.exists()) {
    eateryList = await EateryList.fromFile(eatryfile);
  } else {
    eateryList = EateryList();
    await eatryfile.writeAsString(EateryList().encode());
  }
  runApp(Provider<ApplicationBus>.value(
    value: ApplicationBus(await createConfig(), await createLogger(),
        eateryList: eateryList),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        key: globalApplicationKey,
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
  String _title = "🏠主页";
  int _bottomindex = 0;
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
    "/personal": (context) => const Personal(),
    "/editor": (context) => const Editor(),
  };

  final _navigatorKey = GlobalKey<NavigatorState>();
  void callbackSetState() {
    setState(() {});
  }

  void pushPage(BuildContext context, String name, String title,
      {bool ispop = true}) {
    _navigatorKey.currentState?.pushNamed(name);
    setState(() {
      _title = title;
      if (ispop) {
        Navigator.of(context).pop(context);
      }
      logger().i("goto $_title");
    });
  }

  void pushIndex(BuildContext context, int index, {bool ispop = true}) {
    _bottomindex = index;
    [
      () => pushPage(context, "/", "🏠主页", ispop: ispop),
      () => pushPage(context, "/eatwhat", "😋开饭", ispop: ispop),
      () => pushPage(context, "/personal", "🧑‍🎓个人", ispop: ispop),
      () => pushPage(context, "/settings", "🔧设置", ispop: ispop),
      () => pushPage(context, "/editor", "🖋️编辑", ispop: ispop)
    ][index]();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
            child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Column(children: [
                Image.asset(
                  "resource/images/appicon.png",
                  width: 110,
                  height: 110,
                ),
                const Text(
                  "CCZU今天吃什么",
                  style: TextStyle(fontWeight: FontWeight.w700),
                )
              ]),
            ),
            ListTile(
                leading: const Icon(Icons.home),
                title: const Text("主页",
                    style: TextStyle(fontWeight: FontWeight.w700)),
                onTap: () => pushIndex(context, 0)),
            const Divider(),
            ListTile(
                leading: const Icon(Icons.food_bank),
                title: const Text("开饭",
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
            ListTile(
                leading: const Icon(Icons.edit),
                title: const Text("编辑",
                    style: TextStyle(fontWeight: FontWeight.w700)),
                onTap: () => pushIndex(context, 4))
          ],
        )),
        bottomNavigationBar:
            config(context: context).getElse("bottom_route", true)
                ? BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    selectedItemColor: Theme.of(context).colorScheme.primary,
                    currentIndex: _bottomindex,
                    items: const [
                      BottomNavigationBarItem(
                          label: "主页",
                          icon: Icon(Icons.home_outlined),
                          activeIcon: Icon(Icons.home)),
                      BottomNavigationBarItem(
                          label: "开饭",
                          icon: Icon(Icons.food_bank_outlined),
                          activeIcon: Icon(Icons.food_bank)),
                      BottomNavigationBarItem(
                          label: "个人",
                          icon: Icon(Icons.person_outline),
                          activeIcon: Icon(Icons.person)),
                      BottomNavigationBarItem(
                          label: "设置",
                          icon: Icon(Icons.settings_outlined),
                          activeIcon: Icon(Icons.settings)),
                      BottomNavigationBarItem(
                          label: "编辑",
                          icon: Icon(Icons.edit_outlined),
                          activeIcon: Icon(Icons.edit))
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
                      builder: (context) => DecoratedBox(
                            decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                            child: routes[settings.name]!(
                                context, callbackSetState),
                          ))
                  : MaterialPageRoute(
                      builder: (context) => DecoratedBox(
                            decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                            child: routes[settings.name]!(context),
                          ));
            }),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            _title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ));
  }
}
