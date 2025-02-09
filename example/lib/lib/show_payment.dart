import 'package:flutter/material.dart';
import 'package:payment_launcher/payment_launcher.dart';

import 'maps_sheet.dart';

class ShowPayment extends StatefulWidget {
  const ShowPayment({super.key});

  @override
  State<ShowPayment> createState() => _ShowPaymentState();
}

class _ShowPaymentState extends State<ShowPayment> {
  int availablePayments = 0;

  @override
  void initState() {
    getAvailablePayments();
    super.initState();
  }

  void getAvailablePayments() {
    PaymentLauncher.installedPayments.then((payments) {
      setState(() {
        availablePayments = payments.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(width: double.maxFinite),
          Text('Available payments: $availablePayments'),
          SizedBox(height: 25),
          ElevatedButton(
            onPressed: () {
              MapsSheet.show(
                context: context,
                onMapTap: (map) {
                  map.showPayment(
                    title: 'Payment Launcher',
                  );
                },
              );
            },
            child: const Text('Show Payment Bottom Sheet'),
          )
        ],
      ),
    );
  }
}
