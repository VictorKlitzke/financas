import 'package:flutter/material.dart';

class FooterComponents extends StatefulWidget {
  @override
  _FooterComponentsState createState() => _FooterComponentsState();
}

class _FooterComponentsState extends State<FooterComponents> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF0066CC),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      currentIndex: _currentIndex, 
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Perfil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Configurações',
        ),
      ],
      onTap: (index) {
        setState(() {
          _currentIndex = index; 
        });
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/dashboard');
            break;
          case 1:
            Navigator.pushNamed(context, '/profile');
            break;
          case 2:
            Navigator.pushNamed(context, '/settings');
            break;
        }
      },
    );
  }
}
