#import "PaymentLauncherPlugin.h"

#if __has_include(<payment_launcher/payment_launcher-Swift.h>)
#import <payment_launcher/payment_launcher-Swift.h>
#else
#import "payment_launcher-Swift.h"
#endif

@implementation PaymentLauncherPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [SwiftPaymentLauncherPlugin registerWithRegistrar:registrar];
}
@end
