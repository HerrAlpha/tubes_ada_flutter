class TransactionResto {
  int? id;
  String? invoiceNumber;
  int? qty;
  int? total;
  int? status;
  String? createdAt;
  String? name;
  String? productPict;
  int? price;

  TransactionResto(
      {this.id,
        this.invoiceNumber,
        this.qty,
        this.total,
        this.status,
        this.createdAt,
        this.name,
        this.productPict,
        this.price});

  TransactionResto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    invoiceNumber = json['invoice_number'];
    qty = json['qty'];
    total = json['total'];
    status = json['status'];
    createdAt = json['created_at'];
    name = json['name'];
    productPict = json['product_pict'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['invoice_number'] = this.invoiceNumber;
    data['qty'] = this.qty;
    data['total'] = this.total;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['name'] = this.name;
    data['product_pict'] = this.productPict;
    data['price'] = this.price;
    return data;
  }
}