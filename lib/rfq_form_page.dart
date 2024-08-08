import 'package:flutter/material.dart';
import 'package:factory_app/theme_manager.dart';

class RFQFormPage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;
  final Function(String) onLanguageChanged;

  RFQFormPage({
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.onLanguageChanged,
  });

  @override
  _RFQFormPageState createState() => _RFQFormPageState();
}

class _RFQFormPageState extends State<RFQFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _productDescriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _contactInfoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Request for Quotation'),
        backgroundColor: theme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _companyNameController,
                decoration: InputDecoration(
                  labelText: 'Company Name',
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
                    return 'Please enter your company name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _productDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Product Description',
                  fillColor: widget.isDarkMode ? Colors.grey[800] : Colors.grey[200],
                  filled: true,
                  labelStyle: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'Quantity',
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
                    return 'Please enter the quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _contactInfoController,
                decoration: InputDecoration(
                  labelText: 'Contact Information',
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
                    return 'Please enter your contact information';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Process the RFQ form
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Request for Quotation sent successfully!')),
                    );
                  }
                },
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
