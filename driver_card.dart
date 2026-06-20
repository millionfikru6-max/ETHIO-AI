import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class DriverDetailsScreen extends StatelessWidget {
  final DriverModel driver;

  const DriverDetailsScreen({super.key, required this.driver});

  Future<void> _makeCall(String phone) async {
    final Uri url = Uri.parse('tel:$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _openWhatsApp(String phone) async {
    final Uri url = Uri.parse('https://wa.me/${phone.replaceAll('+', '')}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 450,
                pinned: true,
                stretch: true,
                backgroundColor: theme.scaffoldBackgroundColor,
                leading: _buildCircleButton(
                  context,
                  Icons.arrow_back,
                  () => Navigator.pop(context),
                ),
                actions: [
                  _buildCircleButton(
                    context,
                    Icons.share_outlined,
                    () => Share.share('Check out driver ${driver.fullName} on EthioFinder!'),
                  ),
                  Consumer<FavoriteProvider>(
                    builder: (context, fav, _) {
                      final isFav = fav.isDriverFavorite(driver.id);
                      return _buildCircleButton(
                        context,
                        isFav ? Icons.favorite : Icons.favorite_border,
                        () => fav.toggleDriverFavorite(driver),
                        iconColor: isFav ? Colors.red : null,
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [StretchMode.zoomBackground],
                  background: Hero(
                    tag: 'driver_${driver.id}',
                    child: CachedNetworkImage(
                      imageUrl: driver.profilePicture,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: Colors.grey[300]),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.person, size: 80, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (driver.isAvailable)
                            _buildBadge("Available", Colors.green, Colors.white),
                          if (driver.isFeatured) ...[
                            const SizedBox(width: 8),
                            _buildBadge("Featured", Colors.orange, Colors.white),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        driver.fullName,
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            driver.city,
                            style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatCard(context, "${driver.experienceYears}+", "Years Exp"),
                          _buildStatCard(context, driver.rating.toString(), "Rating"),
                          _buildStatCard(context, driver.reviewCount.toString(), "Reviews"),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _buildSectionTitle("About Driver"),
                      const SizedBox(height: 12),
                      Text(
                        driver.bio,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          height: 1.6,
                          color: isDark ? Colors.grey[400] : Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle("General Information"),
                      const SizedBox(height: 16),
                      _buildInfoGrid([
                        _buildInfoItem("Age", "${driver.age} Years"),
                        _buildInfoItem("Gender", driver.gender),
                        _buildInfoItem("Nationality", driver.nationality),
                        _buildInfoItem("Languages", driver.languages.join(", ")),
                        _buildInfoItem("Height/Weight", "${driver.height} / ${driver.weight}"),
                        _buildInfoItem("Vehicle", driver.vehicleType),
                      ]),
                      const SizedBox(height: 32),
                      _buildSectionTitle("Safety & Verification"),
                      const SizedBox(height: 16),
                      _buildSafetyItem(Icons.verified_user, "Verified Profile", "Identity documents verified"),
                      _buildSafetyItem(Icons.shield, "Safe Driving History", "Background checked"),
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
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driver.fullName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.orange, size: 14),
                            const SizedBox(width: 4),
                            Text(driver.rating.toString(), style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildActionButton(
                    icon: FontAwesomeIcons.whatsapp,
                    color: Colors.green,
                    onTap: () => _openWhatsApp(driver.phoneNumber),
                  ),
                  const SizedBox(width: 12),
                  _buildActionButton(
                    icon: Icons.phone,
                    color: Colors.blue,
                    onTap: () => _makeCall(driver.phoneNumber),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton(BuildContext context, IconData icon, VoidCallback onTap, {Color? iconColor}) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.8),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: iconColor ?? Colors.black, size: 20),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label) {
    return Container(
      width: (MediaQuery.of(context).size.width - 72) / 3,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
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

  Widget _buildInfoGrid(List<Widget> children) {
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: children.map((item) => SizedBox(width: 150, child: item)).toList(),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      ],
    );
  }

  Widget _buildSafetyItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.blue, size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}