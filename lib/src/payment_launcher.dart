import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:payment_launcher/src/models.dart';
import 'package:payment_launcher/src/utils.dart';

class PaymentLauncher {
  static const MethodChannel _channel = MethodChannel('payment_launcher');

  /// Returns list of installed map apps on the device.
  static Future<List<AvailablePayment>> get installedPayments async {
    debugPrint('start_get');
    final maps = await _channel.invokeMethod('getInstalledPayments');
    debugPrint('end_get: ${maps.toString()}');
    return List<AvailablePayment>.from(
      maps.map((map) => AvailablePayment.fromJson(map)),
    );
  }

  /// Opens map app specified in [paymentType]
  /// and shows marker at [coords]
  static Future<dynamic> showPayment({
    required PaymentType paymentType,
    required String title,
    String? description,
  }) async {
    final Map<String, String?> args = {
      'paymentType': Utils.enumToString(paymentType),
      'title': title,
      'description': description,
    };
    return _channel.invokeMethod('showMarker', args);
  }

  /// Returns boolean indicating if payment app is installed
  static Future<bool?> isPaymentAvailable(PaymentType paymentType) async {
    return _channel.invokeMethod(
      'isPaymentAvailable',
      {'paymentType': Utils.enumToString(paymentType)},
    );
  }
}
