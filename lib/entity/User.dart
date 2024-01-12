import 'package:easyfin/entity/contact.dart';

import 'accounts.dart';

class user {
  static final user singleton = user._internal();
  user._internal();
  static user get shared => singleton;
  static String uid = "";
  static String name = "";
  static String firstName = "";
  static String lastName = "";
  static String email = "";
  static String token = "";
  static String customerID = "";
  static Accounts selectedAccount = Accounts("", "", "", 0, "", "", "", "", "");
  static List<Contact> contacts = [];
  static List<Accounts> accounts = [];
}