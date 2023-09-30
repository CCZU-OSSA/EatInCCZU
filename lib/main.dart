import 'package:dynamic_color/dynamic_color.dart';
import 'package:eat_in_cczu/pages/eat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

void main() async {
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
        home: const MyHomePage(title: '🏠Home'),
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget? _body;

  @override
  Widget build(BuildContext context) {
    var home = ListView(
      children: [
        Card(
          child: FutureBuilder(
            future: rootBundle.loadString("resource/text/home.md"),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return MarkdownBody(data: snapshot.data!);
              } else {
                return const Center(
                  child: Text("loading"),
                );
              }
            },
          ),
        )
      ],
    );
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
              onTap: () {
                setState(() {
                  _body = home;
                  Navigator.pop(context);
                });
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.food_bank),
              title: const Text("吃什么",
                  style: TextStyle(fontWeight: FontWeight.w700)),
              onTap: () {
                setState(() {
                  _body = const EatWhat();
                  Navigator.pop(context);
                });
              },
            ),
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
              onTap: () {},
            ),
          ],
        )),
        body: _body ?? home,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ));
  }
}
