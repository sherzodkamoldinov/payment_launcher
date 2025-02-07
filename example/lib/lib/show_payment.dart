import 'package:flutter/material.dart';

import 'maps_sheet.dart';

class ShowPayment extends StatefulWidget {
  const ShowPayment({super.key});

  @override
  State<ShowPayment> createState() => _ShowPaymentState();
}

class _ShowPaymentState extends State<ShowPayment> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              debugPrint('pressed');
              MapsSheet.show(
                context: context,
                onMapTap: (map) {
                  map.showPayment(
                    title: 'Payment Launcher',
                  );
                },
              );
            },
            child: const Text('Show Payment'),
          )
        ],
      ),
    );
  }
}
