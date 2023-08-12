import 'package:note_app/models/plant_attributes.dart';
import 'package:note_app/models/product.dart';

class Product {
  final String? category_id;
  final String? category_name;
  final String name;
  final String img_url;
  final String price;
  final String description;
  final PlantAttributes attributes;
  final String type;
  final int stock;

  Product(
      {this.category_id,
      this.category_name,
      required this.description,
      required this.name,
      required this.price,
      required this.img_url,
      required this.attributes,
      required this.stock,
      required this.type});

  // Convert Product object to a map
  Map<String, dynamic> toMap() {
    return {
      'category_id': category_id,
      'category_name': category_name,
      'name': name,
      'img_url': img_url,
      'price': price,
      'stock' : stock,
      'description': description,
      'attributes': attributes.toMap(),
      'type': type.toString()
    };
  }
}
