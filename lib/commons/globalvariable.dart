import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../entity/accounts.dart';

class GlobalVariable {
  static final GlobalVariable singleton = GlobalVariable._internal();
  GlobalVariable._internal();
  static QRViewController? qrViewController;
  static bool isAccountsLoaded = false;
  static List<Accounts> accounts = [];
  static String customerID = "";
  static GlobalVariable get shared => singleton;
}