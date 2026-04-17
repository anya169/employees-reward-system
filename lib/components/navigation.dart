import 'package:flutter/material.dart';
import '../styles/app_colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.blue,
      unselectedItemColor: AppColors.grey,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          activeIcon: Icon(Icons.home),
          label: 'Мероприятия',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          activeIcon: Icon(Icons.people),
          label: 'Магазин',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.grade),
          activeIcon: Icon(Icons.card_giftcard),
          label: 'Рейтинги',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          activeIcon: Icon(Icons.person),
          label: 'Профиль',
        ),
      ],
    );
  }
}