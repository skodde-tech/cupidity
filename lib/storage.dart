import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:speed_dating/objects/settingsObject.dart';

///
/// Storage Handler for saving the index
///
class Storage {
  /// Get the local path to where we can save the file.
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  /// Get the local file.
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/settings.txt');
  }

  /// Read in the settings
  Future<Settings> readSettings() async {
    try {

      // Get the file
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();
      var settingsParam = contents.split(",");

      // Read in the settings values in to settings object
      Settings s = new Settings();
      s.timerActive = settingsParam[0] == "1";
      s.secondsInTimer = int.parse(settingsParam[1]);
      s.nsfwActive = settingsParam[2] == "1";

      //Return the settings
      return s;

    } catch (e) {
      // If encountering an error, return 0
      // To ways to error:
      // 1. A Actual error
      // 2. The file does not exist.
      return new Settings();
    }
  }

  /// Write in the new index
  Future<File> writeSettings(Settings s) async {
    //Get the file
    final file = await _localFile;

    String valueString = "";

    var timerActiveStr = boolToString(s.timerActive);
    var secondsInTimerStr = s.secondsInTimer.toString();
    var nsfwActiveStr = boolToString(s.nsfwActive);

    valueString = timerActiveStr + "," + secondsInTimerStr + "," + nsfwActiveStr;

    // Write the file
    return file.writeAsString(valueString);
  }

  String boolToString(bool a){
    if (a){
      return "1";
    }
    else{
      return "0";
    }
  }
}