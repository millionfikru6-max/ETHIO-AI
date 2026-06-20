import 'package:cloud_firestore/cloud_firestore.dart';

class PropertyModel {
  final String id;
  final List<String> images;
  final String title;
  final String description;
  final String ownerName;
  final String ownerPhone;
  final String city;
  final String address;
  final int bedrooms;
  final int bathrooms;
  final int kitchens;
  final bool parkingAvailable;
  final double? monthlyRentPrice;
  final double? salePrice;
  final double latitude;
  final double longitude;
  final bool isForRent;
  final bool isForSale;
  final bool isFeatured;
  final double rating;
  final int reviewCount;

  PropertyModel({
    required this.id,
    required this.images,
    required this.title,
    required this.description,
    required this.ownerName,
    required this.ownerPhone,
    required this.city,
    required this.address,
    required this.bedrooms,
    required this.bathrooms,
    required this.kitchens,
    required this.parkingAvailable,
    this.monthlyRentPrice,
    this.salePrice,
    required this.latitude,
    required this.longitude,
    required this.isForRent,
    required this.isForSale,
    this.isFeatured = false,
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  factory PropertyModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PropertyModel(
      id: doc.id,
      images: List<String>.from(data['images'] ?? []),
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      ownerName: data['ownerName'] ?? '',
      ownerPhone: data['ownerPhone'] ?? '',
      city: data['city'] ?? '',
      address: data['address'] ?? '',
      bedrooms: data['bedrooms'] ?? 0,
      bathrooms: data['bathrooms'] ?? 0,
      kitchens: data['kitchens'] ?? 0,
      parkingAvailable: data['parkingAvailable'] ?? false,
      monthlyRentPrice: (data['monthlyRentPrice'] as num?)?.toDouble(),
      salePrice: (data['salePrice'] as num?)?.toDouble(),
      latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
      isForRent: data['isForRent'] ?? false,
      isForSale: data['isForSale'] ?? false,
      isFeatured: data['isFeatured'] ?? false,
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: data['reviewCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'images': images,
      'title': title,
      'description': description,
      'ownerName': ownerName,
      'ownerPhone': ownerPhone,
      'city': city,
      'address': address,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'kitchens': kitchens,
      'parkingAvailable': parkingAvailable,
      'monthlyRentPrice': monthlyRentPrice,
      'salePrice': salePrice,
      'latitude': latitude,
      'longitude': longitude,
      'isForRent': isForRent,
      'isForSale': isForSale,
      'isFeatured': isFeatured,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }

  PropertyModel copyWith({
    String? id,
    List<String>? images,
    String? title,
    String? description,
    String? ownerName,
    String? ownerPhone,
    String? city,
    String? address,
    int? bedrooms,
    int? bathrooms,
    int? kitchens,
    bool? parkingAvailable,
    double? monthlyRentPrice,
    double? salePrice,
    double? latitude,
    double? longitude,
    bool? isForRent,
    bool? isForSale,
    bool? isFeatured,
    double? rating,
    int? reviewCount,
  }) {
    return PropertyModel(
      id: id ?? this.id,
      images: images ?? this.images,
      title: title ?? this.title,
      description: description ?? this.description,
      ownerName: ownerName ?? this.ownerName,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      city: city ?? this.city,
      address: address ?? this.address,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      kitchens: kitchens ?? this.kitchens,
      parkingAvailable: parkingAvailable ?? this.parkingAvailable,
      monthlyRentPrice: monthlyRentPrice ?? this.monthlyRentPrice,
      salePrice: salePrice ?? this.salePrice,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isForRent: isForRent ?? this.isForRent,
      isForSale: isForSale ?? this.isForSale,
      isFeatured: isFeatured ?? this.isFeatured,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }
}