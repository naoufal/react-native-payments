// @flow

import type { CanMakePayments, PaymentDetailsBase, PaymentComplete } from './types';

import { NativeModules, Platform } from 'react-native';
const { ReactNativePayments } = NativeModules;

const IS_ANDROID = Platform.OS === 'android';

const NativePayments: {
  canMakePayments: CanMakePayments => Promise<boolean>,
  supportedGateways: Array<string>,
  createPaymentRequest: PaymentDetailsBase => Promise<any>,
  handleDetailsUpdate: PaymentDetailsBase => Promise<any>,
  show: () => Promise<any>,
  abort: () => Promise<any>,
  complete: PaymentComplete => Promise<any>
} = {
  supportedGateways: IS_ANDROID
    ? [] // On Android, Payment Gateways are supported out of the gate.
    : ReactNativePayments ? ReactNativePayments.supportedGateways : [],

  canMakePayments(methodData?: CanMakePayments) {
    return new Promise((resolve, reject) => {
      if (IS_ANDROID) {
        ReactNativePayments.canMakePayments(
          methodData,
          (err) => reject(err),
          () => resolve(true)
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
  }
};

export default NativePayments;
