import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'customer_settings_page.dart';
import 'l10n/app_localization.dart';
import 'order_page.dart';
import 'auth_service.dart';
import 'profile_page_customer.dart';
import 'package:provider/provider.dart';

class CustomerHomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;
  final Function(String) onLanguageChanged;

  CustomerHomeScreen({
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.onLanguageChanged,
  });

  @override
  _CustomerHomeScreenState createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context)!;

    List<Widget> _pages = [
      CustomerHomePage(isDarkMode: widget.isDarkMode),
      OrderPage(
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.onThemeChanged,
        onLanguageChanged: widget.onLanguageChanged,
      ),
      CustomerSettingsPage(
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.onThemeChanged,
        onLanguageChanged: widget.onLanguageChanged,
      ),
      CustomerProfilePage(
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.onThemeChanged,
        onLanguageChanged: widget.onLanguageChanged,
      ),
    ];

    return Scaffold(
      backgroundColor: widget.isDarkMode ? Color(0xFF1F1F1F) : Colors.white,
      appBar: AppBar(
        title: Text(localizations.translate('customerHome') ?? 'Customer Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: localizations.translate('home') ?? 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: localizations.translate('orders') ?? 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: localizations.translate('settings') ?? 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: localizations.translate('profile') ?? 'Profile',
          ),
        ],
        selectedItemColor: widget.isDarkMode ? Colors.yellow : Colors.yellow,
        unselectedItemColor: widget.isDarkMode ? Colors.white : Colors.grey,
        backgroundColor: widget.isDarkMode ? Color(0xFF1F1F1F) : Colors.white,
      ),
    );
  }
}

class CustomerHomePage extends StatelessWidget {
  final bool isDarkMode;

  CustomerHomePage({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context)!;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('orders').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              localizations.translate('noOrdersFound') ?? 'No orders found',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          );
        }

        final orders = snapshot.data!.docs;

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return ListTile(
              title: Text(
                '${localizations.translate('order')} ${order['product']}',
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              subtitle: Text(
                '${localizations.translate('quantity')}: ${order['quantity']}',
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              trailing: Text(
                '${localizations.translate('status')}: ${order['status']}',
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
            );
          },
        );
      },
    );
  }
}

class OrderPage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;
  final Function(String) onLanguageChanged;

  OrderPage({
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.onLanguageChanged,
  });

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _productController = TextEditingController();
  final _quantityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _placeOrder() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await FirebaseFirestore.instance.collection('orders').add({
          'product': _productController.text,
          'quantity': int.parse(_quantityController.text),
          'status': 'Pending',
          'userId': FirebaseAuth.instance.currentUser?.uid,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order placed successfully')),
        );

        _productController.clear();
        _quantityController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error placing order: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: widget.isDarkMode ? Color(0xFF1F1F1F) : Colors.white,
      appBar: AppBar(
        title: Text(localizations.translate('placeOrder') ?? 'Place Order'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _productController,
                      decoration: InputDecoration(
                        labelText: localizations.translate('product') ?? 'Product',
                        fillColor: widget.isDarkMode ? Colors.grey[800] : Colors.grey[200],
                        filled: true,
                        labelStyle: TextStyle(
                          color: widget.isDarkMode ? Colors.white : Colors.black,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localizations.translate('pleaseEnterAProduct') ?? 'Please enter a product';
                        }
                        return null;
                      },
                      style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _quantityController,
                      decoration: InputDecoration(
                        labelText: localizations.translate('quantity') ?? 'Quantity',
                        fillColor: widget.isDarkMode ? Colors.grey[800] : Colors.grey[200],
                        filled: true,
                        labelStyle: TextStyle(
                          color: widget.isDarkMode ? Colors.white : Colors.black,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localizations.translate('pleaseEnterAQuantity') ?? 'Please enter a quantity';
                        }
                        if (int.tryParse(value) == null) {
                          return localizations.translate('pleaseEnterAValidNumber') ?? 'Please enter a valid number';
                        }
                        return null;
                      },
                      style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black),
                    ),
                    SizedBox(height: 20),
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _placeOrder,
                            child: Text(localizations.translate('placeOrder') ?? 'Place Order'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black, backgroundColor: Colors.yellow,
                              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                              textStyle: TextStyle(fontSize: 16),
                            ),
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
