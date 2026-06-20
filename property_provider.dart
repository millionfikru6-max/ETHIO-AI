import 'package:flutter/material.dart';

class PropertyProvider extends ChangeNotifier {
  List<PropertyModel> _properties = [];

  List<PropertyModel> get properties {
    List<PropertyModel> sortedList = List.from(_properties);
    sortedList.sort((a, b) {
      if (a.isFeatured != b.isFeatured) {
        return a.isFeatured ? -1 : 1;
      }
      return b.rating.compareTo(a.rating);
    });
    return sortedList;
  }

  List<PropertyModel> get featuredProperties =>
      properties.where((property) => property.isFeatured).toList();

  List<PropertyModel> get rentProperties =>
      properties.where((property) => property.isForRent).toList();

  List<PropertyModel> get saleProperties =>
      properties.where((property) => property.isForSale).toList();

  void setProperties(List<PropertyModel> properties) {
    _properties = properties;
    notifyListeners();
  }

  void addProperty(PropertyModel property) {
    if (!_properties.any((p) => p.id == property.id)) {
      _properties.add(property);
      notifyListeners();
    }
  }

  void updateProperty(PropertyModel updatedProperty) {
    final index = _properties.indexWhere((p) => p.id == updatedProperty.id);
    if (index != -1) {
      _properties[index] = updatedProperty;
      notifyListeners();
    }
  }

  void removeProperty(String propertyId) {
    _properties.removeWhere((p) => p.id == propertyId);
    notifyListeners();
  }

  PropertyModel? getPropertyById(String propertyId) {
    try {
      return _properties.firstWhere((p) => p.id == propertyId);
    } catch (_) {
      return null;
    }
  }

  List<PropertyModel> searchProperties(String query) {
    if (query.isEmpty) return properties;
    final lowerQuery = query.toLowerCase();
    return properties.where((property) {
      return property.title.toLowerCase().contains(lowerQuery) ||
          property.city.toLowerCase().contains(lowerQuery) ||
          property.address.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  List<PropertyModel> filterByCity(String city) {
    if (city.isEmpty) return properties;
    return properties
        .where((property) => property.city.toLowerCase() == city.toLowerCase())
        .toList();
  }

  List<PropertyModel> filterByBedrooms(int bedrooms) {
    return properties.where((property) => property.bedrooms >= bedrooms).toList();
  }

  List<PropertyModel> filterByBathrooms(int bathrooms) {
    return properties.where((property) => property.bathrooms >= bathrooms).toList();
  }

  List<PropertyModel> filterByMinimumRating(double rating) {
    return properties.where((property) => property.rating >= rating).toList();
  }

  List<PropertyModel> filterRentProperties() => rentProperties;

  List<PropertyModel> filterSaleProperties() => saleProperties;
}