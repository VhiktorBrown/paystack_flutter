## 1.0.0

* First release.
* Paystack's payment gateway providing you with various payment options to collect payment in your flutter app.

## 1.0.1

* Fixed GIF and screenshots not showing in README.md

## 1.0.2

* Fixed `showProgressBar` argument not being used in implementation. Now, whatever value you set is used.
* Clicking on `Cancel Payment` on Paystack payment page now cancels the payment and closes the page, calling the onCancelled callback.

## 1.0.3

* You can now pass in customer's First name and Last name and have it saved on Paystack's end and you can see them from the dashboard.
* Support for EURO currency added. Just pass Currency.EUR.
* The README has been updated with instructions on how to test out the Bank transfer feature in the Test environment.