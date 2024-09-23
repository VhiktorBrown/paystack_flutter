## 1.0.0

* First release.
* Paystack's payment gateway providing you with various payment options to collect payment in your flutter app.

## 1.0.1

* Fixed GIF and screenshots not showing in README.md

## 1.0.2

* Fixed `showProgressBar` argument not being used in implementation. Now, whatever value you set is used.
* Clicking on `Cancel Payment` on Paystack payment page now cancels the payment and closes the page, calling the onCancelled callback.