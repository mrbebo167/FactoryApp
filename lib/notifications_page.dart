import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'l10n/app_localization.dart';

class NotificationsPage extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;
  final Function(String) onLanguageChanged;

  NotificationsPage({
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF1F1F1F) : Colors.white,
      appBar: AppBar(
        title: Text(localizations.translate('notifications') ?? 'Notifications'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').where('isAccepted', isEqualTo: false).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                localizations.translate('noNotificationsFound') ?? 'No notifications found',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            );
          }

          final registrations = snapshot.data!.docs;

          return ListView.builder(
            itemCount: registrations.length,
            itemBuilder: (context, index) {
              final registration = registrations[index];
              return ListTile(
                title: Text(
                  '${registration['firstName']} ${registration['lastName']}',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                subtitle: Text(
                  localizations.translate('statusPending') ?? 'Status: Pending',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () async {
                        try {
                          await FirebaseFirestore.instance.collection('users').doc(registration.id).update({
                            'isAccepted': true,
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${registration['firstName']} ${registration['lastName']} has been accepted.')),
                          );
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(localizations.translate('failedToAccept') ?? 'Failed to accept: $error')),
                          );
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () async {
                        try {
                          await FirebaseFirestore.instance.collection('users').doc(registration.id).delete();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${registration['firstName']} ${registration['lastName']} has been rejected.')),
                          );
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(localizations.translate('failedToReject') ?? 'Failed to reject: $error')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
