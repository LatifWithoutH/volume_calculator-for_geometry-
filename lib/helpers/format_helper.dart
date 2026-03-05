import 'package:intl/intl.dart';

String formatAngkaIndonesia(double angka) {
  return NumberFormat('#,##0.##', 'id_ID').format(angka);
}

double konversiVolume(double volumeCm3, String targetUnit) {
  switch (targetUnit) {
    case 'cm³': return volumeCm3;
    case 'm³': return volumeCm3 / 1000000;
    case 'liter': return volumeCm3 / 1000;
    default: return volumeCm3;
  }
}
