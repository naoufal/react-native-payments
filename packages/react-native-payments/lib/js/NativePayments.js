// @flow

import type { PaymentDetailsBase, PaymentComplete } from './types';

import { NativeModules, Platform } from 'react-native';
const { ReactNativePayments } = NativeModules;

const IS_ANDROID = Platform.OS === 'android';

const NativePayments: {
  canMakePayments: boolean,
  supportedGateways: Array<string>,
  createPaymentRequest: PaymentDetailsBase => Promise<any>,
  handleDetailsUpdate: PaymentDetailsBase => Promise<any>,
  show: () => Promise<any>,
  abort: () => Promise<any>,
  complete: PaymentComplete => Promise<any>,
  getFullWalletAndroid: string => Promise<any>
} = {
  supportedGateways: IS_ANDROID
    ? ['stripe', 'braintree'] // On Android, Payment Gateways are supported out of the gate.
    : ReactNativePayments ? ReactNativePayments.supportedGateways : [],

  canMakePayments(methodData: object) {
    return new Promise((resolve, reject) => {
      if (IS_ANDROID) {
        ReactNativePayments.canMakePayments(
          methodData,
          (err) => reject(err),
          (canMakePayments) => resolve(true)
        );

        return;
      }

      // On iOS, canMakePayments is exposed as a constant.
      resolve(ReactNativePayments.canMakePayments);
    });
  },

  createPaymentRequest(methodData, details, options = {}) {
    return new Promise((resolve, reject) => {
      // Android Pay doesn't a PaymentRequest interface on the
      // Java side.  So we create and show Android Pay when
      // the user calls `.show`.
      if (IS_ANDROID) {
        return resolve();
      }

      ReactNativePayments.createPaymentRequest(
        methodData,
        details,
        options,
        err => {
          if (err) return reject(err);

          resolve();
        }
      );
    });
  },

  handleDetailsUpdate(details) {
    return new Promise((resolve, reject) => {
      // Android doesn't have display items, so we noop.
      // Users need to create a new Payment Request if they
      // need to update pricing.
      if (IS_ANDROID) {
        resolve(undefined);

        return;
      }

      ReactNativePayments.handleDetailsUpdate(details, err => {
        if (err) return reject(err);

        resolve();
      });
    });
  },

  show(methodData, details, options = {}) {
    return new Promise((resolve, reject) => {
      if (IS_ANDROID) {
        ReactNativePayments.show(
          methodData,
          details,
          options,
          (err) => reject(err),
          (...args) => { console.log(args); resolve(true) }
        );

        return;
      }

      ReactNativePayments.show((err, paymentToken) => {
        if (err) return reject(err);

        resolve(true);
      });
    });
  },

  abort() {
    return new Promise((resolve, reject) => {
      if (IS_ANDROID) {
        // TODO
        resolve(undefined);

        return;
      }

      ReactNativePayments.abort(err => {
        if (err) return reject(err);

        resolve(true);
      });
    });
  },

  complete(paymentStatus) {
    return new Promise((resolve, reject) => {
      // Android doesn't have a loading state, so we noop.
      if (IS_ANDROID) {
        resolve(undefined);

        return;
      }

      ReactNativePayments.complete(paymentStatus, err => {
        if (err) return reject(err);

        resolve(true);
      });
    });
  },

  getFullWalletAndroid(googleTransactionId: string, paymentMethodData: object, details: object): Promise<string> {
    return new Promise((resolve, reject) => {
      if (!IS_ANDROID) {
        reject(new Error('This method is only available on Android.'));

        return;
      }

      ReactNativePayments.getFullWalletAndroid(
        googleTransactionId,
        paymentMethodData,
        details,
        (err) => reject(err),
        (serializedPaymentToken) => resolve({
          serializedPaymentToken,
          paymentToken: JSON.parse(serializedPaymentToken),
          /** Leave previous typo in order not to create a breaking change **/
          serializedPaymenToken: serializedPaymentToken,
          paymenToken: JSON.parse(serializedPaymentToken)
        })
      );
    });
  }
};

export default NativePayments;
