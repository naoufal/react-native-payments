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
  canMakePayments: () => true,
  createPaymentRequest: () => {},
  handleDetailsUpdate: async () => {},
  show: cb => cb(), // TODO, may have to fire an event that DeviceEventEmitter will listen to
  abort: cb => cb(),
  complete: (paymentStatus, cb) => cb()
};

const mockNativePaymentsUnsupportedIOS = Object.assign(
  {},
  mockNativePaymentsSupportedIOS,
  {
    canMakePayments: () => false,
  }
);

module.exports = {
  mockReactNativeIOS,
  mockReactNativeAndroid,
  mockNativePaymentsSupportedIOS,
  mockNativePaymentsUnsupportedIOS
};
