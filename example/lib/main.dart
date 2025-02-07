import 'package:flutter/material.dart';
import 'package:payment_launcher_example/lib/show_payment.dart';

void main() => runApp(const PaymentLauncherDemo());

class PaymentLauncherDemo extends StatefulWidget {
  const PaymentLauncherDemo({super.key});

  @override
  State<PaymentLauncherDemo> createState() => _PaymentLauncherDemoState();
}

class _PaymentLauncherDemoState extends State<PaymentLauncherDemo> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Payment Launcher Demo'),
        ),
        body: ShowPayment(),
      ),
    );
  }
}
