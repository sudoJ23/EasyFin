import 'package:easyfin/entity/transaction.dart';

class Transactions {
  static final Transactions singleton = Transactions._internal();
  Transactions._internal();
  static List<Transaction> list = [];
}