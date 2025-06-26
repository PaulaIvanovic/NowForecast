import 'package:flutter/material.dart';

class ForecastItemCard extends StatelessWidget {
  final String day;
  final String temp;
  final String iconPath;
  final Color backgroundColor;
  final Color contentColor;
  final ImageErrorWidgetBuilder? errorBuilder; // Keep the errorBuilder for robustness

  const ForecastItemCard({
    super.key,
    required this.day,
    required this.temp,
    required this.iconPath,
    required this.backgroundColor,
    required this.contentColor,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // This flexible combination ensures text doesn't overflow
            // and the temperature stays on the right.
            Flexible(
              child: Row(
                children: [
                  // 1. Icon on the left
                  Image.asset(
                    iconPath,
                    width: 35,
                    height: 35,
                    errorBuilder: errorBuilder, // Use the passed error builder
                  ),
                  const SizedBox(width: 16),
                  // 2. Day Text
                  Text(
                    day,
                    style: TextStyle(color: contentColor, fontWeight: FontWeight.bold, fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            // 3. Temperature on the right
            Text(
              temp,
              style: TextStyle(color: contentColor, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
