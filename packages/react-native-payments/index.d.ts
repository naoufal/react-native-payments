declare module 'react-native-payments' {
  export interface PaymentTokenAndroid {
    serializedPaymentToken: string;
    paymentToken: any;
  }

  interface PaymentResponseAndroid {
    googleTransactionId: string;
    paymentDescription: string;
    getPaymentToken: () => Promise<PaymentTokenAndroid>;
  }

  interface PaymentResponseIOS {
    transactionIdentifier: string;
    paymentData: any;
    serializedPaymentData: string;
  }

  export interface PaymentMethodData {
    supportedMethods: string[];
    data: any;
  }

  export interface PaymentCurrencyAmount {
    currency: string;
    value: number | string;
  }

  export interface PaymentDetailsBase {
    displayItems?: PaymentItem[];
    shippingOptions?: PaymentShippingOption[];
    modifiers?: PaymentDetailsModifier[];
  }

  export interface PaymentDetailsInit extends PaymentDetailsBase {
    id?: string;
    total: PaymentItem;
  }

  export interface PaymentDetailsUpdate extends PaymentDetailsBase {
    error: string;
    total: PaymentItem;
  }

  export interface PaymentDetailsModifier {
    supportedMethods: string[];
    total: PaymentItem;
    additionalDisplayItems: PaymentItem[];
    data: any;
  }

  export type PaymentShippingType = 'shipping' | 'delivery' | 'pickup';

  export interface PaymentOptions {
    requestPayerName: boolean;
    requestPayerEmail: boolean;
    requestPayerPhone: boolean;
    requestShipping: boolean;
    shippingType: PaymentShippingType;
  }

  export interface PaymentItem {
    label: string;
    amount: PaymentCurrencyAmount;
    pending?: boolean;
  }

  export interface PaymentAddress {
    recipient: null | string;
    organization: null | string;
    addressLine: null | string;
    city: string;
    region: string;
    country: string;
    postalCode: string;
    phone: null | string;
    languageCode: null | string;
    sortingCode: null | string;
    dependentLocality: null | string;
  }

  export interface PaymentShippingOption {
    id: string;
    label: string;
    amount: PaymentCurrencyAmount;
    selected: boolean;
  }

  export type PaymentComplete = 'fail' | 'success' | 'unknown';

  class PaymentResponse {
    requestId: string;
    methodName: string;
    details: PaymentDetailsInit;
    shippingAddress: null | PaymentAddress;
    shippingOption: null | string;
    payerName: null | string;
    payerPhone: null | string;
    payerEmail: null | string;
    complete(paymentStatus: PaymentComplete): Promise<void>;
  }

  type PaymentRequestUpdateEventType =
    | 'shippingaddresschange'
    | 'shippingoptionchange';

  class PaymentRequestUpdateEvent {
    constructor(name: PaymentRequestUpdateEventType, target: PaymentRequest);
    name: PaymentRequestUpdateEventType;
    target: PaymentRequest;
    updateWith(
      PaymentDetailsModifierOrPromise:
        | PaymentDetailsUpdate
        | ((
            PaymentDetailsModifier,
            PaymentAddress
          ) => Promise<PaymentDetailsUpdate>)
    );
  }

  export class PaymentRequest {
    constructor(
      methodData: PaymentMethodData[],
      details?: PaymentDetailsInit,
      options?: PaymentOptions
    );

    addEventListener(
      eventName: PaymentRequestUpdateEventType,
      fn: (e: PaymentRequestUpdateEvent) => Promise<any>
    ): (e: PaymentRequestUpdateEvent) => Promise<any>;

    get id(): string;
    get shippingAddress(): null | PaymentAddress;
    get shippingOption(): null | string;

    show(): Promise<PaymentResponseAndroid | PaymentResponseIOS>;

    /** Cancels the payment */
    abort(): Promise<void>;

    /** Checks whether the payment can be made with current configuration */
    canMakePayments(): Promise<boolean>;
  }
}

declare module 'react-native-payments/lib/js/NativePayments' {
  import {
    PaymentMethodData,
    PaymentDetailsInit,
    PaymentOptions,
    PaymentComplete,
    PaymentTokenAndroid
  } from 'react-native-payments';
  interface NativePayments {
    canMakePayments(methodData?: any): Promise<boolean>;

    createPaymentRequest(
      methodData: PaymentMethodData[],
      details?: PaymentDetailsInit,
      options?: PaymentOptions
    ): Promise<void>;

    handleDetailsUpdate(details: PaymentDetailsInit): Promise<void>;

    show(
      methodData: PaymentMethodData[],
      details?: PaymentDetailsInit,
      options?: PaymentOptions
    ): Promise<true>;

    abort(): Promise<true | void>;
    complete(paymentStatus: PaymentComplete): Promise<true | void>;
    getFullWalletAndroid(
      googleTransactionId: string,
      paymentMethodData?: PaymentMethodData,
      details?: PaymentDetailsInit
    ): Promise<PaymentTokenAndroid>;
  }
  const NativePayments: NativePayments;
  export default NativePayments;
}
