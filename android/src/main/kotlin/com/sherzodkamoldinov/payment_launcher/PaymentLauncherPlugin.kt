package com.alexmiller.map_launcher

import android.content.Context
import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

private enum class PaymentType { payme, uzumBank, clickSuperApp}

private class PaymentModel(
    val paymentType: PaymentType,
    val paymentName: String,
    val packageName: String,
    val urlPrefix: String
) {
    fun toPayment(): Map<String, String> {
        return mapOf(
            "paymentType" to paymentType.name,
            "paymentName" to paymentName,
            "packageName" to packageName,
            "urlPrefix" to urlPrefix
        )
    }
}

class PaymentLauncherPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "payment_launcher")
        this.context = flutterPluginBinding.applicationContext
        channel.setMethodCallHandler(this)
    }

    private val payments = listOf(
        PaymentModel(PaymentType.payme, "Payme", "uz.dida.payme", "payme://"),
        PaymentModel(PaymentType.uzumBank, "Uzum Bank", "uz.kapitalbank.android", "uzumbank://"),
        PaymentModel(PaymentType.clickSuperApp, "Click Super App", "air.com.ssdsoftwaresolutions.clickuz", "clickuz://"),
    )

    private fun getInstalledPayments(): List<PaymentModel> {
        return payments.filter { payment ->
            context.packageManager?.getLaunchIntentForPackage(payment.packageName) != null
        }
    }

    private fun isPaymentAvailable(type: String): Boolean {
        val installedPayments = getInstalledPayments()
        return installedPayments.any { payment -> payment.paymentType.name == type }
    }

    private fun launchPayment(paymentType: PaymentType, result: Result) {
        val foundPayment = payments.find { payment -> payment.paymentType == paymentType }

        if (foundPayment != null) {
            val launchIntent =
                context.packageManager.getLaunchIntentForPackage(foundPayment.packageName)
            if (launchIntent != null) {
                launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                context.startActivity(launchIntent)
                result.success(null)
            } else {
                result.error("PAYMENT_NOT_FOUND", "Не удалось открыть платежное приложение", null)
            }
        } else {
            result.error("PAYMENT_NOT_FOUND", "Платежное приложение не найдено", null)
        }
    }


    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getInstalledPayments" -> {
                val installedPayments = getInstalledPayments()
                result.success(installedPayments.map { map -> map.toPayment() })
            }

            "launchPayment" -> {
                val args = call.arguments as Map<*, *>

                if (!isPaymentAvailable(args["paymentType"] as String)) {
                    result.error(
                        "PAYMENT_NOT_AVAILABLE",
                        "Payment is not installed on a device",
                        null
                    )
                    return
                }

                val paymentType = PaymentType.valueOf(args["paymentType"] as String)

                launchPayment(paymentType, result)
            }

            "isPaymentAvailable" -> {
                val args = call.arguments as Map<*, *>
                result.success(isPaymentAvailable(args["paymentType"] as String))
            }

            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
