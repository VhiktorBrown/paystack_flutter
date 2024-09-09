import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:paystack_flutter/src/core/network/api_client.dart';
import 'package:paystack_flutter/src/core/network/api_endpoints.dart';
import 'package:paystack_flutter/src/models/paystack_callback.dart';
import 'package:paystack_flutter/src/models/paystack_request.dart';
import 'package:paystack_flutter/src/models/paystack_response.dart';
import 'package:paystack_flutter/src/models/paystack_verification.dart';

class PaystackWebview extends StatefulWidget {
  const PaystackWebview({
    super.key,
    required this.secretKey,
    required this.amount,
    required this.email,
    this.reference,
    this.confirmTransaction = false,
    required this.callbackUrl,
    this.metaData,
    required this.onSuccess,
    required this.onCancelled,
  });

  final String secretKey;
  final double amount;
  final String email;
  final String? reference;
  final bool? confirmTransaction;
  final String callbackUrl;
  final dynamic metaData;
  final Function(PaystackCallback) onSuccess;
  final Function(PaystackCallback) onCancelled;

  @override
  State<PaystackWebview> createState() => _PaystackWebviewState();
}

class _PaystackWebviewState extends State<PaystackWebview> {
  late InAppWebViewController _webViewController;
  late PayStackResponse payStackResponse;
  late PaystackCallback callback;

  @override
  void initState() {
    //call the function that fetches authorization URL from Paystack.
    getAuthorizationUrl();
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
        if(verificationData.gatewayResponse == "Successful"){
          //If Successful, it means that the transaction itself was successful.
          if(mounted){
            widget.onSuccess(callback);
          }
        }else {
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
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData) {
              return const Center(
                  child: CircularProgressIndicator());
            }
            final authorizationUrl = snapshot.data!.authorizationUrl;

            return InAppWebView(
              initialUrlRequest:
                  URLRequest(url: WebUri.uri(Uri.parse(authorizationUrl))),
              onWebViewCreated: (InAppWebViewController controller) {
                _webViewController = controller;
              },
              initialSettings: InAppWebViewSettings(
                useShouldInterceptRequest: true,
                javaScriptEnabled: true,
                javaScriptCanOpenWindowsAutomatically: true,
                cacheEnabled: true,
              ),
              onLoadStart: ((controller, url) {}),
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                Uri? uri = navigationAction.request.url;
                if (uri != null && uri.toString() == widget.callbackUrl) {
                  // Handle callback URL
                  ///If confirmTransaction is not empty and its true, we confirm
                  ///if the transaction was successful from Paystack
                  if(widget.confirmTransaction != null && widget.confirmTransaction!){
                    await verifyTransaction().then((value) {
                      Navigator.pop(context);
                    });
                  }else {
                    //this means the developer doesn't want to confirm from Paystack.
                    widget.onSuccess(callback);
                  }
                  // Close the webview after handling callback
                  _webViewController.goBack();
                  return NavigationActionPolicy.CANCEL;
                }
                return NavigationActionPolicy.ALLOW;
              },
            );
          },
        ),
      ),
    );
  }
}
