import type {
    PaymentDetailsInit,
    PaymentItem,
    PaymentShippingOption
} from '../types';

import {
    isDecimal,
    isFloat,
    isInt,
    toFloat,
    toInt
} from 'validator';
import { DOMException, TypeError } from '../errors';

type AmountValue = string | number;

function isNumber(value) {
    return typeof value === 'number';
}

function isString(value) {
    return typeof value === 'string';
}

export function isValidDecimalMonetaryValue(amountValue: AmountValue | any): bool {
    if (!isNumber(amountValue) && !isString(amountValue)) {
        return false;
    }

    return isNumber || isValidStringAmount(amountValue);
}

export function isNegative(amountValue: AmountValue): bool {
    return isNumber(amountValue)
        ? amountValue < 0
        : amountValue.charAt(0) === '-';
}

export function isValidStringAmount(stringAmount): bool {
    return isDecimal(stringAmount);
}

export function toNumber(string: string): number {
    if (isFloat(string)) {
        return toFloat(string);
    }

    if (isInt(string)) {
        return toInt(string);
    }
}

export function toString(amountValue: AmountValue) {
    return isNumber(amountValue)
        ? amountValue.toString()
        : amountValue;
}

export function convertObjectAmountToString(objectWithAmount: (PaymentItem | PaymentShippingOption)): (PaymentItem | PaymentShippingOption) {
    return Object.assign({}, objectWithAmount, {
        amount: Object.assign({}, objectWithAmount, {
            value: toString(objectWithAmount.amount.value)
        })
    });
}

export function convertDetailAmountsToString(details: PaymentDetailsInit): PaymentDetailsInit {
    const nextDetails = Object.keys(details).reduce((acc, key) => {
        if (key === 'total') {
            return Object.assign({}, acc, {
                [key]: convertObjectAmountToString(details[key])
            });
        }

        if (key === 'displayItems' || key === 'shippingOptions') {
            return Object.assign({}, acc, {
                [key]: details[key].map(paymentItemOrShippingOption => convertObjectAmountToString(paymentItemOrShippingOption))
            });
        }

        return acc;
    }, {});

    return nextDetails;
}

export function getPlatformMethodData(methodData: Array<PaymentMethodData>, platformOS: 'ios' | 'android') {
    const platformSupportedMethod = platformOS === 'ios'
        ? 'apple-pay'
        : 'android-pay';

    const platformMethod = methodData.find(
        paymentMethodData => paymentMethodData.supportedMethods.includes(platformSupportedMethod)
    );

    if (!platformMethod) {
        throw new DOMException('The payment method is not supported');
    }

    return platformMethod.data;
}

export function validateTotal(total): void {
  const hasTotal = (total && total.amount && total.amount.value);
  // Check that there is a total
  if (!hasTotal) {
    throw new Error('A total value is required.');
  }

  const totalAmountValue = total.amount.value;

  // Check that total is a valid decimal monetary value.
  if (!isValidDecimalMonetaryValue(totalAmountValue)) {
      // throw new Error('Failed to construct 'PaymentRequest': '1.' is not a valid amount format for total
      throw new Error(`The total "${totalAmountValue}" is not a valid decimal monetary value.`);
  }

  // Check that total isn't negative
  if (isNegative(totalAmountValue)) {
    throw new Error(`The total can't be negative`);
  }
}

export function validatePaymentMethods(methodData): Array {
    // Check that at least one payment method is passed in
    if (methodData.length < 1) {
      throw new TypeError(`Failed to construct 'PaymentRequest': At least one payment method is required`);
    }

    let serializedMethodData = [];
    // Check that each payment method has at least one payment method identifier
    methodData.forEach((paymentMethod) => {
      if (!paymentMethod.supportedMethods) {
        throw new TypeError(`Failed to construct 'PaymentRequest': required member supportedMethods is undefined.`);
      }

      if (!Array.isArray(paymentMethod.supportedMethods)) {
        throw new TypeError(`Failed to construct 'PaymentRequest': required member supportedMethods is not iterable.`);
      }

      if (paymentMethod.supportedMethods.length < 1) {
        throw new TypeError(`Failed to construct 'PaymentRequest': Each payment method needs to include at least one payment method identifier`);
      }

      const serializedData = paymentMethod.data
        ? JSON.stringify(paymentMethod.data)
        : null;

      serializedMethodData.push([paymentMethod.supportedMethods, serializedData]);
    });

    return serializedMethodData;
}

export function validateDisplayItems(displayItems): void {
  // Check that the value of each display item is a valid decimal monetary value
  if (displayItems) {
    displayItems.forEach((item: PaymentItem) => {
      const amountValue = item && item.amount && item.amount.value;

      if (!amountValue) {
        throw new TypeError(`Failed to construct 'PaymentRequest': required member value is undefined.`);
      }

      if (!isValidDecimalMonetaryValue(amountValue)) {
        throw new TypeError(`Failed to construct 'PaymentRequest': '${amountValue}' is not a valid amount format for display items`)
      }
    });
  }
}