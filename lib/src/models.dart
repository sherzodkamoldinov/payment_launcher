
import 'package:payment_launcher/src/payment_launcher.dart';
import 'package:payment_launcher/src/utils.dart';

/// Defines the payment types supported by this plugin
enum PaymentType {
  /// Uzum bank
  uzumBank,

  /// Payme
  payme,

  /// Click Super App
  clickSuperApp,
}

/// Class that holds all the information needed to launch a payment
class AvailablePayment {
  String paymentName;
  PaymentType paymentType;
  String icon;

  AvailablePayment({
    required this.paymentName,
    required this.paymentType,
    required this.icon,
  });

  /// Parses json object to [AvailablePayment]
  static AvailablePayment? fromJson(json) {
    final PaymentType? paymentType = Utils.enumFromString(PaymentType.values, json['paymentType']);
    if (paymentType != null) {
      return AvailablePayment(
        paymentName: json['paymentName'],
        paymentType: paymentType,
        icon: 'packages/payment_launcher/assets/icons/${json['paymentType'] ?? ''}.svg',
      );
    } else {
      return null;
    }
  }

  /// Launches current payment
  Future<void> showPayment({
    required String title,
    String? description,
  }) {
    return PaymentLauncher.showPayment(
      paymentType: paymentType,
      title: title,
      description: description,
    );
  }

  @override
  String toString() {
    return 'AvailableMap { mapName: $paymentName, mapType: ${Utils.enumToString(paymentType)} }';
  }
}
