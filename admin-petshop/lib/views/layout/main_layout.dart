import 'package:flutter/material.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _getSelectedIndex(BuildContext context) {
    final route = ModalRoute.of(context)?.settings.name;
    switch (route) {
      case '/': return 0;
      case '/agendamentos': return 1;
      case '/contatos': return 2;
      case '/fotos': return 3;
      case '/depoimentos': return 4;
      default: return 0;
    }
  }

  void _onMenuSelected(int index, BuildContext context) {
    switch (index) {
      case 0: Navigator.pushReplacementNamed(context, '/'); break;
      case 1: Navigator.pushReplacementNamed(context, '/agendamentos'); break;
      case 2: Navigator.pushReplacementNamed(context, '/contatos'); break;
      case 3: Navigator.pushReplacementNamed(context, '/fotos'); break;
      case 4: Navigator.pushReplacementNamed(context, '/depoimentos'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 800;
    final selectedIndex = _getSelectedIndex(context);

    final navigationDestinations = [
      const NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text('Dashboard')),
      const NavigationRailDestination(icon: Icon(Icons.event), label: Text('Agendamentos')),
      const NavigationRailDestination(icon: Icon(Icons.contacts), label: Text('Contatos')),
      const NavigationRailDestination(icon: Icon(Icons.photo_library), label: Text('Fotos')),
      const NavigationRailDestination(icon: Icon(Icons.star), label: Text('Depoimentos')),
    ];

    return Scaffold(
      appBar: isDesktop ? null : AppBar(title: const Text('Patas Felizes Admin')),
      drawer: isDesktop ? null : Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepOrange),
              child: Text('Patas Felizes', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(title: const Text('Dashboard'), selected: selectedIndex == 0, onTap: () => _onMenuSelected(0, context)),
            ListTile(title: const Text('Agendamentos'), selected: selectedIndex == 1, onTap: () => _onMenuSelected(1, context)),
            ListTile(title: const Text('Contatos (Leads)'), selected: selectedIndex == 2, onTap: () => _onMenuSelected(2, context)),
            ListTile(title: const Text('Fotos Antes/Depois'), selected: selectedIndex == 3, onTap: () => _onMenuSelected(3, context)),
            ListTile(title: const Text('Depoimentos'), selected: selectedIndex == 4, onTap: () => _onMenuSelected(4, context)),
          ],
        ),
      ),
      body: Row(
        children: [
          if (isDesktop)
            NavigationRail(
              extended: true,
              selectedIndex: selectedIndex,
              onDestinationSelected: (idx) => _onMenuSelected(idx, context),
              destinations: navigationDestinations,
              leading: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Patas Felizes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
          if (isDesktop) const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
