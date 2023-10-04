import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Personal extends StatefulWidget {
  const Personal({super.key});

  @override
  State<StatefulWidget> createState() => _PersonalState();
}

class _PersonalState extends State<Personal> {
  Widget makeCard(
    IconData icon,
    String text,
  ) {
    return SizedBox(
        width: 400,
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
              ),
              const SizedBox(
                height: 100,
                width: 20,
              ),
              Text(
                text,
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Center(
          child: Text(
            "Personal",
            style: TextStyle(fontSize: 60, fontWeight: FontWeight.w800),
          ),
        ),
        Column(children: [
          Material(
              child: Ink(
                  child: InkWell(
            child: makeCard(Icons.payment, "支付宝"),
            onTap: () => launchUrlString(
                "https://ur.alipay.com/_6Wl0hI8KuZaNaAi2JrFC2O",
                mode: LaunchMode.inAppWebView),
          ))),
          Material(
              child: Ink(
                  child: InkWell(
            child: makeCard(Icons.card_membership, "一卡通"),
            onTap: () => launchUrlString("http://sso.cczu.edu.cn/sso/login",
                mode: LaunchMode.inAppWebView),
          )))
        ])
      ],
    );
  }
}
