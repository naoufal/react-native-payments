# NativePayments
### createPaymentRequest(methodData, details, options)
Sends methodData, details and options over the bridge to initialize Apple Pay/Android Pay.

__Arguments__
- methodData - `PaymentMethodData`
- details - `PaymentDetailsInit`
- ?options - `PaymentOptions`

<details>
<summary><strong>Example</strong></summary>

```es6
const METHOD_DATA = [
  {
    supportedMethods: ['apple-pay'],
    data: {
      merchantIdentifier: 'merchant.com.your-app.namespace',
      supportedNetworks: ['visa', 'mastercard', 'amex'],
      countryCode: 'US',
      currencyCode: 'USD'
    }
  }
];

const DETAILS = {
  id: 'demo',
  displayItems: [
    {
      label: 'Movie Ticket',
      amount: { currency: 'USD', value: '15.00' }
    },
    {
      label: 'Shipping',
      amount: { currency: 'USD', value: '0.00' }
    }
  ],
  total: {
    label: 'Merchant Name',
    amount: { currency: 'USD', value: '15.00' }
  },
  shippingOptions: [
    {
      id: 'economy',
      label: 'Economy Shipping',
      amount: { currency: 'USD', value: '0.00' },
      detail: 'Arrives in 3-5 days',
      selected: true
    },
    {
      id: 'express',
      label: 'Express Shipping',
      amount: { currency: 'USD', value: '5.00' },
      detail: 'Arrives tomorrow'
    }
  ]
};

const OPTIONS = {
  requestPayerName: true,
  requestPayerPhone: true,
  requestPayerEmail: true,
  requestShipping: true
};

NativePayments.createPaymentRequest(METHOD_DATA, DETAILS, OPTIONS);
```

</details>

---

### handleDetailsUpdate(details)
Sends details over the bridge to update Apple Pay/Android Pay.

__Arguments__
- details - `PaymentDetailsUpdate`

<details>
<summary><strong>Example</strong></summary>

```es6
NativePayments.handleDetailsUpdate({
  displayItems: [
    {
      label: 'Movie Ticket',
      amount: { currency: 'USD', value: '15.00' }
    },
    {
      label: 'Shipping',
      amount: { currency: 'USD', value: '5.00' }
    }
  ],
  total: {
    label: 'Merchant Name',
    amount: { currency: 'USD', value: '20.00' }
  },
  shippingOptions: [
    {
      id: 'economy',
      label: 'Economy Shipping',
      amount: { currency: 'USD', value: '0.00' },
      detail: 'Arrives in 3-5 days'
    },
    {
      id: 'express',
      label: 'Express Shipping',
      amount: { currency: 'USD', value: '5.00' },
      detail: 'Arrives tomorrow',
      selected
    }
  ]
});
```

</details>

---

### canMakePayments()
Returns if Apple Pay/Android Pay is available given the device and the supportNetworks provided.

__Arguments__

<details>
<summary><strong>Example</strong></summary>

```es6
NativePayments.canMakePayments();
```

</details>

---

### canMakePaymentsUsingNetworks()
**(IOS only)** Returns if user has available cards at Apple Pay that matches passed networks.

__Arguments__
- usingNetworks - `Array`


<details>
<summary>
<strong>Example</strong>
</summary>

```es6
NativePayments
    .canMakePaymentsUsingNetworks(['Visa', 'AmEx', 'MasterCard'])
    .then(canMakePayments => {
        if (canMakePayments) {
            // do some stuff
        }
    });
```

</details>

---

### show()
Displays Apple Pay/Android Pay to the user.

<details>
<summary><strong>Example</strong></summary>

```es6
NativePayments.show();
```

</details>

---

### abort()
Dismisses the Apple Pay/Android Pay sheet.

<details>
<summary><strong>Example</strong></summary>

```es6
NativePayments.abort();
```

</details>

---

### complete(paymentStatus)
Displays a success/failure animation and dismisses Apple Pay/Android Pay based on the payment status provided.

__Arguments__
- paymentStatus - `PaymentComplete`

<details>
<summary><strong>Example</strong></summary>

```es6
NativePayments.complete('success');
```

</details>

---
