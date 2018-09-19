package com.reactnativepayments;

import android.view.WindowManager;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.annotation.NonNull;
import android.app.Fragment;
import android.app.FragmentManager;
import android.support.annotation.RequiresPermission;
import android.util.Log;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactBridge;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.BooleanResult;
import com.google.android.gms.common.api.ResultCallback;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.identity.intents.model.UserAddress;
import com.google.android.gms.wallet.*;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.BaseActivityEventListener;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableNativeArray;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReactNativePaymentsModule extends ReactContextBaseJavaModule implements GoogleApiClient.ConnectionCallbacks, GoogleApiClient.OnConnectionFailedListener {
    public static final String REACT_CLASS = "ReactNativePayments";

    private static final int LOAD_MASKED_WALLET_REQUEST_CODE = 88;
    private static final int LOAD_FULL_WALLET_REQUEST_CODE = 89;
    private static ReactApplicationContext sReactContext;

    // Callbacks
    private static Callback mShowSuccessCallback;
    private static Callback mShowErrorCallback;
    private static Callback mGetFullWalletSuccessCallback;
    private static Callback mGetFullWalletErrorCallback;

    // Google API Client
    private GoogleApiClient mGoogleApiClient;

    public ReactNativePaymentsModule(ReactApplicationContext context) {
        // Pass in the context to the constructor and save it so you can emit events
        // https://facebook.github.io/react-native/docs/native-modules-android.html#the-toast-module
        super(context);

        sReactContext = context;

        final ActivityEventListener activityEventListener = new BaseActivityEventListener() {
            @Override
            public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
                // retrieve the error code, if available
                int errorCode = -1;

                if (data != null) {
                    errorCode = data.getIntExtra(WalletConstants.EXTRA_ERROR_CODE, -1);
                }

                switch (requestCode) {
                    case LOAD_MASKED_WALLET_REQUEST_CODE:
                        switch (resultCode) {
                            case Activity.RESULT_OK:
                                if (data != null) {
                                    final MaskedWallet maskedWallet =
                                            data.getParcelableExtra(WalletConstants.EXTRA_MASKED_WALLET);

                                    Log.i(REACT_CLASS, "ANDROID PAY SUCCESS" + maskedWallet.getEmail());
                                    Log.i(REACT_CLASS, "ANDROID PAY SUCCESS" + buildAddressFromUserAddress(maskedWallet.getBuyerBillingAddress()));

                                    final UserAddress userAddress = maskedWallet.getBuyerShippingAddress();
                                    final WritableNativeMap shippingAddress = userAddress != null
                                            ? buildAddressFromUserAddress(userAddress)
                                            : null;

                                    // TODO: Move into function
                                    final WritableNativeMap paymentDetails = new WritableNativeMap();

                                    paymentDetails.putString("paymentDescription", maskedWallet.getPaymentDescriptions()[0]);
                                    paymentDetails.putString("payerEmail", maskedWallet.getEmail());
                                    paymentDetails.putMap("shippingAddress", shippingAddress);
                                    paymentDetails.putString("googleTransactionId", maskedWallet.getGoogleTransactionId());

                                    sendEvent(sReactContext, "NativePayments:onuseraccept", paymentDetails);
                                }

                                break;
                            case Activity.RESULT_CANCELED:
                                sendEvent(sReactContext, "NativePayments:onuserdismiss", null);

                                break;
                            default:
                                Log.i(REACT_CLASS, "ANDROID PAY ERROR? " + errorCode);
                                mShowErrorCallback.invoke(errorCode);

                                break;
                        }
                        break;
                    case LOAD_FULL_WALLET_REQUEST_CODE:
                        if (resultCode == Activity.RESULT_OK && data != null) {
                            FullWallet fullWallet = data.getParcelableExtra(WalletConstants.EXTRA_FULL_WALLET);
                            String tokenJSON = fullWallet.getPaymentMethodToken().getToken();
                            Log.i(REACT_CLASS, "FULL WALLET SUCCESS" + tokenJSON);

                            mGetFullWalletSuccessCallback.invoke(tokenJSON);
                        } else {
                            Log.i(REACT_CLASS, "FULL WALLET FAILURE");
                            mGetFullWalletErrorCallback.invoke();
                        }

                        break;
                    case WalletConstants.RESULT_ERROR:
                        activity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_SECURE);
//                    handleError(errorCode);

                        break;

                    default:
                        super.onActivityResult(activity, requestCode, resultCode, data);

                        break;
                }
            }
        };

        sReactContext.addActivityEventListener(activityEventListener);
    }

    @Override
    public String getName() {
        // Tell React the name of the module
        // https://facebook.github.io/react-native/docs/native-modules-android.html#the-toast-module
        return REACT_CLASS;
    }

    // Public Methods
    // ---------------------------------------------------------------------------------------------
    @ReactMethod
    public void getSupportedGateways(Callback errorCallback, Callback successCallback) {
        successCallback.invoke(new WritableNativeArray());
    }

    @ReactMethod
    public void canMakePayments(ReadableMap paymentMethodData, Callback errorCallback, Callback successCallback) {
        final Callback callback = successCallback;

        final IsReadyToPayRequest req = IsReadyToPayRequest.newBuilder()
                .addAllowedCardNetwork(WalletConstants.CardNetwork.MASTERCARD)
                .addAllowedCardNetwork(WalletConstants.CardNetwork.VISA)
                .build();

        final int environment = getEnvironmentFromPaymentMethodData(paymentMethodData);

        if (mGoogleApiClient == null) {
            buildGoogleApiClient(getCurrentActivity(), environment);
        }

        Wallet.Payments.isReadyToPay(mGoogleApiClient, req)
                .setResultCallback(new ResultCallback<BooleanResult>() {
                    @Override
                    public void onResult(@NonNull BooleanResult booleanResult) {
                        callback.invoke(booleanResult.getValue());
                    }
                });
    }

    @ReactMethod
    public void abort(Callback errorCallback, Callback successCallback) {
        Log.i(REACT_CLASS, "ANDROID PAY ABORT" + getCurrentActivity().toString());
        successCallback.invoke();
    }

    @ReactMethod
    public void show(ReadableMap paymentMethodData,
                     ReadableMap details,
                     ReadableMap options,
                     Callback errorCallback,
                     Callback successCallback) {
        mShowSuccessCallback = successCallback;
        mShowErrorCallback = errorCallback;

        Log.i(REACT_CLASS, "ANDROID PAY SHOW" + options);

        boolean shouldRequestShipping = options.hasKey("requestShipping") && options.getBoolean("requestShipping")
                || options.hasKey("requestPayerName") && options.getBoolean("requestPayerName")
                || options.hasKey("requestPayerPhone") && options.getBoolean("requestPayerPhone");

        boolean shouldRequestPayerPhone = options.hasKey("requestPayerPhone") && options.getBoolean("requestPayerPhone");

        final PaymentMethodTokenizationParameters parameters = buildTokenizationParametersFromPaymentMethodData(paymentMethodData);

        // TODO: clean up MaskedWalletRequest
        final ReadableMap total = details.getMap("total").getMap("amount");
        final MaskedWalletRequest maskedWalletRequest = MaskedWalletRequest.newBuilder()
                .setPaymentMethodTokenizationParameters(parameters)
                .setPhoneNumberRequired(shouldRequestPayerPhone)
                .setShippingAddressRequired(shouldRequestShipping)
                .setEstimatedTotalPrice(total.getString("value"))
                .setCurrencyCode(total.getString("currency"))
                .build();

        final int environment = getEnvironmentFromPaymentMethodData(paymentMethodData);

        if (mGoogleApiClient == null) {
            buildGoogleApiClient(getCurrentActivity(), environment);
        }

        Wallet.Payments.loadMaskedWallet(mGoogleApiClient, maskedWalletRequest, LOAD_MASKED_WALLET_REQUEST_CODE);
    }

    @ReactMethod
    public void getFullWalletAndroid(String googleTransactionId,
                                     ReadableMap paymentMethodData,
                                     ReadableMap details,
                                     Callback errorCallback,
                                     Callback successCallback) {
        mGetFullWalletSuccessCallback = successCallback;
        mGetFullWalletErrorCallback = errorCallback;

        ReadableMap total = details.getMap("total").getMap("amount");
        Log.i(REACT_CLASS, "ANDROID PAY getFullWalletAndroid" + details.getMap("total").getMap("amount"));

        final FullWalletRequest fullWalletRequest = FullWalletRequest.newBuilder()
                .setGoogleTransactionId(googleTransactionId)
                .setCart(Cart.newBuilder()
                        .setCurrencyCode(total.getString("currency"))
                        .setTotalPrice(total.getString("value"))
                        .setLineItems(buildLineItems(details.getArray("displayItems")))
                        .build())
                .build();

        final int environment = getEnvironmentFromPaymentMethodData(paymentMethodData);

        if (mGoogleApiClient == null) {
            buildGoogleApiClient(getCurrentActivity(), environment);
        }

        Wallet.Payments.loadFullWallet(mGoogleApiClient, fullWalletRequest, LOAD_FULL_WALLET_REQUEST_CODE);
    }

    // Private Method
    // ---------------------------------------------------------------------------------------------
    private static PaymentMethodTokenizationParameters buildTokenizationParametersFromPaymentMethodData(ReadableMap paymentMethodData) {
        final ReadableMap tokenizationParameters = paymentMethodData.getMap("paymentMethodTokenizationParameters");
        final String tokenizationType = tokenizationParameters.getString("tokenizationType");

        if (tokenizationType.equals("GATEWAY_TOKEN")) {
            final ReadableMap parameters = tokenizationParameters.getMap("parameters");

            final PaymentMethodTokenizationParameters.Builder parametersBuilder = PaymentMethodTokenizationParameters.newBuilder()
                    .setPaymentMethodTokenizationType(PaymentMethodTokenizationType.PAYMENT_GATEWAY)
                    .addParameter("gateway", parameters.getString("gateway"));

            ReadableMapKeySetIterator iterator = parameters.keySetIterator();

            while (iterator.hasNextKey()) {
                final String key = iterator.nextKey();

                parametersBuilder.addParameter(key, parameters.getString(key));
            }

            return parametersBuilder.build();

        } else {
            return PaymentMethodTokenizationParameters.newBuilder()
                    .setPaymentMethodTokenizationType(PaymentMethodTokenizationType.NETWORK_TOKEN)
                    .addParameter("publicKey", tokenizationParameters.getMap("parameters").getString("publicKey"))
                    .build();
        }
    }

    private static List buildLineItems(ReadableArray displayItems) {
        final List<LineItem> list = new ArrayList<LineItem>();

        for (int i = 0; i < (displayItems.size() - 1); i++) {
            final ReadableMap displayItem = displayItems.getMap(i);
            final ReadableMap amount = displayItem.getMap("amount");

            list.add(LineItem.newBuilder()
                    .setCurrencyCode(amount.getString("currency"))
                    .setDescription(displayItem.getString("label"))
                    .setQuantity("1")
                    .setUnitPrice(amount.getString("value"))
                    .setTotalPrice(amount.getString("value"))
                    .build());
        }

        Log.i(REACT_CLASS, "ANDROID PAY getFullWalletAndroid" + list);

        return list;
    }

    private static WritableNativeMap buildAddressFromUserAddress(UserAddress userAddress) {
        final WritableNativeMap address = new WritableNativeMap();

        address.putString("recipient", userAddress.getName());
        address.putString("organization", userAddress.getCompanyName());
        address.putString("addressLine", userAddress.getAddress1());
        address.putString("city", userAddress.getLocality());
        address.putString("region", userAddress.getAdministrativeArea());
        address.putString("country", userAddress.getCountryCode());
        address.putString("postalCode", userAddress.getPostalCode());
        address.putString("phone", userAddress.getPhoneNumber());
        address.putNull("languageCode");
        address.putString("sortingCode", userAddress.getSortingCode());
        address.putString("dependentLocality", userAddress.getLocality());

        return address;
    }

    private void sendEvent(ReactApplicationContext reactContext,
                           String eventName,
                           @Nullable WritableNativeMap params) {
        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
    }

    private int getEnvironmentFromPaymentMethodData(ReadableMap paymentMethodData) {
        return paymentMethodData.hasKey("environment")
                && paymentMethodData.getString("environment").equals("TEST")
                ? WalletConstants.ENVIRONMENT_TEST
                : WalletConstants.ENVIRONMENT_PRODUCTION;
    }

    // Google API Client
    // ---------------------------------------------------------------------------------------------
    private void buildGoogleApiClient(Activity currentActivity, int environment) {
        mGoogleApiClient = new GoogleApiClient.Builder(currentActivity)
                .addConnectionCallbacks(this)
                .addOnConnectionFailedListener(this)
                .addApi(Wallet.API, new Wallet.WalletOptions.Builder()
                        .setEnvironment(environment)
                        .setTheme(WalletConstants.THEME_LIGHT)
                        .build())
                .build();

        mGoogleApiClient.connect();
    }

    @Override
    public void onConnected(Bundle connectionHint) {
//        mLastLocation = LocationServices.FusedLocationApi.getLastLocation(mGoogleApiClient);
    }

    @Override
    public void onConnectionFailed(ConnectionResult result) {
        // Refer to Google Play documentation for what errors can be logged
        Log.i(REACT_CLASS, "Connection failed: ConnectionResult.getErrorCode() = "
                + result.getErrorCode());
    }

    @Override
    public void onConnectionSuspended(int cause) {
        // Attempts to reconnect if a disconnect occurs
        Log.i(REACT_CLASS, "Connection suspended");

        mGoogleApiClient.connect();
    }
}
