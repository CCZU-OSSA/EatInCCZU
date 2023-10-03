import 'package:eatincczu/data/typed.dart';
import 'package:flutter/material.dart';

class EatWhat extends StatefulWidget {
  const EatWhat({super.key});

  @override
  State<StatefulWidget> createState() {
    return _EatWhatState();
  }
}

class _EatWhatState extends State<EatWhat> {
  DisplayInfo? _info;

  @override
  Widget build(BuildContext context) {
    var info = _info ?? EateryList().getDisplayInfo(callback: setState);
    return SingleChildScrollView(
      child: Column(children: [
        const SizedBox(
          height: 20,
        ),
        Center(
            child: Card(
                child: SizedBox(height: 300, width: 300, child: info.image))),
        const SizedBox(
          height: 20,
        ),
        SizedBox(width: 500, child: info.panellist),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
                onPressed: () {},
                child: const Text(
                  "上份菜❤",
                  style: TextStyle(fontWeight: FontWeight.w700),
                )),
          ],
        )
      ]),
    );
  }
}
