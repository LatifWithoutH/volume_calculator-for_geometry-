import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static const String _keyInputUnit = 'input_unit';
  static const String _keyOutputUnit = 'output_unit';

  // --- INPUT UNIT (Diatur di Settings) ---
  static Future<void> setInputUnit(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyInputUnit, unit);
  }

  static Future<String> getInputUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyInputUnit) ?? 'cm';
  }

  // --- OUTPUT UNIT (Diatur di Setiap Page) ---
  static Future<void> setOutputUnit(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyOutputUnit, unit);
  }

  static Future<String> getOutputUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyOutputUnit) ?? 'cm³';
  }
}