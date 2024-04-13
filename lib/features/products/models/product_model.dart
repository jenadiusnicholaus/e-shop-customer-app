class ProductModel {
  int? count;
  dynamic next;
  dynamic previous;
  List<Results>? results;

  ProductModel({this.count, this.next, this.previous, this.results});

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['count'] = count;
    data['next'] = next;
    data['previous'] = previous;
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
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
  dynamic price;
  dynamic sellingPrice;
  dynamic discountPrice;
  String? barcodeId;
  String? image;
  dynamic published;
  dynamic warranty;
  int? warrantyDays;
  List<ProductDeliveryInfos>? productDeliveryInfos;

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
      this.image,
      this.published,
      this.warranty,
      this.warrantyDays,
      this.productDeliveryInfos});

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
    published = json['published'];
    warranty = json['warranty'];
    warrantyDays = json['warranty_days'];
    if (json['product_delivery_infos'] != null) {
      productDeliveryInfos = <ProductDeliveryInfos>[];
      json['product_delivery_infos'].forEach((v) {
        productDeliveryInfos!.add(ProductDeliveryInfos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category'] = category;
    data['client'] = client;
    data['name'] = name;
    data['code'] = code;
    data['description'] = description;
    data['status'] = status;
    data['price'] = price;
    data['selling_price'] = sellingPrice;
    data['discount_price'] = discountPrice;
    data['barcode_id'] = barcodeId;
    data['image'] = image;
    data['published'] = published;
    data['warranty'] = warranty;
    data['warranty_days'] = warrantyDays;
    if (productDeliveryInfos != null) {
      data['product_delivery_infos'] =
          productDeliveryInfos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductDeliveryInfos {
  int? id;
  int? product;
  int? client;
  dynamic freeDelivery;
  int? deliveryDays;
  dynamic deliveryCost;

  ProductDeliveryInfos(
      {this.id,
      this.product,
      this.client,
      this.freeDelivery,
      this.deliveryDays,
      this.deliveryCost});

  ProductDeliveryInfos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = json['product'];
    client = json['client'];
    freeDelivery = json['free_delivery'];
    deliveryDays = json['delivery_days'];
    deliveryCost = json['delivery_cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product'] = product;
    data['client'] = client;
    data['free_delivery'] = freeDelivery;
    data['delivery_days'] = deliveryDays;
    data['delivery_cost'] = deliveryCost;
    return data;
  }
}
