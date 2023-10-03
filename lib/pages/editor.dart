import 'package:eatincczu/application/bus.dart';
import 'package:eatincczu/data/typed.dart';
import 'package:eatincczu/pages/widgets/markdown.dart';
import 'package:flutter/material.dart';

class Editor extends StatefulWidget {
  const Editor({super.key});

  @override
  State<StatefulWidget> createState() => _Editor();
}

class _Editor extends State<Editor> {
  List<PanelInfo>? _info;
  List<PanelInfo> getInfo(BuildContext context, {bool refresh = false}) {
    var eateryls = eateryList(context: context);
    if (_info == null || refresh) {
      _info = List.generate(eateryls.data!.length,
          (index) => PanelInfo(head: eateryls.data![index].name));
    }
    return _info!;
  }

  @override
  Widget build(BuildContext context) {
    var eateryls = eateryList(context: context);
    var name = TextEditingController();
    var publisher = TextEditingController();
    var description = TextEditingController();
    List<PanelInfo> info = getInfo(context);
    return ListView(
      children: [
        asyncMarkdownBody("resource/text/editor.md"),
        Column(children: [
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 200,
            child: TextField(
              controller: name,
              onEditingComplete: () => setState(() {
                eateryls.name = name.text;
                eateryls.sync();
                name.clear();
              }),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                labelText: "名称 : ${eateryls.name}",
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 200,
            child: TextField(
              controller: publisher,
              onEditingComplete: () => setState(() {
                eateryls.publisher = publisher.text;
                eateryls.sync();
                publisher.clear();
              }),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                labelText: "作者 : ${eateryls.publisher}",
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 200,
            child: TextField(
              controller: description,
              onEditingComplete: () => setState(() {
                eateryls.description = description.text;
                eateryls.sync();
                description.clear();
              }),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                labelText: "简介 : ${eateryls.description}",
                border: const OutlineInputBorder(),
              ),
            ),
          )
        ]),
        ExpansionPanelList(
          expansionCallback: (panelIndex, isExpanded) => setState(() {
            info[panelIndex].doExpand();
          }),
          children: info
              .map((e) => ExpansionPanel(
                  isExpanded: e.isExpand,
                  headerBuilder: (context, isExpanded) =>
                      markdownBodyString(e.head),
                  body: markdownBodyString(e.body)))
              .toList(),
        )
      ],
    );
  }
}
