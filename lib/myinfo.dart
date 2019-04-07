
class MyInfo {
  String name;
  double balance;
  double maxAllowance;
  double amountSpent;
  int treeCondition;
  int numTrees;

  MyInfo({this.name, this.balance, this.maxAllowance, this.amountSpent, this.treeCondition, this.numTrees});

  factory MyInfo.fromJson(Map<String, dynamic> json) {
    return new MyInfo(
      name: json['name'],
      balance: json['balance'],
      maxAllowance: json['maxAllowance'],
      amountSpent: json['amountSpent'],
      treeCondition: json['treeCondition'],
      numTrees: json['numTrees'],
    );
  }

  toJson() {
    return {
      'name': name,
      'balance': balance,
      'maxAllowance': maxAllowance,
      'amountSpent': amountSpent,
      'treeCondition': treeCondition,
      'numTrees': numTrees,
    };
  }
}