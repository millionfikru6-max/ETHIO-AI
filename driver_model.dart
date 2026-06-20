import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class DriverDetailsScreen extends StatefulWidget {
  final DriverModel driver;

  const DriverDetailsScreen({super.key, required this.driver});

  @override
  State<DriverDetailsScreen> createState() => _DriverDetailsScreenState();
}

class _DriverDetailsScreenState extends State<DriverDetailsScreen> {
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _launchWhatsApp(String phoneNumber) async {
    final String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final Uri whatsappUri = Uri.parse("https://wa.me/$cleanNumber");
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, size),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMainInfo(theme),
                      const SizedBox(height: 24),
                      _buildStatsRow(),
                      const SizedBox(height: 32),
                      _buildSectionTitle("About Driver"),
                      const SizedBox(height: 12),
                      Text(
                        widget.driver.bio,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildSectionTitle("General Information"),
                      const SizedBox(height: 16),
                      _buildInfoGrid(),
                      const SizedBox(height: 32),
                      _buildSectionTitle("Safety & Verification"),
                      const SizedBox(height: 16),
                      _buildSafetySection(theme),
                      const SizedBox(height: 32),
                      _buildSectionTitle("Reviews"),
                      const SizedBox(height: 16),
                      _buildReviewCard("Abebe K.", 5.0, "Excellent driver, very punctual and professional.", "https://i.pravatar.cc/150?u=1"),
                      _buildReviewCard("Sara M.", 4.5, "Safe driving and very helpful with luggage.", "https://i.pravatar.cc/150?u=2"),
                      const SizedBox(height: 32),
                      _buildSectionTitle("Similar Drivers"),
                      const SizedBox(height: 16),
                      _buildSimilarDriversList(),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildBottomActionBar(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Size size) {
    return Stack(
      children: [
        Hero(
          tag: 'driver_image_${widget.driver.id}',
          child: CachedNetworkImage(
            imageUrl: widget.driver.profilePicture,
            height: size.height * 0.45,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(color: Colors.grey[300]),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[200],
              child: const Icon(Icons.person, size: 100, color: Colors.grey),
            ),
          ),
        ),
        Positioned(
          top: 50,
          left: 20,
          child: _buildCircleAction(Icons.arrow_back, () => Navigator.pop(context)),
        ),
        Positioned(
          top: 50,
          right: 20,
          child: Row(
            children: [
              _buildCircleAction(Icons.share, () {
                Share.share("Check out ${widget.driver.fullName} on EthioFinder!");
              }),
              const SizedBox(width: 12),
              Consumer<FavoriteProvider>(
                builder: (context, fav, child) {
                  final isFav = fav.isDriverFavorite(widget.driver.id);
                  return _buildCircleAction(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    () => fav.toggleDriverFavorite(widget.driver),
                    iconColor: isFav ? Colors.red : null,
                  );
                },
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          child: Row(
            children: [
              if (widget.driver.isAvailable)
                _buildBadge("Available", Colors.green),
              if (widget.driver.isFeatured) ...[
                const SizedBox(width: 8),
                _buildBadge("Featured Driver", Colors.orange),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCircleAction(IconData icon, VoidCallback onTap, {Color? iconColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
        ),
        child: Icon(icon, color: iconColor ?? Colors.black, size: 20),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildMainInfo(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.driver.fullName,
          style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              widget.driver.city,
              style: GoogleFonts.inter(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatCard("${widget.driver.experienceYears}+", "Years Exp"),
        _buildStatCard(widget.driver.rating.toString(), "Rating"),
        _buildStatCard(widget.driver.reviewCount.toString(), "Reviews"),
      ],
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildInfoGrid() {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: [
        _buildInfoRow("Age", "${widget.driver.age}"),
        _buildInfoRow("Gender", widget.driver.gender),
        _buildInfoRow("Nationality", widget.driver.nationality),
        _buildInfoRow("Languages", widget.driver.languages.join(", ")),
        _buildInfoRow("Vehicle", widget.driver.vehicleType),
        _buildInfoRow("Height/Weight", "${widget.driver.height}/${widget.driver.weight}"),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 60) / 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        ],
      ),
    );
  }

  Widget _buildSafetySection(ThemeData theme) {
    return Column(
      children: [
        _buildSafetyTile(Icons.verified_user, "Verified Driver", "Identity and documents confirmed"),
        _buildSafetyTile(Icons.history, "Professional Experience", "Over ${widget.driver.experienceYears} years of service"),
        _buildSafetyTile(Icons.check_circle, "Availability Status", "Currently ready for new bookings"),
      ],
    );
  }

  Widget _buildSafetyTile(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: Colors.blue, size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(String name, double rating, String comment, String img) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(img), radius: 20),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: List.generate(5, (index) => Icon(Icons.star, color: index < rating ? Colors.orange : Colors.grey[300], size: 14)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(comment, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildSimilarDriversList() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) => _buildSimilarDriverCard(),
      ),
    );
  }

  Widget _buildSimilarDriverCard() {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network("https://i.pravatar.cc/150?u=similar", height: 100, width: 140, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Michael B.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
                Text("SUV Driver", style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                const Row(
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: 12),
                    Text(" 4.8", style: TextStyle(fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(ThemeData theme) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5))],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.driver.fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 14),
                        const SizedBox(width: 4),
                        Text("${widget.driver.rating}", style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              _buildContactButton(FontAwesomeIcons.whatsapp, Colors.green, () => _launchWhatsApp(widget.driver.phoneNumber)),
              const SizedBox(width: 12),
              _buildContactButton(Icons.phone, Colors.black, () => _makePhoneCall(widget.driver.phoneNumber)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}