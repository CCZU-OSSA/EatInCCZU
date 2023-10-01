import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<StatefulWidget> createState() => _SettingState();
}

//double _tv = getConfigAftInit().getOrWrite("font_scale", 1.0);
double _tv = 1.0;

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const ListTile(
          leading: Icon(Icons.display_settings),
          title: Text("UI设置", style: TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text("UI Settings",
              style: TextStyle(fontWeight: FontWeight.w700)),
        ),
        const Divider(),
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
                        value: _tv,
                        max: 3,
                        min: 0.1,
                        divisions: 29,
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.transparent),
                        label: "$_tv",
                        onChanged: (v) {
                          setState(() {
                            _tv = double.parse(v.toStringAsPrecision(2));
                            // getConfigAftInit().writeKey("font_scale", _tv);
                          });
                        }))
              ])),
          trailing: Text("$_tv"),
        ),
        const ListTile(
          leading: Icon(Icons.info),
          title: Text("关于", style: TextStyle(fontWeight: FontWeight.w700)),
          subtitle:
              Text("About", style: TextStyle(fontWeight: FontWeight.w700)),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.code),
          title: const Text("项目开源地址",
              style: TextStyle(fontWeight: FontWeight.w500)),
          subtitle: const Text("https://github.com/H2Sxxa/EatInCCZU",
              style: TextStyle(fontWeight: FontWeight.w400)),
          onTap: () async {
            if (await canLaunchUrlString(
                "https://github.com/H2Sxxa/EatInCCZU")) {
              await launchUrlString("https://github.com/H2Sxxa/EatInCCZU",
                  mode: LaunchMode.platformDefault);
            }
          },
        )
      ],
    );
  }
}
