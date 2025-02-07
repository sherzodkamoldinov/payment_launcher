import 'package:flutter/material.dart';
import 'package:payment_launcher_example/lib/show_payment.dart';

void main() => runApp(const MapLauncherDemo());

class MapLauncherDemo extends StatefulWidget {
  const MapLauncherDemo({super.key});

  @override
  State<MapLauncherDemo> createState() => _MapLauncherDemoState();
}

class _MapLauncherDemoState extends State<MapLauncherDemo> {
  int selectedTabIndex = 0;

  List<Widget> widgets = [const ShowPayment(), const ShowPayment()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Payment Launcher Demo'),
        ),
        body: widgets[selectedTabIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedTabIndex,
          onTap: (newTabIndex) => setState(() {
            selectedTabIndex = newTabIndex;
          }),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.pin_drop),
              label: 'Marker',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions),
              label: 'Directions',
            ),
          ],
        ),
      ),
    );
  }
}
