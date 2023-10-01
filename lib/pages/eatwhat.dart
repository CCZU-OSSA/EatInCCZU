import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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
    return const Markdown(data: "# hello",shrinkWrap: false,);
  }
}
