import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

Future<Logger> createLogger() async {
  return Logger(
      filter: ProductionFilter(),
      output: MultiOutput([
        ConsoleOutput(),
        FileOutput(
            overrideExisting: true,
            file: File(Platform.isAndroid
                ? "${(await getApplicationCacheDirectory()).path}/latest.log"
                : "latest.log"))
      ]),
      printer: PrefixPrinter(SimplePrinter(colors: false)));
}
