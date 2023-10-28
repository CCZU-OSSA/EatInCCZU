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
  final _textctrl = TextEditingController();
  void handleValueEdit(Function callback) {
    setState(() {
      var tv = _textctrl.text;
      showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: const Text("编辑"),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 250,
                    child: TextField(
                      maxLines: null,
                      controller: _textctrl,
                      onChanged: (value) => tv = value,
                      onTapOutside: (event) => setState(() {
                        callback(tv);
                        eateryList(context: context).sync();
                      }),
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                    )),
                const SizedBox(
                  height: 100,
                )
              ],
            ),
          ],
        ),
      );
    });
  }

  final _tablescr = ScrollController();
  @override
  Widget build(BuildContext context) {
    var eateryls = eateryList(context: context);
    var name = TextEditingController();
    var publisher = TextEditingController();
    var description = TextEditingController();
    return ListView(children: [
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
        ),
        const SizedBox(
          height: 20,
        ),
        Card(
            child: Scrollbar(
                controller: _tablescr,
                child: SingleChildScrollView(
                  controller: _tablescr,
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                      columns: ["", "名称", "位置", "简介", "图片"]
                          .map((e) => DataColumn(label: Text(e)))
                          .toList(),
                      rows: eateryls.data!
                          .map((e) => DataRow(cells: [
                                DataCell(const Icon(Icons.delete),
                                    onLongPress: () {
                                  setState(() {
                                    eateryList(context: context)
                                        .data!
                                        .remove(e);
                                    eateryList(context: context).sync();
                                  });
                                }),
                                DataCell(Text(e.name), onTap: () {
                                  _textctrl.text = e.name;
                                  handleValueEdit((v) => e.name = v);
                                }),
                                DataCell(Text(e.location), onTap: () {
                                  _textctrl.text = e.location;
                                  handleValueEdit((v) => e.location = v);
                                }),
                                DataCell(Text(e.description), onTap: () {
                                  _textctrl.text = e.description;
                                  handleValueEdit((v) => e.description = v);
                                }),
                                DataCell(Text(e.image ?? ""), onTap: () {
                                  _textctrl.text = e.image ?? "";
                                  handleValueEdit((v) => e.image =
                                      v == "" || v == "null" ? null : v);
                                })
                              ]))
                          .toList()),
                ))),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
                onPressed: () => setState(() {
                      eateryList(context: context).data!.add(Eatery());
                      eateryList(context: context).sync();
                    }),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Icon(Icons.add), Text("添加")],
                ))
          ],
        ),
        const SizedBox(
          height: 40,
        )
      ]),
    ]);
  }
}
