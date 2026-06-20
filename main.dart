import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

// --- Folder Structure ---
/*
lib/
  core/
    constants/
    theme/
    utils/
    widgets/
  data/
    models/
    repositories/
    services/
  domain/
    entities/
    usecases/
  presentation/
    providers/
    screens/
    widgets/
  main.dart
*/

// --- Main Entry Point ---

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DriverProvider()),
        ChangeNotifierProvider(create: (_) => PropertyProvider()),
      ],
      child: const EthioFinderApp(),
    ),
  );
}

class EthioFinderApp extends StatelessWidget {
  const EthioFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final langProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      title: 'EthioFinder',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      locale: langProvider.locale,
      supportedLocales: const [
        Locale('en', ''),
        Locale('am', ''),
        Locale('om', ''),
        Locale('ti', ''),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const MainNavigationScreen(),
    );
  }
}

// --- Driver Model ---

class DriverModel {
  final String id;
  final String fullName;
  final String profilePicture;
  final String phoneNumber;
  final int age;
  final String height;
  final String weight;
  final String nationality;
  final String gender;
  final List<String> languages;
  final int experienceYears;
  final String vehicleType;
  final String city;
  final bool isAvailable;
  final String bio;
  final double rating;
  final int reviewCount;
  final bool isFeatured;

  DriverModel({
    required this.id,
    required this.fullName,
    required this.profilePicture,
    required this.phoneNumber,
    required this.age,
    required this.height,
    required this.weight,
    required this.nationality,
    required this.gender,
    required this.languages,
    required this.experienceYears,
    required this.vehicleType,
    required this.city,
    required this.isAvailable,
    required this.bio,
    required this.rating,
    required this.reviewCount,
    this.isFeatured = false,
  });

  factory DriverModel.fromFirestore(Map<String, dynamic> json, String id) {
    return DriverModel(
      id: id,
      fullName: json['fullName'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      age: json['age'] ?? 0,
      height: json['height'] ?? '',
      weight: json['weight'] ?? '',
      nationality: json['nationality'] ?? 'Ethiopian',
      gender: json['gender'] ?? '',
      languages: List<String>.from(json['languages'] ?? []),
      experienceYears: json['experienceYears'] ?? 0,
      vehicleType: json['vehicleType'] ?? '',
      city: json['city'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
      bio: json['bio'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      isFeatured: json['isFeatured'] ?? false,
    );
  }
}

// --- Driver Card Widget ---

class DriverCard extends StatelessWidget {
  final DriverModel driver;

  const DriverCard({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: Image.network(
                  driver.profilePicture,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180,
                    color: Colors.grey[300],
                    child: const Icon(Icons.person, size: 50),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        driver.rating.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              if (driver.isAvailable)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Available',
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driver.fullName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.directions_car, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      driver.vehicleType,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      driver.city,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${driver.experienceYears} Years Exp.',
                      style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      ),
                      child: const Text('View Profile', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Home Screen ---

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome to",
                          style: GoogleFonts.inter(fontSize: 16, color: Colors.grey),
                        ),
                        Text(
                          "EthioFinder",
                          style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "Search drivers, houses...",
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: Colors.grey),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Categories
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Categories",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 20),
                  children: [
                    _buildCategoryItem(Icons.drive_eta, "Drivers"),
                    _buildCategoryItem(Icons.home, "Apartments"),
                    _buildCategoryItem(Icons.apartment, "Villas"),
                    _buildCategoryItem(Icons.business, "Commercial"),
                    _buildCategoryItem(Icons.landscape, "Land"),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Featured Drivers
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Featured Drivers", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(onPressed: () {}, child: const Text("See All")),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 330,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 20),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return DriverCard(
                      driver: DriverModel(
                        id: '1',
                        fullName: 'Abebe Bikila',
                        profilePicture: 'https://via.placeholder.com/300',
                        phoneNumber: '+251911000000',
                        age: 32,
                        height: '175cm',
                        weight: '70kg',
                        nationality: 'Ethiopian',
                        gender: 'Male',
                        languages: ['Amharic', 'English'],
                        experienceYears: 8,
                        vehicleType: 'SUV / Sedan',
                        city: 'Addis Ababa',
                        isAvailable: true,
                        bio: 'Professional driver with 8 years experience.',
                        rating: 4.9,
                        reviewCount: 120,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Recent Listings Placeholder
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Recent Properties",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              // Property cards would go here
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.blue, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// --- Navigation Wrapper ---

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const HomeScreen(),
    const Center(child: Text("Drivers")),
    const Center(child: Text("Houses")),
    const Center(child: Text("Favorites")),
    const Center(child: Text("Profile")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.drive_eta_outlined), activeIcon: Icon(Icons.drive_eta), label: "Drivers"),
          BottomNavigationBarItem(icon: Icon(Icons.apartment_outlined), activeIcon: Icon(Icons.apartment), label: "Houses"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), activeIcon: Icon(Icons.favorite), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

// --- Theme Data ---

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.white,
    textTheme: GoogleFonts.interTextTheme(),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFF121212),
    cardColor: const Color(0xFF1E1E1E),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF121212),
      elevation: 0,
    ),
  );
}

// --- Providers (Stubs) ---

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;
  void toggleTheme() {
    themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class LanguageProvider extends ChangeNotifier {
  Locale locale = const Locale('en', '');
  void setLanguage(String code) {
    locale = Locale(code, '');
    notifyListeners();
  }
}

class AuthProvider extends ChangeNotifier {}
class DriverProvider extends ChangeNotifier {}
class PropertyProvider extends ChangeNotifier {}