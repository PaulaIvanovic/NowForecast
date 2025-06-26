// lib/widgets/forecast_item_card.dart

import 'package:flutter/material.dart';

class ForecastItemCard extends StatelessWidget {
  final String day;
  final String temp;
  final String iconPath; // This will now be a URL or local asset path
  final Color backgroundColor;
  final Color contentColor;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder; // <--- This parameter is now correct

  const ForecastItemCard({
    super.key,
    required this.day,
    required this.temp,
    required this.iconPath,
    required this.backgroundColor,
    required this.contentColor,
    this.errorBuilder, // <--- Make it optional
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Text(day, style: TextStyle(fontSize: 18, color: contentColor)),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
              width: 30,
              height: 30,
              child: Image.network(
                // Use Image.network as it's an icon URL from API
                iconPath,
                height: 30,
                width: 30,
                fit: BoxFit.contain,
                // Directly use the errorBuilder passed from the parent
                errorBuilder: errorBuilder, // <--- CORRECTED THIS LINE
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              temp,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 18, color: contentColor),
            ),
          ),
        ],
      ),
    );
  }
}
