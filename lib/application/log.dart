import 'dart:io';

import 'package:eatincczu/application/bus.dart';
import 'package:logger/logger.dart';

Future<Logger> createLogger() async {
  return Logger(
      filter: ProductionFilter(),
      output: MultiOutput([
        ConsoleOutput(),
        FileOutput(
            overrideExisting: true,
            file: File(Platform.isAndroid
                ? "${await getPlatCachePath()}/latest.log"
                : "latest.log"))
      ]),
      printer: PrefixPrinter(SimplePrinter(colors: false)));
}
