import 'package:eatincczu/application/bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

Widget asyncMarkdownBody(String resource) {
  return FutureBuilder(
    future: rootBundle.loadString(resource),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Markdown(
          data: snapshot.data!,
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
              textScaleFactor:
                  config(context: context).getElse("font_scale", 1.0)),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        );
      } else {
        return const Text("loading");
      }
    },
  );
}
