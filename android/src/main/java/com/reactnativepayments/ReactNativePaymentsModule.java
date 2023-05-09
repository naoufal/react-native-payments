package com.reactnativepayments;

import android.view.WindowManager;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import androidx.annotation.Nullable;
import androidx.annotation.NonNull;
import android.app.Fragment;
import android.app.FragmentManager;
import androidx.annotation.RequiresPermission;
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
import com.google.android.gms.common.api.ApiException;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;

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

import org.json.JSONException;
import org.json.JSONObject;

public class ReactNativePaymentsModule extends ReactContextBaseJavaModule {
    private static final int LOAD_MASKED_WALLET_REQUEST_CODE = 88;


    // Payments Client
    private PaymentsClient mPaymentsClient;

    // Callbacks
    private static Callback mShowSuccessCallback = null;
    private static Callback mShowErrorCallback = null;

    public static final String REACT_CLASS = "ReactNativePayments";

    private static ReactApplicationContext reactContext = null;

    private final ActivityEventListener mActivityEventListener = new BaseActivityEventListener() {
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

                                PaymentData paymentData = PaymentData.getFromIntent(data);

                                Log.i(REACT_CLASS, "ANDROID PAY SUCCESS" + buildAddressFromUserAddress(paymentData.getCardInfo().getBillingAddress()));

                                UserAddress userAddress = paymentData.getShippingAddress();
                                WritableNativeMap shippingAddress = userAddress != null
                                    ? buildAddressFromUserAddress(userAddress)
                                    : null;


                                // TODO: Move into function
                                WritableNativeMap paymentDetails = new WritableNativeMap();
                                paymentDetails.putString("payerEmail", paymentData.getEmail());
                                paymentDetails.putMap("shippingAddress", shippingAddress);
                                paymentDetails.putString("googleTransactionId", paymentData.getGoogleTransactionId());

                                WritableNativeMap cardInfo = buildCardInfo(paymentData.getCardInfo());
                                paymentDetails.putMap("cardInfo", cardInfo);

                                String serializedPaymentToken = paymentData.getPaymentMethodToken().getToken();
                                try {
                                    JSONObject paymentTokenJson = new JSONObject(serializedPaymentToken);
                                    String protocolVersion = paymentTokenJson.getString("protocolVersion");
                                    String signature = paymentTokenJson.getString("signature");
                                    String signedMessage = paymentTokenJson.getString("signedMessage");

                                    WritableNativeMap paymentToken = new WritableNativeMap();
                                    paymentToken.putString("protocolVersion", protocolVersion);
                                    paymentToken.putString("signature", signature);
                                    paymentToken.putString("signedMessage", signedMessage);

                                    paymentDetails.putMap("paymentToken", paymentToken);

                                    sendEvent(reactContext, "NativePayments:onuseraccept", paymentDetails);

                                } catch (JSONException e) {
                                    Log.e(REACT_CLASS, "ANDROID PAY JSON ERROR", e);
                                    mShowErrorCallback.invoke(errorCode);
                                }
                            }
                            break;
                        case Activity.RESULT_CANCELED:
                            sendEvent(reactContext, "NativePayments:onuserdismiss", null);

                            break;
                        default:
                            Log.i(REACT_CLASS, "ANDROID PAY ERROR? " + errorCode);
                            mShowErrorCallback.invoke(errorCode);

                            break;
                    }
                    break;
                case WalletConstants.RESULT_ERROR:activity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_SECURE);
