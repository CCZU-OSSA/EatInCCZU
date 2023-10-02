import 'package:eat_in_cczu/application/bus.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Setting extends StatefulWidget {
  final Function callback;
  const Setting({super.key, required this.callback});

  @override
  State<StatefulWidget> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Divider(),
        const ListTile(
          leading: Icon(Icons.display_settings),
          title: Text("UI设置", style: TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text("UI Settings",
              style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.route),
          title: const Text(
            "底部导航",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          trailing: Switch(
              value: config(context: context).getOrWrite("bottom_route", false),
              onChanged: (v) => setState(() {
                    config(context: context).writeKeySync("bottom_route", v);
                    widget.callback();
                  })),
        ),
        ListTile(
          leading: const Icon(Icons.font_download),
          title: const Text(
            "字体缩放",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: SizedBox(
              height: 25,
              child: Stack(children: [
                Positioned(
                    top: 0,
                    bottom: 0,
                    left: -20,
                    right: 0,
                    child: Slider(
                        value: config(context: context)
                            .getOrWrite("font_scale", 1.0),
                        max: 3,
                        min: 0.1,
                        divisions: 29,
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.transparent),
                        label:
                            "${config(context: context).getOrWrite("font_scale", 1.0)}",
                        onChanged: (v) {
                          setState(() {
                            config(context: context).writeKey("font_scale",
                                double.parse(v.toStringAsPrecision(2)));
                          });
                        }))
              ])),
          trailing:
              Text("${config(context: context).getOrWrite("font_scale", 1.0)}"),
        ),
        const Divider(),
        const ListTile(
          leading: Icon(Icons.info),
          title: Text("关于", style: TextStyle(fontWeight: FontWeight.w700)),
          subtitle:
              Text("About", style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        const Divider(),
        ListTile(
            leading: const Icon(Icons.code),
            title: const Text("项目开源地址",
                style: TextStyle(fontWeight: FontWeight.w500)),
            subtitle: const Text("https://github.com/H2Sxxa/EatInCCZU",
                style: TextStyle(fontWeight: FontWeight.w400)),
            onTap: () => launchUrlString("https://github.com/H2Sxxa/EatInCCZU",
                mode: LaunchMode.externalApplication)),
        ListTile(
          leading: const Icon(Icons.comment),
          title: const Text("提出建议/反馈问题",
              style: TextStyle(fontWeight: FontWeight.w500)),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                      children: [
                        ListTile(
                          leading: Image.asset(
                            "resource/images/github.png",
                            width: 25,
                          ),
                          title: const Text("Github Issues",
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          onTap: () => launchUrlString(
                              "https://github.com/H2Sxxa/EatInCCZU/issues",
                              mode: LaunchMode.externalApplication),
                        ),
                        ListTile(
                          leading: const Icon(Icons.email),
                          title: const Text("Email",
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          onTap: () => launchUrlString(
                              "mailto:h2sxxa0w0@gmail.com",
                              mode: LaunchMode.externalApplication),
                        )
                      ],
                    ));
          },
        )
      ],
    );
  }
}
