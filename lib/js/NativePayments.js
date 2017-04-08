import { NativeModules } from 'react-native';
const { NativePayments } = NativeModules;

// Web Payments to Apple Pay abstraction happens here
const Payments = {
    canMakePayments: NativePayments.canMakePayments: boolean,

    // paymentRequest(): Promise<any> {

    // },

    // success(): Promise<any> {

    // },

    // failure(): Promise<any> {

    // }
};

export default Payments;
