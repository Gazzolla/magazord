import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:mobx/mobx.dart';

part 'products.g.dart';

class Category {
  late String id;
  String name;
  Widget icon;

  Category({required this.name, required this.icon}) {
    id = Uuid().v4();
  }
}

class Product extends _ProductBase with _$Product {
  Product({
    required super.id, // Passa para o construtor de BaseProduct
    required super.title,
    required super.description,
    required super.category,
    required super.price,
    required super.discountPercentage,
    required super.rating,
    required super.stock,
    required super.tags,
    required super.brand,
    required super.sku,
    required super.weight,
    required super.dimensions,
    required super.warrantyInformation,
    required super.shippingInformation,
    required super.availabilityStatus,
    required super.reviews,
    required super.returnPolicy,
    required super.minimumOrderQuantity,
    required super.meta,
    required super.images,
    required super.base64Images,
    required super.thumbnail,
  }) {
    if (base64Images.isNotEmpty) {
      super.setImage(base64Images.first);
    }
  }

  factory Product.fromJson(Map<String, dynamic> data) {
    return Product(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      category: data['category'],
      price: data['price'],
      discountPercentage: data['discountPercentage'].toDouble(),
      rating: data['rating'],
      stock: data['stock'],
      tags: List<String>.from(data['tags']),
      brand: data['brand'] ?? "",
      sku: data['sku'],
      weight: data['weight'].toDouble(),
      dimensions: Dimensions.fromJson(data['dimensions']),
      warrantyInformation: data['warrantyInformation'],
      shippingInformation: data['shippingInformation'],
      availabilityStatus: data['availabilityStatus'],
      reviews: [],
      returnPolicy: data['returnPolicy'],
      minimumOrderQuantity: data['minimumOrderQuantity'],
      meta: Meta.fromJson(data['meta']),
      images: List<String>.from(data['images']),
      thumbnail: data['thumbnail'],
      base64Images: List<String>.from(data['base64Images'] ?? []),
    );
  }
}

abstract class _ProductBase with Store {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String brand;
  final String sku;
  final double weight;
  final Dimensions dimensions;
  final String warrantyInformation;
  final String shippingInformation;
  final String availabilityStatus;
  final List<Review> reviews;
  final String returnPolicy;
  final int minimumOrderQuantity;
  final Meta meta;
  final List<String> images;
  final List<String> base64Images;
  final String thumbnail;

  _ProductBase({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    required this.brand,
    required this.sku,
    required this.weight,
    required this.dimensions,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.availabilityStatus,
    required this.reviews,
    required this.returnPolicy,
    required this.minimumOrderQuantity,
    required this.meta,
    required this.images,
    required this.thumbnail,
    required this.base64Images,
  });

  @observable
  String actualImage = "";

  @action
  void setImage(String image) => actualImage = image;

  factory _ProductBase.fromJson(Map<String, dynamic> data) {
    return Product(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      category: data['category'],
      price: data['price'],
      discountPercentage: data['discountPercentage'].toDouble(),
      rating: data['rating'],
      stock: data['stock'],
      tags: List<String>.from(data['tags']),
      brand: data['brand'] ?? "",
      sku: data['sku'],
      weight: data['weight'].toDouble(),
      dimensions: Dimensions.fromJson(data['dimensions']),
      warrantyInformation: data['warrantyInformation'],
      shippingInformation: data['shippingInformation'],
      availabilityStatus: data['availabilityStatus'],
      reviews: [],
      returnPolicy: data['returnPolicy'],
      minimumOrderQuantity: data['minimumOrderQuantity'],
      meta: Meta.fromJson(data['meta']),
      images: List<String>.from(data['images']),
      thumbnail: data['thumbnail'],
      base64Images: List<String>.from(data['base64Images'] ?? []),
    );
  }

  Future convertImagesToBase64() async {
    for (var imageUrl in images) {
      var base64Image = await _convertImageToBase64(imageUrl);
      base64Images.add(base64Image);
    }
  }

  Future<String> _convertImageToBase64(String url) async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Uint8List bytes = response.bodyBytes;
      String base64String = base64Encode(bytes);
      return base64String;
    } else {
      throw Exception('Failed to load image');
    }
  }

  Map toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'tags': tags,
      'brand': brand,
      'sku': sku,
      'weight': weight,
      'dimensions': {
        'width': dimensions.width,
        'height': dimensions.height,
        'depth': dimensions.depth,
      },
      'warrantyInformation': warrantyInformation,
      'shippingInformation': shippingInformation,
      'availabilityStatus': availabilityStatus,
      'reviews': reviews.map((review) => review.toMap()).toList(),
      'returnPolicy': returnPolicy,
      'minimumOrderQuantity': minimumOrderQuantity,
      'meta': {
        'createdAt': meta.createdAt,
        'updatedAt': meta.updatedAt,
        'barcode': meta.barcode,
        'qrCode': meta.qrCode,
      },
      'images': images,
      'thumbnail': thumbnail,
      "base64Images": base64Images,
    };
  }
}

class Dimensions {
  final double width;
  final double height;
  final double depth;

  Dimensions({
    required this.width,
    required this.height,
    required this.depth,
  });

  factory Dimensions.fromJson(Map<String, dynamic> json) {
    return Dimensions(
      width: json['width'].toDouble(),
      height: json['height'].toDouble(),
      depth: json['depth'].toDouble(),
    );
  }
}

class Review {
  final double rating;
  final String comment;
  final String date;
  final String reviewerName;
  final String reviewerEmail;

  Review({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rating: json['rating'].toDouble(),
      comment: json['comment'],
      date: json['date'],
      reviewerName: json['reviewerName'],
      reviewerEmail: json['reviewerEmail'],
    );
  }

  toMap() => {
        "rating": rating,
        "comment": comment,
        "date": date,
        "reviewerName": reviewerName,
        "reviewerEmail": reviewerEmail,
      };
}

class Meta {
  final String createdAt;
  final String updatedAt;
  final String barcode;
  final String qrCode;

  Meta({
    required this.createdAt,
    required this.updatedAt,
    required this.barcode,
    required this.qrCode,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      barcode: json['barcode'],
      qrCode: json['qrCode'],
    );
  }
}
