import 'package:eatincczu/application/bus.dart';
import 'package:eatincczu/data/typed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
    var info = getDisplayInfo(callback: setState);
    return SingleChildScrollView(
      child: Column(children: [
        const SizedBox(
          height: 20,
        ),
        Center(
            child: Card(
                child: SizedBox(height: 300, width: 300, child: info.image))),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: RatingBar.builder(
            initialRating: 3,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {},
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(width: 500, child: info.panellist),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
                onPressed: () => setState(() {
                      Eatery eatery =
                          eateryList(context: context).getRandomEatry();
                      logger(context: context).i(eatery);
                      setInfos(eatery);
                    }),
                child: const Text(
                  "上份菜❤",
                  style: TextStyle(fontWeight: FontWeight.w700),
                )),
          ],
        ),
        const SizedBox(height: 40),
      ]),
    );
  }
}
