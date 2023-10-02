import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Personal extends StatefulWidget {
  const Personal({super.key});

  @override
  State<StatefulWidget> createState() => _PersonalState();
}

class _PersonalState extends State<Personal> {
  @override
  Widget build(BuildContext context) {
    return const MarkdownBody(data: "# WIP");
  }
}
