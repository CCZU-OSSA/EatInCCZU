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

Widget asyncMarkdownBody(String resource) {
  var fb = FutureBuilder(
    future: rootBundle.loadString(resource),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        var mdwd = markdownBodyString(snapshot.data!);
        ApplicationBus.instance()
            .updateToHolder("mdwidget-resource:$resource", mdwd);
        return mdwd;
      } else {
        return loading;
      }
    },
  );

  if (config().getElse("page_cached", true)) {
    return ApplicationBus.instance()
        .getfromHolderElse("mdwidget-resource:$resource", fb);
  }
  return fb;
}

Widget markdownBodyString(String data) {
  var fb = FutureBuilder(
    future: Future.value(data),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        var mdswd = Markdown(
          data: snapshot.data!,
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
              textScaleFactor:
                  config(context: context).getElse("font_scale", 1.0)),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        );
        ApplicationBus.instance()
            .updateToHolder("mdwidget-string:$data", mdswd);
        return mdswd;
      } else {
        return loading;
      }
    },
  );
  if (config().getElse("page_cached", true)) {
    return ApplicationBus.instance()
        .getfromHolderElse("mdwidget-string:$data", fb);
  }
  return fb;
}
