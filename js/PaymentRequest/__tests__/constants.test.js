const { mockReactNativeIOS } = require('../__mocks__');

jest.mock('react-native', () => mockReactNativeIOS);
const {
  MODULE_SCOPING,
  SHIPPING_ADDRESS_CHANGE_EVENT,
  SHIPPING_OPTION_CHANGE_EVENT,
  INTERNAL_SHIPPING_ADDRESS_CHANGE_EVENT,
  INTERNAL_SHIPPING_OPTION_CHANGE_EVENT,
  USER_DISMISS_EVENT,
  USER_ACCEPT_EVENT,
  SUPPORTED_METHOD_NAME
} = require('../constants');

describe('constants', () => {
  describe('MODULE_SCOPING', () => {
    it('should be equal to `NativePayments`', () => {
      expect(MODULE_SCOPING).toBe('NativePayments');
    });
  });

  describe('SHIPPING_ADDRESS_CHANGE_EVENT', () => {
    it('should be equal to `shippingaddresschange`', () => {
      expect(SHIPPING_ADDRESS_CHANGE_EVENT).toBe('shippingaddresschange');
    });
  });

  describe('SHIPPING_OPTION_CHANGE_EVENT', () => {
    it('should be equal to `shippingoptionchange`', () => {
      expect(SHIPPING_OPTION_CHANGE_EVENT).toBe('shippingoptionchange');
    });
  });

  describe('INTERNAL_SHIPPING_ADDRESS_CHANGE_EVENT', () => {
    it('should be equal to `NativePayments:onshippingaddresschange`', () => {
      expect(INTERNAL_SHIPPING_ADDRESS_CHANGE_EVENT).toBe(
        'NativePayments:onshippingaddresschange'
      );
    });
  });

  describe('INTERNAL_SHIPPING_OPTION_CHANGE_EVENT', () => {
    it('should be equal to `NativePayments:onshippingoptionchange`', () => {
      expect(INTERNAL_SHIPPING_OPTION_CHANGE_EVENT).toBe(
        'NativePayments:onshippingoptionchange'
      );
    });
  });

  describe('USER_DISMISS_EVENT', () => {
    it('should be equal to `NativePayments:onuserdismiss`', () => {
      expect(USER_DISMISS_EVENT).toBe('NativePayments:onuserdismiss');
    });
  });

  describe('USER_ACCEPT_EVENT', () => {
    it('should be equal to `NativePayments:onuseraccept`', () => {
      expect(USER_ACCEPT_EVENT).toBe('NativePayments:onuseraccept');
    });
  });

  describe('SUPPORTED_METHOD_NAME', () => {
    it('should be equal to `apple-pay` when platform is `ios`', () => {
      expect(SUPPORTED_METHOD_NAME).toBe('apple-pay');
    });
  });
});
