# PaymentResponse
### constructor(paymentResponse)
Initializes the payment response.

__Arguments__
- paymentResponse - `Array<PaymentMethodData>`

<details>
<summary><strong>Example</strong></summary>

```es6
const PAYMENT_RESPONSE = {
    requestId: 'demo',
    methodName: 'apple-pay',
    details: {
        transactionIdentifier: 'some-id',
        paymentData: {}
    }
};

const paymentResponse = new PaymentResponse(PAYMENT_RESPONSE);
```

</details>

---

### complete()
Displays a success/failure animation and dismisses the payment request based on the payment status provided.

__Arguments__
- paymentStatus - `PaymentComplete`

<details>
<summary><strong>Example</strong></summary>

```es6
paymentResponse.complete('success');
```

</details>

---

### methodName

<details>
<summary><strong>Example</strong></summary>

```es6
console.log(paymentResponse.methodName); // apple-pay
```

</details>

---

### details

<details>
<summary><strong>Example</strong></summary>

```es6
console.log(paymentResponse.details); // {}
```

</details>

---

### shippingAddress

<details>
<summary><strong>Example</strong></summary>

```es6
console.log(paymentResponse.shippingAddress); // null
```

</details>

---

### shippingOption

<details>
<summary><strong>Example</strong></summary>

```es6
console.log(paymentResponse.shippingOption); // null
```

</details>

---

### payerName

<details>
<summary><strong>Example</strong></summary>

```es6
console.log(paymentResponse.payerName); // null
```

</details>

---

### payerEmail

<details>
<summary><strong>Example</strong></summary>

```es6
console.log(paymentResponse.payerEmail); // null
```

</details>

---

### payerPhone

<details>
<summary><strong>Example</strong></summary>

```es6
console.log(paymentResponse.payerPhone); // null
```

</details>

---

### demo

<details>
<summary><strong>Example</strong></summary>

```es6
console.log(paymentResponse.requestId); // demo
```

</details>

---