class Friend {
  String name;
  int treeCondition;
  int numTrees;

  Friend({this.name, this.treeCondition, this.numTrees});

  factory Friend.fromJson(Map<String, dynamic> json) {
    return new Friend(
      name: json['name'] as String,
      treeCondition: json['treeCondition'] as int,
      numTrees: json['numTrees'] as int,
    );
  }
}