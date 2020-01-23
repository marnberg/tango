import 'dart:io';
import 'package:tango/tango.dart' as tango;
import 'package:args/args.dart';

const sourceDirecory = 'source';
const sourceDirecoryAbbr = 's';

const destinationDirecory = 'destination';
const destinationDirecoryAbbr = 'd';

ArgResults argResults;

void main(List<String> arguments) {
  exitCode = 0; // presume success
  final parser = ArgParser()
    ..addOption(sourceDirecory, abbr: sourceDirecoryAbbr)
    ..addOption(
      destinationDirecory,
      abbr: destinationDirecoryAbbr,
    );
  argResults = parser.parse(arguments);
  final configFiles = argResults.rest;

  tango.handleConfigs(argResults[sourceDirecory], argResults[destinationDirecory], configFiles);
}
