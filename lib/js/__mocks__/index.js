const mockReactNativeIOS = {
    Platform: {
        OS: 'ios'
    },
    DeviceEventEmitter: {
        removeSubscription: () => {},
        addListener: () => {}
    }
};

const mockReactNativeAndroid = Object.assign({}, mockReactNativeIOS, {
    Platform: {
        OS: 'android'
    }
});

const mockNativePaymentsSupportedIOS = {
    canMakePayments: true,
    createPaymentRequest: () => {},
    handleDetailsUpdate: () => {},
    show: () => {},
    abort: () => {},
    complete: (paymentStatus, cb) => {
        cb();
    }
};

const mockNativePaymentsUnsupportedIOS = Object.assign({}, mockNativePaymentsSupportedIOS,{
    canMakePayments: false
});

module.exports = {
    mockReactNativeIOS,
    mockReactNativeAndroid,
    mockNativePaymentsSupportedIOS,
    mockNativePaymentsUnsupportedIOS
};