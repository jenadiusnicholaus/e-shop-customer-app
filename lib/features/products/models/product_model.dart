class ProductModel {
  int? count;
  dynamic next;
  dynamic previous;
  List<Results>? results;
  int? pageSize;

  ProductModel(
      {this.count, this.next, this.previous, this.results, this.pageSize});

  ProductModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }
    pageSize = json['page_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    data['page_size'] = this.pageSize;
    return data;
  }
}

class Results {
  int? id;
  int? category;
  int? client;
  String? name;
  String? code;
  String? description;
  String? status;
  dynamic? price;
  dynamic? sellingPrice;
  dynamic discountPrice;
  String? barcodeId;
  String? image;

  Results(
      {this.id,
      this.category,
      this.client,
      this.name,
      this.code,
      this.description,
      this.status,
      this.price,
      this.sellingPrice,
      this.discountPrice,
      this.barcodeId,
      this.image});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    client = json['client'];
    name = json['name'];
    code = json['code'];
    description = json['description'];
    status = json['status'];
    price = json['price'];
    sellingPrice = json['selling_price'];
    discountPrice = json['discount_price'];
    barcodeId = json['barcode_id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
    data['client'] = this.client;
    data['name'] = this.name;
    data['code'] = this.code;
    data['description'] = this.description;
    data['status'] = this.status;
    data['price'] = this.price;
    data['selling_price'] = this.sellingPrice;
    data['discount_price'] = this.discountPrice;
    data['barcode_id'] = this.barcodeId;
    data['image'] = this.image;
    return data;
  }
}
