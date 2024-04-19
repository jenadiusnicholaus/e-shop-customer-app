class CategoryModel {
  int? count;
  dynamic next;
  dynamic previous;
  List<Results>? results;

  CategoryModel({this.count, this.next, this.previous, this.results});

  CategoryModel.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  int? id;
  String? name;
  int? client;
  String? description;
  String? status;

  Results({this.id, this.name, this.client, this.description, this.status});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    client = json['client'];
    description = json['description'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['client'] = this.client;
    data['description'] = this.description;
    data['status'] = this.status;
    return data;
  }
}
