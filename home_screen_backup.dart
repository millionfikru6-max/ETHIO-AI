import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class HouseDetailsScreen extends StatefulWidget {
  final PropertyModel property;

  const HouseDetailsScreen({super.key, required this.property});

  @override
  State<HouseDetailsScreen> createState() => _HouseDetailsScreenState();
}

class _HouseDetailsScreenState extends State<HouseDetailsScreen> {
  int _currentImageIndex = 0;

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    final Uri whatsappUri = Uri.parse("https://wa.me/$phoneNumber");
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: 'ETB ', decimalDigits: 0);

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                stretch: true,
                backgroundColor: Colors.white,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                actions: [
                  Consumer<FavoriteProvider>(
                    builder: (context, favorites, _) {
                      final isFav = favorites.isPropertyFavorite(widget.property.id);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.red : Colors.black,
                            ),
                            onPressed: () => favorites.togglePropertyFavorite(widget.property),
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.share_outlined, color: Colors.black),
                        onPressed: () => Share.share('Check out this property: ${widget.property.title}'),
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 450,
                          viewportFraction: 1.0,
                          onPageChanged: (index, reason) {
                            setState(() => _currentImageIndex = index);
                          },
                        ),
                        items: widget.property.images.map((url) {
                          return Image.network(url, fit: BoxFit.cover, width: double.infinity);
                        }).toList(),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "${_currentImageIndex + 1}/${widget.property.images.length}",
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.property.isForRent ? "For Rent" : "For Sale",
                              style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.orange, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                widget.property.rating.toString(),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(" (${widget.property.reviewCount} reviews)",
                                  style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.property.title,
                        style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.grey[600], size: 18),
                          const SizedBox(width: 4),
                          Text("${widget.property.address}, ${widget.property.city}",
                              style: TextStyle(color: Colors.grey[600], fontSize: 15)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildAmenity(FontAwesomeIcons.bed, "${widget.property.bedrooms} Beds"),
                          _buildAmenity(FontAwesomeIcons.bath, "${widget.property.bathrooms} Baths"),
                          _buildAmenity(FontAwesomeIcons.kitchenSet, "${widget.property.kitchens} Kitchen"),
                          _buildAmenity(FontAwesomeIcons.car, widget.property.parkingAvailable ? "Parking" : "No Park"),
                        ],
                      ),
                      const Divider(height: 40),
                      const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Text(
                        widget.property.description,
                        style: TextStyle(color: Colors.grey[700], height: 1.6, fontSize: 15),
                      ),
                      const Divider(height: 40),
                      const Text("Location", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(widget.property.latitude, widget.property.longitude),
                              zoom: 15,
                            ),
                            markers: {
                              Marker(
                                markerId: const MarkerId('prop_loc'),
                                position: LatLng(widget.property.latitude, widget.property.longitude),
                              ),
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -5))],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Price", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                        Text(
                          widget.property.isForRent
                              ? "${currencyFormat.format(widget.property.monthlyRentPrice)}/mo"
                              : currencyFormat.format(widget.property.salePrice),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      _buildContactButton(
                        icon: FontAwesomeIcons.whatsapp,
                        color: Colors.green,
                        onPressed: () => _openWhatsApp(widget.property.ownerPhone),
                      ),
                      const SizedBox(width: 12),
                      _buildContactButton(
                        icon: Icons.phone,
                        color: Colors.black,
                        onPressed: () => _makePhoneCall(widget.property.ownerPhone),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenity(IconData icon, String label) {
    return Column(
      children: [
        FaIcon(icon, color: Colors.grey[700], size: 20),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _buildContactButton({required IconData icon, required Color color, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}