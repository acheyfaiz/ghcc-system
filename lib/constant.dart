class Constant {

  String alamat = "*GLOBAL HEARING CARE CENTRE SEGAMAT*\n"
      "No.50 Bawah, PTD 16455 Kedai/ Pejabat (JGST 24), Jalan Genuang, Kampung Abdullah, 85000 Segamat, Johor";

  String hpoffice = "07-9326414";
  String hpmobile = "016-9222939";

  String bankacc =
      "GLOBAL PRECISION SALES & SERVICES SDN BHD\n"
      "Nama Bank: RHB Bank\n"
      "No. Akaun: 21217 0000 494 77";


}

enum TypeApp {
  homevisit,
  collect_hearing_aid,
  fitting_hearing_aid,
  deposit_hearing_aid_repair,
  impression_taking
}

class GlobalDuaType {
  String title;
  int value;

  GlobalDuaType({required this.title, required this.value});
}