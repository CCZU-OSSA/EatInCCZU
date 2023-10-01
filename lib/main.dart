import 'package:dynamic_color/dynamic_color.dart';
import 'package:eat_in_cczu/config/application.dart';
import 'package:eat_in_cczu/pages/eat.dart';
import 'package:eat_in_cczu/pages/markdown.dart';
import 'package:eat_in_cczu/pages/setting.dart';
import 'package:flutter/material.dart';

void main() async {
  await initConfig();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        title: 'CCZU今天吃什么',
        theme: ThemeData(
          colorScheme: lightColorScheme ??
              ColorScheme.fromSeed(seedColor: Colors.pink.shade200),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: darkColorScheme ??
              ColorScheme.fromSeed(seedColor: Colors.pink.shade700),
          useMaterial3: true,
        ),
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
  Widget? _body;
  String? _title;

  var home = ListView(
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

  void pushPage(BuildContext context, Widget page, String title) {
    setState(() {
      _body = page;
      _title = title;
      Navigator.pop(context);
    });
  }

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
                onTap: () => pushPage(context, home, "🏠Home")),
            const Divider(),
            ListTile(
                leading: const Icon(Icons.food_bank),
                title: const Text("吃什么",
                    style: TextStyle(fontWeight: FontWeight.w700)),
                onTap: () => pushPage(context, const EatWhat(), "😋EatWhat")),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("个人",
                  style: TextStyle(fontWeight: FontWeight.w700)),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("设置",
                  style: TextStyle(fontWeight: FontWeight.w700)),
              onTap: () => pushPage(context, const Setting(), "🔧Settings"),
            ),
          ],
        )),
        body: _body ?? home,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            _title ?? "🏠Home",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ));
  }
}
