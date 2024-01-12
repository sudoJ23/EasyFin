class Transaction {
  String id = "";
  String transactionType = "";
  String sender = "";
  String receiver = "";
  String dateIssued = "";
  String direction = "";
  num amount = 0;

  Transaction(this.id, this.transactionType, this.sender, this.receiver, this.dateIssued, this.amount, this.direction);
}