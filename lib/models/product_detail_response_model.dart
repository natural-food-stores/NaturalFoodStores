class ProductDetailResponseModel {
  ProductDetailResponseModel({
    required this.code,
    required this.status,
    required this.message,
    required this.result,
  });

  final int? code;
  final bool? status;
  final String? message;
  final ProductDetailResult? result;

  factory ProductDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailResponseModel(
      code: json["code"],
      status: json["status"],
      message: json["message"],
      result: json["result"] == null
          ? null
          : ProductDetailResult.fromJson(json["result"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "message": message,
        "result": result?.toJson(),
      };
}

class ProductDetailResult {
  ProductDetailResult({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
    required this.shelfLife,
    required this.manufacturer,
    required this.disclaimer,
    required this.actualPrice,
    required this.discountPrice,
    required this.finalPrice,
    required this.stock,
    required this.imageUrl,
    required this.categoryId,
    required this.isBestSelling,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? name;
  final String? description;
  final String? quantity;
  final int? shelfLife;
  final String? manufacturer;
  final String? disclaimer;
  final dynamic actualPrice;
  final dynamic discountPrice;
  final dynamic finalPrice;
  final int? stock;
  final String? imageUrl;
  final int? categoryId;
  final bool? isBestSelling;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ProductDetailResult.fromJson(Map<String, dynamic> json) {
    return ProductDetailResult(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      quantity: json["quantity"],
      shelfLife: json["shelf_life"],
      manufacturer: json["manufacturer"],
      disclaimer: json["disclaimer"],
      actualPrice: json["actual_price"],
      discountPrice: json["discount_price"],
      finalPrice: json["final_price"],
      stock: json["stock"],
      imageUrl: json["image_url"],
      categoryId: json["category_id"],
      isBestSelling: json["is_best_selling"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "quantity": quantity,
        "shelf_life": shelfLife,
        "manufacturer": manufacturer,
        "disclaimer": disclaimer,
        "actual_price": actualPrice,
        "discount_price": discountPrice,
        "final_price": finalPrice,
        "stock": stock,
        "image_url": imageUrl,
        "category_id": categoryId,
        "is_best_selling": isBestSelling,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
