import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Common {
  const Common();

  static storageSet(String key, String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(key, value);
  }

  static storageGet(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(key);
  }

  static bool equalsIgnoreCase(String string1, String string2) {
    return string1?.toLowerCase() == string2?.toLowerCase();
  }

  static String toJson(dynamic object) {
    var encoder = JsonEncoder.withIndent('     ');
    return encoder.convert(object);
  }

  static dynamic fromJson(String jsonString) {
    if (jsonString == null){
      return null;
    }
    return json.decode(jsonString);
  }

  static bool hasKeyIgnoreCase(Map map, String key) {
    return map.keys.any((x) => equalsIgnoreCase(x, key));
  }

  static String encodeMap(Map data) {
    return data.keys.map((key) {
      var k = Uri.encodeComponent(key.toString());
      var v = Uri.encodeComponent(data[key].toString());
      return '$k=$v';
    }).join('&');
  }

  static List<String> split(String string, String separator, {int max = 0}) {
    var result = List<String>();

    if (separator.isEmpty) {
      result.add(string);
      return result;
    }

    while (true) {
      var index = string.indexOf(separator, 0);
      if (index == -1 || (max > 0 && result.length >= max)) {
        result.add(string);
        break;
      }

      result.add(string.substring(0, index));
      string = string.substring(index + separator.length);
    }

    return result;
  }
}
