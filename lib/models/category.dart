class Category {

  int? id;
  String name;
  String description;

  Category({
    this.id,
    required this.name,
    required this.description,
  });

  factory Category.fromJson(Map<String,dynamic> json){
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String,dynamic> toCreateJson(){
    return{
      "name":name,
      "description":description
    };
  }

  Map<String,dynamic> toUpdateJson(){
    return{
      "id": id,
      "name":name,
      "description":description
    };
  }

}