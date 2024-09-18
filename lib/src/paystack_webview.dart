import 'package:flutter/material.dart';
import 'package:paystack_flutter/src/core/network/api_client.dart';
import 'package:paystack_flutter/src/core/network/api_endpoints.dart';
import 'package:paystack_flutter/src/core/utils/functions.dart';
import 'package:paystack_flutter/src/models/paystack_callback.dart';
import 'package:paystack_flutter/src/models/paystack_request.dart';
import 'package:paystack_flutter/src/models/paystack_response.dart';
import 'package:paystack_flutter/src/models/paystack_verification.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Created by Victor on 09/09/2024.
// Copyright (c) 2024 Elite Developers.All rights reserved.

class PaystackWebview extends StatefulWidget {
  const PaystackWebview({
    super.key,
    required this.secretKey,
    required this.amount,
    required this.email,
    this.reference,
    this.showProgressBar = true,
    this.confirmTransaction = false,
    this.paymentOptions,
    this.currency,
    required this.callbackUrl,
    this.metaData,
    required this.onSuccess,
    required this.onCancelled,
  });

  final String secretKey;
  final double amount;
  final String email;
  final String? reference;
  final bool? showProgressBar;
  final bool? confirmTransaction;
  final List<PaymentOption>? paymentOptions;
  final Currency? currency;
  final String callbackUrl;
  final dynamic metaData;
  final Function(PaystackCallback) onSuccess;
  final Function(PaystackCallback) onCancelled;

  @override
  State<PaystackWebview> createState() => _PaystackWebviewState();
}

class _PaystackWebviewState extends State<PaystackWebview> {
  late PayStackResponse payStackResponse;
  late PaystackCallback callback;

  @override
  void initState() {
    super.initState();
  }

  Future<PayStackResponse> getAuthorizationUrl() async {
    try {
      PaystackRequest request = PaystackRequest(
        amount: widget.amount,
        email: widget.email,
        callback: widget.callbackUrl,
        reference: widget.reference,
        metaData: widget.metaData,
        channels: convertPaymentOptionEnumToString(widget.paymentOptions),
        currency: widget.currency?.toCurrencyString()
      );
      final response = await ApiClient().post(
          paystackEndpoints.initializeTransaction,
          data: request.toJson(),
          extraHeaders: {'Authorization': 'Bearer ${widget.secretKey}'});
      // converts api response into the PaystackResponse class for easy use.
      payStackResponse = PayStackResponse.fromJson(response.data);
      callback = PaystackCallback(
          reference: payStackResponse.reference,
          accessCode: payStackResponse.accessCode);
      return payStackResponse;
    } on Exception catch (err) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error Occurred: ${err.toString()}')));
      }
      rethrow;
    }
  }

  Future verifyTransaction() async {
    try {
      final response = await ApiClient().get(
          paystackEndpoints.verifyTransaction(payStackResponse.reference),
          extraHeaders: {'Authorization': 'Bearer ${widget.secretKey}'});
      // converts api response into the PaystackResponse class for easy use.
      final verificationData = PaystackVerification
          .fromJson(response.data);
      if(verificationData.status){
        //it means we got the correct data that we are expecting.
        if(verificationData.gatewayResponse == "Successful" ||
        verificationData.gatewayResponse == "Approved"){
          //If Successful, it means that the transaction itself was successful.
          if(mounted){
            Navigator.pop(context);
            widget.onSuccess(callback);
          }
        }else {
          if(mounted){
            Navigator.pop(context);
          }
          //If not successful, we call the onCancelled.
          widget.onCancelled(callback);
        }
      }else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error Occurred: ${verificationData.message}')));
        }
      }
    } on Exception catch (err) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error Occurred: ${err.toString()}')));
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<PayStackResponse>(
          future: getAuthorizationUrl(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 20,),
                  TextButton(
                      onPressed: () async {
                        // Call getAuthorizationUrl again on button press
                        final response = await getAuthorizationUrl();
                        // Update snapshot data with the new response
                        setState(() {
                          payStackResponse = response;
                        });
                      },
                      child: const Text('Initialize payment again',
                      style: TextStyle(
                        color: Colors.blue,
                      ),),
                  ),
                ],
              ));
            }

            if (!snapshot.hasData) {
              if(widget.showProgressBar != null && widget.showProgressBar!){
                return const Center(
                    child: CircularProgressIndicator());
              }else {
                return const SizedBox.shrink();
              }
            }
            final controller = WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..setUserAgent("Flutter;Webview")
              ..setNavigationDelegate(
                NavigationDelegate(
                  onNavigationRequest: (request) async {
                      String? uri = request.url;
                      if (uri.toString().startsWith(widget.callbackUrl)) {
                        // Handle callback URL
                        ///If confirmTransaction is not empty and its true, we confirm
                        ///if the transaction was successful from Paystack
                        if(widget.confirmTransaction != null && widget.confirmTransaction!){
                          await verifyTransaction().then((value) {
                            //Navigator.pop(context);
                          });
                        }else {
                          Navigator.pop(context);
                          //this means the developer doesn't want to confirm from Paystack.
                          widget.onSuccess(callback);
                        }
                        // Close the webview after handling callback
                        return NavigationDecision.navigate;
                      }

                      //check if user is redirected to https://standard.paystack.co/close
                      if(uri.toString().startsWith('https://standard.paystack.co/close')){
                        await verifyTransaction();
                      }
                    return NavigationDecision.navigate;
                  },
                ),
              )
              ..loadRequest(Uri.parse(snapshot.data!.authorizationUrl));
            return WebViewWidget(
              controller: controller,
            );
          },
        ),
      ),
    );
  }
}
