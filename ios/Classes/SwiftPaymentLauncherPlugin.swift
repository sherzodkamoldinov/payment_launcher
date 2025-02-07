import Flutter
import UIKit

private enum PaymentType: String {
    case uzumBank
    case clickSuperApp
    case payme
    
    func type() -> String {
        return self.rawValue
    }
}

private class Payment {
    let paymentName: String
    let paymentType: PaymentType
    let urlPrefix: String?
    
    init(paymentName: String, paymentType: PaymentType, urlPrefix: String?) {
        self.paymentName = paymentName
        self.paymentType = paymentType
        self.urlPrefix = urlPrefix
    }
    
    func toPayment() -> [String: String] {
        return [
            "paymentName": paymentName,
            "paymentType": paymentType.type()
        ]
    }
}

private let payments: [Payment] = [
    Payment(paymentName: "Payme", paymentType: .payme, urlPrefix: "paycom://"),
    Payment(paymentName: "Uzum Bank", paymentType: .uzumBank, urlPrefix: "uzumbank://"),
    Payment(paymentName: "Click SuperApp", paymentType: .clickSuperApp, urlPrefix: "clickuz://")
]

private func getPaymentByRawPaymentType(type: String) -> Payment? {
    return payments.first(where: { $0.paymentType.type() == type })
}

private func isPaymentAvailable(payment: Payment?) -> Bool {
    guard let payment = payment, let urlPrefix = payment.urlPrefix else {
        return false
    }
    return UIApplication.shared.canOpenURL(URL(string: urlPrefix)!)
}

private func launchPaymentApp(paymentType: PaymentType) {
    guard let payment = getPaymentByRawPaymentType(type: paymentType.rawValue),
          let urlPrefix = payment.urlPrefix,
          let paymentURL = URL(string: urlPrefix) else {
        return
    }
    UIApplication.shared.open(paymentURL, options: [:], completionHandler: nil)
}

public class SwiftPaymentLauncherPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "payment_launcher", binaryMessenger: registrar.messenger())
        let instance = SwiftPaymentLauncherPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getInstalledPayments":
            result(payments.filter({ isPaymentAvailable(payment: $0) }).map({ $0.toPayment() }))
            return;

        case "showMarker":
            guard let args = call.arguments as? NSDictionary,
                  let paymentTypeRaw = args["paymentType"] as? String,
                  let paymentType = PaymentType(rawValue: paymentTypeRaw),
                  let payment = getPaymentByRawPaymentType(type: paymentTypeRaw) else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid or missing arguments", details: nil))
                return
            }

            if !isPaymentAvailable(payment: payment) {
                result(FlutterError(code: "PAYMENT_NOT_AVAILABLE", message: "Payment app is not installed on the device", details: nil))
                return
            }

            launchPaymentApp(paymentType: paymentType)
            result(nil)

        case "isPaymentAvailable":
            guard let args = call.arguments as? NSDictionary,
                  let paymentType = args["paymentType"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid or missing arguments", details: nil))
                return
            }
            let payment = getPaymentByRawPaymentType(type: paymentType)
            result(isPaymentAvailable(payment: payment))

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
