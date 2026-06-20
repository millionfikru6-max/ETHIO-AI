import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- Drivers Methods ---

  CollectionReference<DriverModel> get _driversRef =>
      _db.collection('drivers').withConverter<DriverModel>(
            fromFirestore: (snapshot, _) =>
                DriverModel.fromFirestore(snapshot.data()!, snapshot.id),
            toFirestore: (driver, _) => {
              'fullName': driver.fullName,
              'profilePicture': driver.profilePicture,
              'phoneNumber': driver.phoneNumber,
              'age': driver.age,
              'height': driver.height,
              'weight': driver.weight,
              'nationality': driver.nationality,
              'gender': driver.gender,
              'languages': driver.languages,
              'experienceYears': driver.experienceYears,
              'vehicleType': driver.vehicleType,
              'city': driver.city,
              'isAvailable': driver.isAvailable,
              'bio': driver.bio,
              'rating': driver.rating,
              'reviewCount': driver.reviewCount,
              'isFeatured': driver.isFeatured,
            },
          );

  Future<void> addDriver(DriverModel driver) async {
    try {
      await _driversRef.doc(driver.id).set(driver);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateDriver(DriverModel driver) async {
    try {
      await _driversRef.doc(driver.id).update({
        'fullName': driver.fullName,
        'profilePicture': driver.profilePicture,
        'phoneNumber': driver.phoneNumber,
        'age': driver.age,
        'height': driver.height,
        'weight': driver.weight,
        'nationality': driver.nationality,
        'gender': driver.gender,
        'languages': driver.languages,
        'experienceYears': driver.experienceYears,
        'vehicleType': driver.vehicleType,
        'city': driver.city,
        'isAvailable': driver.isAvailable,
        'bio': driver.bio,
        'rating': driver.rating,
        'reviewCount': driver.reviewCount,
        'isFeatured': driver.isFeatured,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteDriver(String driverId) async {
    try {
      await _driversRef.doc(driverId).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<DriverModel?> getDriverById(String driverId) async {
    try {
      final doc = await _driversRef.doc(driverId).get();
      return doc.data();
    } catch (e) {
      return null;
    }
  }

  Stream<List<DriverModel>> getDrivers() {
    return _driversRef.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => doc.data()).toList());
  }

  Stream<List<DriverModel>> getFeaturedDrivers() {
    return _driversRef
        .where('isFeatured', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // --- Properties Methods ---

  CollectionReference<PropertyModel> get _propertiesRef =>
      _db.collection('properties').withConverter<PropertyModel>(
            fromFirestore: (snapshot, _) => PropertyModel.fromFirestore(snapshot),
            toFirestore: (property, _) => property.toMap(),
          );

  Future<void> addProperty(PropertyModel property) async {
    try {
      await _propertiesRef.doc(property.id).set(property);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProperty(PropertyModel property) async {
    try {
      await _propertiesRef.doc(property.id).update(property.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProperty(String propertyId) async {
    try {
      await _propertiesRef.doc(propertyId).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<PropertyModel?> getPropertyById(String propertyId) async {
    try {
      final doc = await _propertiesRef.doc(propertyId).get();
      return doc.data();
    } catch (e) {
      return null;
    }
  }

  Stream<List<PropertyModel>> getProperties() {
    return _propertiesRef.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => doc.data()).toList());
  }

  Stream<List<PropertyModel>> getFeaturedProperties() {
    return _propertiesRef
        .where('isFeatured', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // --- User Methods ---

  Future<void> createUser(String uid, Map<String, dynamic> data) async {
    try {
      await _db.collection('users').doc(uid).set(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<DocumentSnapshot> getUser(String uid) async {
    try {
      return await _db.collection('users').doc(uid).get();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      await _db.collection('users').doc(uid).update(data);
    } catch (e) {
      rethrow;
    }
  }
}