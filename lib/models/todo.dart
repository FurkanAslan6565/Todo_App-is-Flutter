class Todo {
  int? id;
  String? title;
  String? description;
  String? category;
  String? todoDate;
  todoMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['title'] = title;
    mapping['description'] = description;
    mapping['category'] = category;
    mapping['todoDate'] = todoDate;
    return mapping;
  }
}