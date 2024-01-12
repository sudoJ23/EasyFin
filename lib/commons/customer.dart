class Customer {
  static final Customer singleton = Customer._internal();
  Customer._internal();
  static String id = "";
  static String firstName = "";
  static String lastName = "";
  static String city = "";
  static String phoneNumber = "";
  static String pancardNumber = "";
  static String dob = "";
  static Customer get shared => singleton;
}