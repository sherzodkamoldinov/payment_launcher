# Payment Launcher

Flutter payment launcher plugin for Uzbekistan.

Payment Launcher is a flutter plugin to find available payment installed on a device and launch.

Currently supported payments:
Payme
Uzum Bank
Click Super App

## Get started

### Add dependency

```yaml
dependencies:
  map_launcher: ^0.1.0
  flutter_svg: # only if you want to use icons as they are svgs
```

### For iOS add url schemes in Info.plist file

```
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>paycom</string>
    <string>uzumbank</string>
    <string>clickuz</string>
</array>
```

## Usage

### Get list of installed payments and launch first

```dart
import 'package:map_launcher/map_launcher.dart';

final availablePayments = await PaymentLauncher.installedPayments;
print(availablePayments); // [AvailablePayment { paymentName: Uzum Bank, mapType: uzumBank }, ...]
```

## Example

### Using with bottom sheet

```dart
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

```
## Contributing

Pull requests are welcome.

