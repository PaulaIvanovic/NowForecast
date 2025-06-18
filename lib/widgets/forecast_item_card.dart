import 'package:flutter/material.dart';
import 'package:nowforecast/app/utils/app_colors.dart'; // Import custom colors

class ForecastItemCard extends StatelessWidget {
  final String day;
  final String temp;
  final String iconPath;
  final Color backgroundColor;
  final Color contentColor;
  final ImageErrorWidgetBuilder?
  errorBuilder; // Made nullable as it might not always be required for every Image widget

  const ForecastItemCard({
    super.key,
    required this.day,
    required this.temp,
    required this.iconPath,
    required this.backgroundColor,
    required this.contentColor,
    this.errorBuilder, // Optional, can be omitted if not needed
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppColors.borderColor, // Using the centralized color
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            iconPath,
            height: 30,
            width: 30,
            errorBuilder: errorBuilder,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              day,
              style: TextStyle(
                fontSize: 16,
                color: contentColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            temp,
            style: TextStyle(
              fontSize: 16,
              color: contentColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
