import 'package:flutter/material.dart';
import 'package:paystack_flutter/paystack_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paystack Flutter Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: (){
                PaystackFlutter().pay(
                    context: context,
                    secretKey: 'YOUR PAYSTACK_SECRET_KEY', // Your Paystack secret key.
                    amount: 60000, // The amount to be charged in the smallest currency unit. If amount is 600, multiply by 100(600*100)
                    email: 'theelitedevelopers1@gmail.com', // The customer's email address.
                    callbackUrl: 'https://callback.com', // The URL to which Paystack will redirect the user after the transaction.
                    showProgressBar: true, // If true, it shows progress bar to inform user an action is in progress when getting checkout link from Paystack.
                    paymentOptions: [PaymentOption.card, PaymentOption.bankTransfer, PaymentOption.mobileMoney],
                    currency: Currency.NGN,
                    metaData: {
                      "product_name": "Nike Sneakers",
                      "product_quantity": 3,
                      "product_price": 24000
                    }, // Additional metadata to be associated with the transaction
                    onSuccess: (paystackCallback){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Transaction Successful::::${paystackCallback.reference}'),
                            backgroundColor: Colors.blue,
                          ));
                    }, // A callback function for when the payment is successful.
                    onCancelled: (paystackCallback){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Transaction Failed/Not successful::::${paystackCallback.reference}'),
                            backgroundColor: Colors.red,
                          ));
                  }, // A callback function for when the payment is canceled.
                );
              },
              child: const Text(
                'Pay with Paystack',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
