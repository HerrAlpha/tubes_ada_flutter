class ProductDetail {
  int? id;
  String? name;
  String? description;
  String? productPict;
  int? price;
  String? createdAt;

  ProductDetail(
      {this.id,
        this.name,
        this.description,
        this.productPict,
        this.price,
        this.createdAt});

  ProductDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    productPict = json['product_pict'];
    price = json['price'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['product_pict'] = this.productPict;
    data['price'] = this.price;
    data['created_at'] = this.createdAt;
    return data;
  }
}