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
                    secretKey: 'sk_test_5hee6d6d5dd5dd5dd5d5',
                    amount: 60000,
                    email: 'adam@gmail.com',
                    callbackUrl: 'https://callback.com',
                    paymentOptions: [PaymentOption.card, PaymentOption.bankTransfer, PaymentOption.mobileMoney],
                    currency: Currency.NGN,
                    metaData: {
                      "product_name": "Nike Sneakers",
                      "product_quantity": 3,
                      "product_price": 24000
                    },
                    onSuccess: (paystackResponse){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Transaction Successful::::${paystackResponse.reference}'),
                            backgroundColor: Colors.blue,
                          ));
                    },
                    onCancelled: (paystackResponse){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Transaction Failed/Not successful::::${paystackResponse.reference}'),
                            backgroundColor: Colors.red,
                          ));
                });
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
