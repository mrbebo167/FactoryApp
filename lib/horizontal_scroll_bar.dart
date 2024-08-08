import 'package:flutter/material.dart';

class HorizontalScrollBar extends StatelessWidget {
  final List<String> companies;

  HorizontalScrollBar({required this.companies});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: companies.length,
        itemBuilder: (context, index) {
          return Container(
            width: 250,
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text(
                companies[index],
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }
}
