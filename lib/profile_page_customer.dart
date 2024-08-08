import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'theme_manager.dart';

class CustomerProfilePage extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final Function(String) onLanguageChanged;


  CustomerProfilePage({
    required this.onThemeChanged,
    required this.onLanguageChanged,
  });

  @override
  _CustomerProfilePageState createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<CustomerProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? _displayName;
  String? _email;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _displayName = user.displayName;
        _email = user.email;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateDisplayName(_displayName);
        await user.updateEmail(_email!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
        setState(() {
          _isEditing = false;
        });
      }
    }
  }

  Future<void> _changePassword() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: user.email!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset email sent!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(
              _isEditing ? Icons.save : Icons.edit,
            ),
            onPressed: () {
              if (_isEditing) {
                _updateProfile();
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(user?.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No profile data found'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final firstName = userData['firstName'] ?? 'N/A';
          final lastName = userData['lastName'] ?? 'N/A';

          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 100,
                      left: MediaQuery.of(context).size.width / 2 - 50,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(user?.photoURL ?? 'assets/placeholder.png'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.person),
                          title: Text('Name', style: theme.textTheme.bodyLarge),
                          subtitle: _isEditing
                              ? TextFormField(
                                  initialValue: '$firstName $lastName',
                                  decoration: InputDecoration(hintText: 'Enter your name'),
                                  onSaved: (value) {
                                    _displayName = value;
                                  },
                                )
                              : Text('$firstName $lastName', style: theme.textTheme.bodyMedium),
                        ),
                        ListTile(
                          leading: Icon(Icons.email),
                          title: Text('Email', style: theme.textTheme.bodyLarge),
                          subtitle: _isEditing
                              ? TextFormField(
                                  initialValue: _email,
                                  decoration: InputDecoration(hintText: 'Enter your email'),
                                  onSaved: (value) {
                                    _email = value;
                                  },
                                )
                              : Text('${user?.email ?? 'N/A'}', style: theme.textTheme.bodyMedium),
                        ),
                        if (!_isEditing) ...[
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.lock),
                            title: Text('Change Password', style: theme.textTheme.bodyLarge),
                            onTap: _changePassword,
                          ),
                        ],
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'RFQ History',
                            style: theme.textTheme.headlineSmall,
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('rfqs')
                              .where('userId', isEqualTo: user?.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return Center(child: Text('No RFQs found', style: theme.textTheme.bodyLarge));
                            }

                            final rfqs = snapshot.data!.docs;

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: rfqs.length,
                              itemBuilder: (context, index) {
                                final rfq = rfqs[index];
                                return ListTile(
                                  title: Text('RFQ: ${rfq['title']}', style: theme.textTheme.bodyLarge),
                                  subtitle: Text('Status: ${rfq['status']}', style: theme.textTheme.bodyMedium),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
