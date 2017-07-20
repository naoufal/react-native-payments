import { Platform } from 'react-native';

export const MODULE_SCOPING = 'NativePayments';
export const SHIPPING_ADDRESS_CHANGE_EVENT = 'shippingaddresschange';
export const SHIPPING_OPTION_CHANGE_EVENT = 'shippingoptionchange';
export const INTERNAL_SHIPPING_ADDRESS_CHANGE_EVENT = `${MODULE_SCOPING}:on${SHIPPING_ADDRESS_CHANGE_EVENT}`;
export const INTERNAL_SHIPPING_OPTION_CHANGE_EVENT = `${MODULE_SCOPING}:on${SHIPPING_OPTION_CHANGE_EVENT}`;
export const USER_DISMISS_EVENT = `${MODULE_SCOPING}:onuserdismiss`;
export const USER_ACCEPT_EVENT = `${MODULE_SCOPING}:onuseraccept`;
export const GATEWAY_ERROR_EVENT = `${MODULE_SCOPING}:ongatewayerror`;
export const SUPPORTED_METHOD_NAME =
  Platform.OS === 'ios' ? 'apple-pay' : 'android-pay';
