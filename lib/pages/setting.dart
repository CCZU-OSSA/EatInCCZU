import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingState();
  }
}

double _tv = 1.0;

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.font_download),
          title: const Text(
            "字体缩放",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Slider(
              value: _tv,
              max: 3,
              min: 0.1,
              onChanged: (v) {
                setState(() {
                  _tv = v;
                });
              }),
          trailing: Text("$_tv"),
        )
      ],
    );
  }
}
