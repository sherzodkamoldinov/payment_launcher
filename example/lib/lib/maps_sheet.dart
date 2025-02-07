import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payment_launcher/payment_launcher.dart';

class MapsSheet {
  static void show({
    required BuildContext context,
    required void Function(AvailablePayment map) onMapTap,
  }) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<List<AvailablePayment>>(
          future: PaymentLauncher.installedPayments,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<AvailablePayment> availableMaps = snapshot.data ?? [];
              return Column(
                children: <Widget>[
                  if (availableMaps.isEmpty)
                    const Center(child: Text('No payments found'))
                  else
                    Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final data = availableMaps[index];
                          return ListTile(
                            onTap: () => onMapTap(data),
                            title: Text(data.paymentName),
                            leading: SizedBox(
                              width: 30,
                              height: 30,
                              child: SvgPicture.asset(
                                data.icon,
                                height: 30.0,
                                width: 30.0,
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(height: 2),
                        itemCount: availableMaps.length,
                      ),
                    ),
                ],
              );
            } else if (snapshot.hasError) {
              return SizedBox(
                height: 300, // Укажите подходящую высоту
                child: Center(child: Text(snapshot.error.toString())),
              );
            } else {
              return const SizedBox(
                height: 300,
                child: Center(child: CircularProgressIndicator.adaptive()),
              );
            }
          },
        );
      },
    );
  }
}
