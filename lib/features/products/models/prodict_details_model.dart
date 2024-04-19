class ProductDetailsModel {
  bool? success;
  int? statusCode;
  String? message;
  Data? data;

  ProductDetailsModel({this.success, this.statusCode, this.message, this.data});

  ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  dynamic category;
  int? client;
  String? name;
  String? code;
  String? description;
  String? status;
  double? price;
  dynamic sellingPrice;
  double? discountPrice;
  dynamic barcodeId;
  String? image;
  List<ProductImages>? productImages;
  List<ProductReviews>? productReviews;
  List<ProductSpecifications>? productSpecifications;
  List<ProductColors>? productColors;
  List<ProductSize>? productSize;
  bool? published;

  Data(
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
      this.productImages,
      this.productReviews,
      this.productSpecifications,
      this.productColors,
      this.productSize,
      this.published});

  Data.fromJson(Map<String, dynamic> json) {
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
    if (json['product_images'] != null) {
      productImages = <ProductImages>[];
      json['product_images'].forEach((v) {
        productImages!.add(ProductImages.fromJson(v));
      });
    }
    if (json['product_reviews'] != null) {
      productReviews = <ProductReviews>[];
      json['product_reviews'].forEach((v) {
        productReviews!.add(ProductReviews.fromJson(v));
      });
    }
    if (json['product_specifications'] != null) {
      productSpecifications = <ProductSpecifications>[];
      json['product_specifications'].forEach((v) {
        productSpecifications!.add(new ProductSpecifications.fromJson(v));
      });
    }
    if (json['product_colors'] != null) {
      productColors = <ProductColors>[];
      json['product_colors'].forEach((v) {
        productColors!.add(new ProductColors.fromJson(v));
      });
    }
    if (json['product_size'] != null) {
      productSize = <ProductSize>[];
      json['product_size'].forEach((v) {
        productSize!.add(new ProductSize.fromJson(v));
      });
    }
    published = json['published'];
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
    if (this.productImages != null) {
      data['product_images'] =
          this.productImages!.map((v) => v.toJson()).toList();
    }
    if (this.productReviews != null) {
      data['product_reviews'] =
          this.productReviews!.map((v) => v.toJson()).toList();
    }
    if (this.productSpecifications != null) {
      data['product_specifications'] =
          this.productSpecifications!.map((v) => v.toJson()).toList();
    }
    if (this.productColors != null) {
      data['product_colors'] =
          this.productColors!.map((v) => v.toJson()).toList();
    }
    if (this.productSize != null) {
      data['product_size'] = this.productSize!.map((v) => v.toJson()).toList();
    }
    data['published'] = this.published;
    return data;
  }
}

class ProductImages {
  int? id;
  int? product;
  int? client;
  String? image;
  String? dateCreated;

  ProductImages(
      {this.id, this.product, this.client, this.image, this.dateCreated});

  ProductImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = json['product'];
    client = json['client'];
    image = json['image'];
    dateCreated = json['date_created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product'] = this.product;
    data['client'] = this.client;
    data['image'] = this.image;
    data['date_created'] = this.dateCreated;
    return data;
  }
}

class ProductReviews {
  int? id;
  int? product;
  int? client;
  User? user;
  String? review;
  double? rating;
  String? dateCreated;

  ProductReviews(
      {this.id,
      this.product,
      this.client,
      this.user,
      this.review,
      this.rating,
      this.dateCreated});

  ProductReviews.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = json['product'];
    client = json['client'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    review = json['review'];
    rating = json['rating'];
    dateCreated = json['date_created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product'] = this.product;
    data['client'] = this.client;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['review'] = this.review;
    data['rating'] = this.rating;
    data['date_created'] = this.dateCreated;
    return data;
  }
}

class User {
  String? username;
  String? email;

  User({this.username, this.email});

  User.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    return data;
  }
}

class ProductSpecifications {
  int? id;
  int? product;
  int? client;
  String? specName;
  String? specValue;
  String? dateCreated;

  ProductSpecifications(
      {this.id,
      this.product,
      this.client,
      this.specName,
      this.specValue,
      this.dateCreated});

  ProductSpecifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = json['product'];
    client = json['client'];
    specName = json['spec_name'];
    specValue = json['spec_value'];
    dateCreated = json['date_created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product'] = this.product;
    data['client'] = this.client;
    data['spec_name'] = this.specName;
    data['spec_value'] = this.specValue;
    data['date_created'] = this.dateCreated;
    return data;
  }
}

class ProductColors {
  int? id;
  int? product;
  int? client;
  String? color;
  String? dateCreated;

  ProductColors(
      {this.id, this.product, this.client, this.color, this.dateCreated});

  ProductColors.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = json['product'];
    client = json['client'];
    color = json['color'];
    dateCreated = json['date_created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product'] = this.product;
    data['client'] = this.client;
    data['color'] = this.color;
    data['date_created'] = this.dateCreated;
    return data;
  }
}

class ProductSize {
  int? id;
  int? product;
  String? size;
  String? dateCreated;

  ProductSize({this.id, this.product, this.size, this.dateCreated});

  ProductSize.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = json['product'];
    size = json['size'];
    dateCreated = json['date_created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product'] = this.product;
    data['size'] = this.size;
    data['date_created'] = this.dateCreated;
    return data;
  }
}
