import 'package:flutter/material.dart';
import 'l10n/app_localization.dart';
import 'theme_manager.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(localizations.translate('aboutUs') ?? 'About Us'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        iconTheme: theme.appBarTheme.iconTheme,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            _buildSectionTitle(localizations.translate('mission') ?? 'Our Mission', theme),
            _buildSectionContent(localizations.translate('missionContent') ?? 'Our mission is to...', theme),
            _buildSectionTitle(localizations.translate('vision') ?? 'Our Vision', theme),
            _buildSectionContent(localizations.translate('visionContent') ?? 'Our vision is to...', theme),
            _buildSectionTitle(localizations.translate('values') ?? 'Our Values', theme),
            _buildSectionContent(localizations.translate('valuesContent') ?? 'We value...', theme),
            _buildSectionTitle(localizations.translate('ourTeam') ?? 'Our Team', theme),
            _buildSectionContent(localizations.translate('teamContent') ?? 'Meet our dedicated team...', theme),
            _buildSectionTitle(localizations.translate('contactInfo') ?? 'Contact Information', theme),
            _buildContactInfo(localizations, theme),
            _buildSectionTitle(localizations.translate('gallery') ?? 'Gallery', theme),
            _buildImageGallery(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSectionContent(String content, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        content,
        style: theme.textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildContactInfo(AppLocalizations localizations, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildContactItem(Icons.phone, localizations.translate('phone') ?? 'Phone: +123 456 7890', theme),
        _buildContactItem(Icons.email, localizations.translate('email') ?? 'Email: info@factoryapp.com', theme),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: theme.iconTheme.color),
          SizedBox(width: 8),
          Text(
            text,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery() {
    return Container(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildGalleryImage('assets/about1.jpg'),
          _buildGalleryImage('assets/about2.jpg'),
          _buildGalleryImage('assets/about3.jpg'),
        ],
      ),
    );
  }

  Widget _buildGalleryImage(String imagePath) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
