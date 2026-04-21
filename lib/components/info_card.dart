import 'package:flutter/material.dart';
import '../styles/app_colors.dart';

class InfoCard extends StatelessWidget {
  final dynamic content;
  final String? label;

  const InfoCard({
    super.key,
    required this.content,
    this.label
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,

        children: [
          if (label != null)
            Container(
              padding: EdgeInsets.only(left: 12, right: 12, bottom: 8),
              child: Text(
                label!,
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
          Container(
            width: double.infinity,
            child: content,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.blue,
              border: Border.all(color: AppColors.blue, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
          )
        ],
      );
    }
}