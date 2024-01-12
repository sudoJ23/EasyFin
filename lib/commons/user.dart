import 'package:easyfin/commons/customer.dart';

class User {
  static final User singleton = User._internal();
  User._internal();
  static String id = "";
  static String name = "";
  static String email = "";
  static String token = "";
  static Customer? customer;
  static User get shared => singleton;
}