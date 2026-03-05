import 'package:intl/intl.dart';

String formatAngkaIndonesia(double angka) {
  return NumberFormat('#,##0.##', 'id_ID').format(angka);
}

// Format untuk hasil volume dengan presisi tinggi (5 desimal)
String formatVolumeHasil(double angka) {
  // Jika angka sangat kecil (< 0.00001), gunakan notasi ilmiah
  if (angka > 0 && angka < 0.00001) {
    return NumberFormat('#,##0.######E0', 'id_ID').format(angka);
  }
  
  // Jika angka sangat besar, tampilkan 2 desimal
  if (angka >= 10000) {
    return NumberFormat('#,##0.##', 'id_ID').format(angka);
  }
  
  // Untuk angka normal, tampilkan 5 desimal (hapus trailing zeros di akhir)
  String formatted = NumberFormat('#,##0.#####', 'id_ID').format(angka);
  return formatted;
}

// Konversi SEMUA ke cm³ dulu (sebagai standar internal)
double keCm3(double value, String unit) {
  switch (unit) {
    case 'mm': return value / 10;           // mm ke cm
    case 'cm': return value;                // cm ke cm
    case 'm': return value * 100;           // m ke cm
    case 'liter': return value * 1000;      // Liter ke cm³ (karena 1L = 1000cm³)
    case 'ml': return value / 1000;         // ml ke cm³ (karena 1ml = 1cm³)
    default: return value;
  }
}

// Konversi dari cm³ ke unit tujuan
String dariCm3(double volumeCm3, String targetUnit) {
  double result;
  switch (targetUnit) {
    case 'mm³':
      result = volumeCm3 * 1000;
      break;
    case 'cm³':
      result = volumeCm3;
      break;
    case 'm³':
      result = volumeCm3 / 1000000;
      break;
    case 'liter':
      result = volumeCm3 / 1000;
      break;
    case 'ml':
      result = volumeCm3;
      break;
    default:
      result = volumeCm3;
  }
  return formatVolumeHasil(result);
}

String getLabelUnit(String unit) {
  switch (unit) {
    case 'mm': return 'mm³';
    case 'cm': return 'cm³';
    case 'm': return 'm³';
    case 'liter': return 'Liter';
    case 'ml': return 'mL';
    default: return unit;
  }
}