// lib/utils/date_utils.dart
class DateUtilits{
  static String formatarDataParaISO(String data) {
    final partes = data.split('/');
    if (partes.length == 3) {
      return "${partes[2]}-${partes[1]}-${partes[0]}";
    }
    return data; // Retorna a data original se não puder ser formatada
  }
}