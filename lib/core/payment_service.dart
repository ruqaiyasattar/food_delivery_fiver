import 'package:stripe_payment/stripe_payment.dart';

class PaymentService{
  PaymentService(){
    StripePayment.setOptions(
      StripeOptions(publishableKey: "pk_test_7rIm1tVeDwAjVfKlJJ43zvxh00l6XVUQ7V",),
    );
  }
}