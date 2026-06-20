import 'package:flutter/material.dart';

class DriverProvider extends ChangeNotifier {
  List<DriverModel> _drivers = [];

  List<DriverModel> get drivers {
    List<DriverModel> sortedList = List.from(_drivers);
    sortedList.sort((a, b) {
      if (a.isFeatured != b.isFeatured) {
        return a.isFeatured ? -1 : 1;
      }
      return b.rating.compareTo(a.rating);
    });
    return sortedList;
  }

  List<DriverModel> get availableDrivers =>
      drivers.where((driver) => driver.isAvailable).toList();

  List<DriverModel> get featuredDrivers =>
      drivers.where((driver) => driver.isFeatured).toList();

  void setDrivers(List<DriverModel> drivers) {
    _drivers = drivers;
    notifyListeners();
  }

  void addDriver(DriverModel driver) {
    if (!_drivers.any((d) => d.id == driver.id)) {
      _drivers.add(driver);
      notifyListeners();
    }
  }

  void updateDriver(DriverModel updatedDriver) {
    final index = _drivers.indexWhere((d) => d.id == updatedDriver.id);
    if (index != -1) {
      _drivers[index] = updatedDriver;
      notifyListeners();
    }
  }

  void removeDriver(String driverId) {
    _drivers.removeWhere((d) => d.id == driverId);
    notifyListeners();
  }

  DriverModel? getDriverById(String driverId) {
    try {
      return _drivers.firstWhere((d) => d.id == driverId);
    } catch (_) {
      return null;
    }
  }

  List<DriverModel> searchDrivers(String query) {
    if (query.isEmpty) return drivers;
    final lowerQuery = query.toLowerCase();
    return drivers.where((driver) {
      return driver.fullName.toLowerCase().contains(lowerQuery) ||
          driver.city.toLowerCase().contains(lowerQuery) ||
          driver.vehicleType.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  List<DriverModel> filterByCity(String city) {
    if (city.isEmpty) return drivers;
    return drivers
        .where((driver) => driver.city.toLowerCase() == city.toLowerCase())
        .toList();
  }

  List<DriverModel> filterByVehicleType(String vehicleType) {
    if (vehicleType.isEmpty) return drivers;
    return drivers
        .where((driver) =>
            driver.vehicleType.toLowerCase() == vehicleType.toLowerCase())
        .toList();
  }

  List<DriverModel> filterByMinimumRating(double rating) {
    return drivers.where((driver) => driver.rating >= rating).toList();
  }
}