import 'package:eatincczu/application/bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

var loading = Dialog(
  child: Container(
    width: 100,
    padding: const EdgeInsets.all(16.0),
    child: const Row(
      children: [
        SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(),
        ),
        SizedBox(
          width: 16,
        ),
        Text(
          'Loading',
          style: TextStyle(fontSize: 16),
        ),
        Spacer(),
      ],
    ),
  ),
);

Widget asyncMarkdownBody(String resource, {BuildContext? context}) {
  return FutureBuilder(
    future: rootBundle.loadString(resource),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return markdownBodyString(snapshot.data!, context: context);
      } else {
        return loading;
      }
    },
  );
}

Widget markdownBodyString(String data, {BuildContext? context}) {
  var defst = context == null
      ? MarkdownStyleSheet()
      : MarkdownStyleSheet.fromTheme(Theme.of(context));
  return Markdown(
    data: data,
    styleSheet: defst.copyWith(
        textScaleFactor: config(context: context).getElse("font_scale", 1.0)),
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
  );
}
