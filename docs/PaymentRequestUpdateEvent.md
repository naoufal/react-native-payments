# PaymentRequestUpdateEvent
### constructor(name, paymentRequest)
Initializes the payment request update event.

__Arguments__
- name - `onshippingaddresschange | onshippingoptionchange`
- paymentRequest - `PaymentRequest`

<details>
<summary><strong>Example</strong></summary>

```es6
const event = new PaymentRequestUpdateEvent('onshippingaddresschange', paymentRequest);
```

</details>

---

### updateWith(details)
Updates the payment request with the details provided.

__Arguments__
- details - `PaymentDetailsUpdate`

<details>
<summary><strong>Example</strong></summary>

```es6
event.updateWith({
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
