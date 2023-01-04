// @flow

// https://www.w3.org/TR/payment-request/#paymentmethoddata-dictionary
export type PaymentMethodData = {
  supportedMethods: Array<string>,
  data: Object
};

// https://www.w3.org/TR/payment-request/#dom-paymentcurrencyamount
export type PaymentCurrencyAmount = {
  currency: string,
  value: string
};

// https://www.w3.org/TR/payment-request/#paymentdetailsbase-dictionary
export type PaymentDetailsBase = {
  displayItems: Array<PaymentItem>,
  shippingOptions: Array<PaymentShippingOption>,
  modifiers: Array<PaymentDetailsModifier>
};

// https://www.w3.org/TR/payment-request/#paymentdetailsinit-dictionary
export type PaymentDetailsInit = {
  ...PaymentDetailsBase,
  id?: string,
  total: PaymentItem
};

// https://www.w3.org/TR/payment-request/#paymentdetailsupdate-dictionary
export type PaymentDetailsUpdate = {
  ...PaymentDetailsBase,
  error: string,
  total: PaymentItem
};

// https://www.w3.org/TR/payment-request/#paymentdetailsmodifier-dictionary
export type PaymentDetailsModifier = {
  supportedMethods: Array<string>,
  total: PaymentItem,
  additionalDisplayItems: Array<PaymentItem>,
  data: Object
};

// https://www.w3.org/TR/payment-request/#paymentshippingtype-enum
export type PaymentShippingType = 'shipping' | 'delivery' | 'pickup';

// https://www.w3.org/TR/payment-request/#paymentoptions-dictionary
export type PaymentOptions = {
  requestPayerName: boolean,
  requestPayerEmail: boolean,
  requestPayerPhone: boolean,
  requestShipping: boolean,
  requestBilling: boolean,
  shippingType: PaymentShippingType
};

// https://www.w3.org/TR/payment-request/#paymentitem-dictionary
export type PaymentItem = {
  label: string,
  amount: PaymentCurrencyAmount,
  pending: boolean
};

// https://www.w3.org/TR/payment-request/#paymentaddress-interface
export type PaymentAddress = {
  recipient: null | string,
  organization: null | string,
  addressLine: null | string,
  city: string,
  region: string,
  country: string,
  postalCode: string,
  phone: null | string,
  languageCode: null | string,
  sortingCode: null | string,
  dependentLocality: null | string
};

// https://www.w3.org/TR/payment-request/#paymentshippingoption-dictionary
export type PaymentShippingOption = {
  id: string,
  label: string,
  amount: PaymentCurrencyAmount,
  selected: boolean
};

// https://www.w3.org/TR/payment-request/#paymentcomplete-enum
export type PaymentComplete = 'fail' | 'success' | 'unknown';

export type PaymentDetailsIOS = {
  paymentData: ?Object,
  billingContact?: ?Object,
  shippingContact?: ?Object,
  paymentToken?: string,
  transactionIdentifier: string,
  paymentMethod: Object
};

export type PaymentDetailsIOSRaw = {
  paymentData: string,
  billingContact?: string,
  shippingContact?: string,
  paymentToken?: string,
  transactionIdentifier: string,
  paymentMethod: Object
};