//                    handleError(errorCode);
                    break;

                default:
                    super.onActivityResult(requestCode, resultCode, data);
                    break;
            }
        }
    };

    public ReactNativePaymentsModule(ReactApplicationContext context) {
        // Pass in the context to the constructor and save it so you can emit events
        // https://facebook.github.io/react-native/docs/native-modules-android.html#the-toast-module
        super(context);

        reactContext = context;

        reactContext.addActivityEventListener(mActivityEventListener);
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
        WritableNativeArray supportedGateways = new WritableNativeArray();

        successCallback.invoke(supportedGateways);
    }

    @ReactMethod
    public void canMakePayments(ReadableMap paymentMethodData, final Callback errorCallback, final Callback successCallback) {
        IsReadyToPayRequest.Builder builder = IsReadyToPayRequest.newBuilder();

        ReadableArray allowedCardNetworks = paymentMethodData.getArray("supportedNetworks");
        if (allowedCardNetworks != null) {
            builder.addAllowedCardNetworks(buildAllowedCardNetworks(allowedCardNetworks));
        }

        ReadableArray allowedPaymentMethods = paymentMethodData.getArray("allowedPaymentMethods");
        if (allowedPaymentMethods != null) {
            builder.addAllowedPaymentMethods(buildAllowedPaymentMethods(allowedPaymentMethods));
        }

        IsReadyToPayRequest request = builder.build();


        int environment = getEnvironmentFromPaymentMethodData(paymentMethodData);
        if (mPaymentsClient == null) {
            buildPaymentsClient(getCurrentActivity(), environment);
        }

        Task<Boolean> task = mPaymentsClient.isReadyToPay(request);
        task.addOnCompleteListener(
            new OnCompleteListener<Boolean>() {
                @Override
                public void onComplete(@NonNull Task<Boolean> task) {
                    try {
                        boolean result = task.getResult(ApiException.class);
                        if (result) {
                            successCallback.invoke(result);
                        }
                    } catch (ApiException e) {
                        errorCallback.invoke(e.getMessage());
                    }
                }
            });
    }

    @ReactMethod
    public void abort(Callback errorCallback, Callback successCallback) {
        Log.i(REACT_CLASS, "ANDROID PAY ABORT" + getCurrentActivity().toString());
        successCallback.invoke();
    }

    @ReactMethod
    public void show(
            ReadableMap paymentMethodData,
            ReadableMap details,
            ReadableMap options,
            Callback errorCallback,
            Callback successCallback
    ) {
        mShowSuccessCallback = successCallback;
        mShowErrorCallback = errorCallback;

        Log.i(REACT_CLASS, "ANDROID PAY SHOW" + options);

        Boolean shouldRequestShipping = options.hasKey("requestShipping") && options.getBoolean("requestShipping")
                        || options.hasKey("requestPayerName") && options.getBoolean("requestPayerName")
                        || options.hasKey("requestPayerPhone") && options.getBoolean("requestPayerPhone");
        Boolean shouldRequestPayerPhone = options.hasKey("requestPayerPhone") && options.getBoolean("requestPayerPhone");

        final PaymentMethodTokenizationParameters parameters = buildTokenizationParametersFromPaymentMethodData(paymentMethodData);

        ReadableMap total = details.getMap("total").getMap("amount");


        PaymentDataRequest.Builder builder = PaymentDataRequest.newBuilder()
            .setTransactionInfo(TransactionInfo.newBuilder()
                .setTotalPriceStatus(WalletConstants.TOTAL_PRICE_STATUS_FINAL)
                .setTotalPrice(total.getString("value"))
                .setCurrencyCode(total.getString("currency"))
                .build())
            .setPhoneNumberRequired(shouldRequestPayerPhone)
            .setShippingAddressRequired(shouldRequestShipping)
            .setPaymentMethodTokenizationParameters(parameters);


        ReadableArray allowedCardNetworks = paymentMethodData.getArray("supportedNetworks");
        if (allowedCardNetworks != null) {
            builder.setCardRequirements(CardRequirements.newBuilder()
                .addAllowedCardNetworks(buildAllowedCardNetworks(allowedCardNetworks)).build()
            );
        }

        ReadableArray allowedPaymentMethods = paymentMethodData.getArray("allowedPaymentMethods");
        if (allowedPaymentMethods != null) {
            builder.addAllowedPaymentMethods(buildAllowedPaymentMethods(allowedPaymentMethods));
        }

        PaymentDataRequest request = builder.build();

        int environment = getEnvironmentFromPaymentMethodData(paymentMethodData);

        if (mPaymentsClient == null) buildPaymentsClient(getCurrentActivity(), environment);

        AutoResolveHelper.resolveTask(
            mPaymentsClient.loadPaymentData(request), getCurrentActivity(), LOAD_MASKED_WALLET_REQUEST_CODE);
    }

    // Private Method
    // ---------------------------------------------------------------------------------------------
    private static PaymentMethodTokenizationParameters buildTokenizationParametersFromPaymentMethodData(ReadableMap paymentMethodData) {
        ReadableMap tokenizationParameters = paymentMethodData.getMap("paymentMethodTokenizationParameters");
        String tokenizationType = tokenizationParameters.getString("tokenizationType");


        if (tokenizationType.equals("GATEWAY_TOKEN")) {
            ReadableMap parameters = tokenizationParameters.getMap("parameters");
            PaymentMethodTokenizationParameters.Builder parametersBuilder = PaymentMethodTokenizationParameters.newBuilder()
                    .setPaymentMethodTokenizationType(PaymentMethodTokenizationType.PAYMENT_GATEWAY)
                    .addParameter("gateway", parameters.getString("gateway"));

            ReadableMapKeySetIterator iterator = parameters.keySetIterator();

            while (iterator.hasNextKey()) {
                String key = iterator.nextKey();

                parametersBuilder.addParameter(key, parameters.getString(key));
            }

            return parametersBuilder.build();

        } else {
            String publicKey = tokenizationParameters.getMap("parameters").getString("publicKey");

            return PaymentMethodTokenizationParameters.newBuilder()
                    .setPaymentMethodTokenizationType(PaymentMethodTokenizationType.NETWORK_TOKEN)
                    .addParameter("publicKey", publicKey)
                    .build();
        }
    }

    protected static List<Integer> buildAllowedPaymentMethods(ReadableArray allowedPaymentMethods) {
        List<Integer> result = new ArrayList<Integer>();
        int size = allowedPaymentMethods.size();
        for (int i = 0; i < size; ++i) {
            int allowedPaymentMethod = allowedPaymentMethods.getInt(i);
            result.add(allowedPaymentMethod);
        }

        return result;
    }

    protected static List<Integer> buildAllowedCardNetworks(ReadableArray allowedCardNetworks) {
        List<Integer> result = new ArrayList<Integer>();
        int size = allowedCardNetworks.size();
        for (int i = 0; i < size; ++i) {
            String allowedCardNetwork = allowedCardNetworks.getString(i);
            switch (allowedCardNetwork) {
                case "visa":
                    result.add(WalletConstants.CARD_NETWORK_VISA);
                    break;
                case "mastercard":
                    result.add(WalletConstants.CARD_NETWORK_MASTERCARD);
                    break;
                case "amex":
                    result.add(WalletConstants.CARD_NETWORK_AMEX);
                    break;
                case "discover":
                    result.add(WalletConstants.CARD_NETWORK_DISCOVER);
                    break;
                case "interac":
                    result.add(WalletConstants.CARD_NETWORK_INTERAC);
                    break;
                case "jcb":
                    result.add(WalletConstants.CARD_NETWORK_JCB);
                    break;
                default:
                    result.add(WalletConstants.CARD_NETWORK_OTHER);
            }
        }

        return result;
    }

    protected static WritableNativeMap buildCardInfo(CardInfo cardInfo) {

        if (cardInfo == null) return null;


        WritableNativeMap result = new WritableNativeMap();

        result.putInt("cardClass", cardInfo.getCardClass());
        result.putString("cardDescription", cardInfo.getCardDescription());
        result.putString("cardDetails", cardInfo.getCardDetails());
        result.putString("cardNetwork", cardInfo.getCardNetwork());

        return result;
    }

    private static List buildLineItems(ReadableArray displayItems) {
        List<LineItem> list = new ArrayList<LineItem>();


        for (int i = 0; i < (displayItems.size() - 1); i++) {
            ReadableMap displayItem = displayItems.getMap(i);
            ReadableMap amount = displayItem.getMap("amount");

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
        WritableNativeMap address = new WritableNativeMap();

        if (userAddress == null) return address;

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

    private void sendEvent(
            ReactApplicationContext reactContext,
            String eventName,
            @Nullable WritableNativeMap params
    ) {
        reactContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
    }

    private int getEnvironmentFromPaymentMethodData(ReadableMap paymentMethodData) {
        return paymentMethodData.hasKey("environment") && paymentMethodData.getString("environment").equals("TEST")
                ? WalletConstants.ENVIRONMENT_TEST
                : WalletConstants.ENVIRONMENT_PRODUCTION;
    }

    protected void buildPaymentsClient(Activity currentActivity, int environment) {
        mPaymentsClient = Wallet.getPaymentsClient(
            currentActivity,
            new Wallet.WalletOptions.Builder()
                .setEnvironment(environment)
                .build()
        );
    }
}
