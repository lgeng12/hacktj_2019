
class Friend {
  String name;
  int treeCondition;
  int numTrees;

  Friend({this.name, this.treeCondition, this.numTrees});

  factory Friend.fromJson(Map<String, dynamic> json) {
    return new Friend(
      name: json['name'],
      treeCondition: json['treeCondition'],  // idk why but necessary
      numTrees: json['numTrees'],
    );
  }

  toJson() {
    return {
      'name': name,
      'treeCondition': treeCondition,
      'numTrees': numTrees,
    };
  }
}