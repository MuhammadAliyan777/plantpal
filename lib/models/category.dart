class Category {
  final String name;
  final String description;

  Category({required this.name,  required this.description});

  // Convert Product object to a map
  Map<String, dynamic> toMap() {
    return {
      'name' : name,
      'description' : description
    };
  }


   @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Category) return false;
    return name == other.name && description == other.description;
  }

  @override
  int get hashCode => name.hashCode ^ description.hashCode;


  
}
