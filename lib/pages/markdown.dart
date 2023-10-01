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
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        );
      } else {
        return const Text("loading");
      }
    },
  );
}
