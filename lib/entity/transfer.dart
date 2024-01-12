class Transfer {
  static final Transfer singleton = Transfer._internal();
  Transfer._internal();
  static String note = "";
  static num amount = 0;
  static String accountId = "";
  static String receiverPancard = "";
  static String receiverName = "";
}