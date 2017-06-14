import React, { Component } from 'react';
import { AppRegistry } from 'react-native';
import App from './js/App';

AppRegistry.registerComponent('example', () => App);

// import React, { Component } from 'react';
// import {
//   AppRegistry,
//   StyleSheet,
//   Text,
//   View,
//   TouchableHighlight
// } from 'react-native';
// import { PaymentRequest } from 'react-native-payments';

// const INIT_TOTAL = {
//   label: 'Total',
//   amount: { currency: 'USD', value: '55.00' }
// };
// let INIT_SHIPPING_OPTIONS = [
//   {
//     id: 'economy',
//     label: 'Economy Shipping (5-7 Days)',
//     amount: {
//       currency: 'USD',
//       value: '0.00',
//     },
//     selected: true
//   }, {
//     id: 'express',
//     label: 'Express Shipping (2-3 Days)',
//     amount: {
//       currency: 'USD',
//       value: '5.00',
//     },
//   }, {
//     id: 'next-day',
//     label: 'Next Day Delivery',
//     amount: {
//       currency: 'USD',
//       value: '12.00',
//     },
//   }
// ];
// const INIT_DISPLAY_ITEMS = [{
//   label: 'Sub-total',
//   amount: { currency: 'USD', value: '55.00' }
// }, {
//   label: 'Shipping',
//   amount: INIT_SHIPPING_OPTIONS[0].amount
// }];

// export default class BasicView extends Component {
//   constructor() {
//     super();

//     this.handlePaymentPress = this.handlePaymentPress.bind(this);
//   }

//   handlePaymentPress(e) {
//     const methodData = [{
//       supportedMethods: ['apple-pay'],
//       data: {
//         merchantIdentifier: 'merchant.com.react-native-payments.naoufal',
//         supportedNetworks: ['visa', 'mastercard'],
//         countryCode: 'US',
//         currencyCode: 'USD'
//       }
//     }];

//     const details = {
//       id: 'native-payments-example',
//       displayItems: INIT_DISPLAY_ITEMS,
//       total: INIT_TOTAL,
//       shippingOptions: INIT_SHIPPING_OPTIONS
//     };

//     const options = {
//       requestShipping: true,
//       requestPayerPhone: true,
//       requestPayerEmail: true,
//       requestPayerName: true,
//       shippingType: 'shipping'
//     };

//     this.paymentRequest = new PaymentRequest(methodData, details, options);

//     this.paymentRequest.addEventListener('shippingaddresschange', e => {
//       console.log(e.target.shippingOption);
//       //TODO: Update to use new API
//       const selectedShippingAddress = e.target.shippingAddress;
//       const updatedDisplayItems = (selectedShippingAddress.postalCode === '94114')
//           ? [{
//             label: 'Sub-total',
//             amount: { currency: 'USD', value: '55.00' }
//           }]
//           : INIT_DISPLAY_ITEMS;
//       const updatedTotal = (selectedShippingAddress.postalCode === '94114')
//           ? {
//               amount: {
//                 currency: 'USD',
//                 value: '55.00'
//               },
//               label: 'total'
//             }
//           : INIT_TOTAL;
//       const updatedShippingOptions = (selectedShippingAddress.postalCode === '94114')
//         ? [{
//             id: 'express1',
//             label: 'foo Shipping (2-3 Days)',
//             amount: {
//               currency: 'USD',
//               value: '11.00',
//             },
//           }]
//         : INIT_SHIPPING_OPTIONS;
//       const error = (selectedShippingAddress.postalCode === '94114') && `Sorry homie, can't ship there.` // This is actually ignored by Apple Pay

//       e.updateWith({
//         total: updatedTotal,
//         displayItems: updatedDisplayItems,
//         shippingOptions: updatedShippingOptions,
//         error
//       });
//     });

//     this.paymentRequest.addEventListener('shippingoptionchange', e => {
//       const selectedShippingOptionId = e.target.shippingOption;
//       const updatedShippingOptions = [...INIT_SHIPPING_OPTIONS].map(shippingOption => {
//         return Object.assign({}, shippingOption, {
//           selected: shippingOption.id === selectedShippingOptionId
//         });
//       });
//       const selectedShippingOption = updatedShippingOptions.find(shippingOption => shippingOption.selected);
//       const updatedDisplayItems = [...INIT_DISPLAY_ITEMS].map(displayOption => {
//         return (displayOption.label !== 'Shipping')
//           ? displayOption
//           : Object.assign({}, displayOption, {
//             amount: selectedShippingOption.amount
//           })
//       });
//       const updatedTotal = Object.assign({}, INIT_TOTAL, {
//           amount: {
//             currency: 'USD',
//             value: (parseFloat(INIT_TOTAL.amount.value) + parseFloat(selectedShippingOption.amount.value)).toString()
//           }
//       });

//       // TODO: update total
//       e.updateWith({
//         total: updatedTotal,
//         displayItems: updatedDisplayItems,
//         shippingOptions: updatedShippingOptions
//       });
//     });

//     return this.paymentRequest.show()
//       .then(paymentResponse => {

//         // TODO:
//         // - Charge the token or send it back to the Native Side
//         return paymentResponse.complete('success');
//       })
//       .catch(e => this.paymentRequest.abort());
//   }

//   render() {
//     return (
//       <View style={styles.container}>
//         <TouchableHighlight
//           style={styles.button}
//           onPress={this.handlePaymentPress}
//         >
//           <Text style={styles.buttonText}>
//             Pay with Payments
//           </Text>
//         </TouchableHighlight>
//       </View>
//     );
//   }
// }

// const styles = StyleSheet.create({
//   container: {
//     flex: 1,
//     justifyContent: 'center',
//     alignItems: 'center',
//     backgroundColor: '#F5FCFF',
//   },
//   welcome: {
//     fontSize: 20,
//     textAlign: 'center',
//     marginBottom: 10,
//   },
//   instructions: {
//     textAlign: 'center',
//     marginBottom: 200,
//   },
//   button: {
//     borderRadius: 3,
//     backgroundColor: '#000',
//     overflow: 'hidden'
//   },
//   buttonText: {
//     paddingVertical: 10,
//     paddingHorizontal: 20,
//     color: '#fff',
//     fontSize: 18,
//     textAlign: 'center'
//   }
// });