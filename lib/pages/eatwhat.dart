import 'package:flutter/material.dart';

class EatWhat extends StatefulWidget {
  const EatWhat({super.key});

  @override
  State<StatefulWidget> createState() {
    return _EatWhatState();
  }
}

class _EatWhatState extends State<EatWhat> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Center(
            child: Card(
                child: SizedBox(
          height: 300,
          width: 300,
          child: Image.asset(
            "resource/images/mystia.png",
            width: 300,
            height: 300,
          ),
        ))),
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
                ))
          ],
        )
      ]),
    );
  }
}
