// @flow

import type { PaymentDetailsBase, PaymentComplete } from './types';

import { NativeModules } from 'react-native';
const { ReactNativePayments } = NativeModules;

const NativePayments: {
    canMakePayments: boolean,
    createPaymentRequest: (PaymentDetailsBase) => Promise<any>,
    handleDetailsUpdate: (PaymentDetailsBase) => Promise<any>,
    show: () => Promise<any>,
    abort: () => Promise<any>,
    complete: (PaymentComplete) => Promise<any>
} = {
    canMakePayments: ReactNativePayments.canMakePayments,

    createPaymentRequest(methodData, details, options = {}) {
        return new Promise((resolve, reject) => {
            ReactNativePayments.createPaymentRequest(methodData, details, options, (err) => {
                if (err) return reject(err);

                resolve();
            });
        });
    },

    handleDetailsUpdate(details) {
        return new Promise((resolve, reject) => {
            ReactNativePayments.handleDetailsUpdate(details, (err) => {
                if (err) return reject(err);

                resolve();
            });
        });
    },

    show() {
        // TODO:
        // - Update ReactNativePayments state (native side) to set `showing: true`
        return new Promise((resolve, reject) => {
            ReactNativePayments.show((err, paymentToken) => {
                if (err) return reject(err);

                resolve(true);
            });
        });
    },

    abort() {
        return new Promise((resolve, reject) => {
            ReactNativePayments.abort((err) => {
                if (err) return reject(err);

                resolve(true);
            });
        });
    },

    complete(paymentStatus) {
        return new Promise((resolve, reject) => {
            ReactNativePayments.complete(paymentStatus, (err) => {
                if (err) return reject(err);

                resolve(true);
            });
        });
    }
};

export default NativePayments;
