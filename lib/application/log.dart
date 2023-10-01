import 'dart:io';

import 'package:eat_in_cczu/application/bus.dart';
import 'package:logger/logger.dart';

Future<Logger> createLogger() async {
  return Logger(
      filter: ProductionFilter(),
      output: MultiOutput([
        ConsoleOutput(),
        FileOutput(
            overrideExisting: true,
            file: File(Platform.isAndroid
                ? "${await getAndroidPath()}/latest.log"
                : "latest.log"))
      ]),
      printer: PrefixPrinter(SimplePrinter(colors: false)));
}
