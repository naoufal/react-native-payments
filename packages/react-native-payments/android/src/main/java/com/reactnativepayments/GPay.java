package com.reactnativepayments;

import android.app.Activity;
import android.content.Intent;
import android.support.annotation.NonNull;
import android.util.Log;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.BaseActivityEventListener;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.google.android.gms.common.api.ApiException;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.wallet.AutoResolveHelper;
import com.google.android.gms.wallet.IsReadyToPayRequest;
import com.google.android.gms.wallet.PaymentData;
import com.google.android.gms.wallet.PaymentDataRequest;
import com.google.android.gms.wallet.PaymentsClient;
import com.google.android.gms.wallet.Wallet;
import com.google.android.gms.wallet.WalletConstants;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

public class GPay extends ReactContextBaseJavaModule {

    private static final String EXPORT_NAME = "GPay";

    /**
     * A constant integer you define to track a request for payment data activity
     */
    private static final int LOAD_PAYMENT_DATA_REQUEST_CODE = 42;

    private static final String E_NO_PAYMENT_REQUEST_JSON = "E_NO_PAYMENT_REQUEST_JSON";

    private static final String E_NO_PAYMENT_REQUEST = "E_NO_PAYMENT_REQUEST";

    private static final String E_NO_ACTIVITY = "E_NO_ACTIVITY";

    private static final String E_PAYMENT_DATA = "E_PAYMENT_DATA";

    private static final String PAYMENT_CANCELLED = "PAYMENT_CANCELLED";

    private static final String E_AUTO_RESOLVE_FAILED = "E_AUTO_RESOLVE_FAILED";

    private static final String NOT_READY_TO_PAY = "NOT_READY_TO_PAY";

    private static final String E_FAILED_TO_DETECT_IF_READY = "E_FAILED_TO_DETECT_IF_READY";

    private static final String ENVIRONMENT_PRODUCTION_KEY = "ENVIRONMENT_PRODUCTION";

    private static final String ENVIRONMENT_TEST_KEY = "ENVIRONMENT_TEST";

    /**
     * Create a Google Pay API base request object with properties used in all
     * requests
     *
     * @return Google Pay API base request object
     * @throws JSONException
     */
    private static JSONObject getBaseRequest() throws JSONException {
        return new JSONObject().put("apiVersion", 2).put("apiVersionMinor", 0).put("emailRequired", true);
    }

    /**
     * Identify your gateway and your app's gateway merchant identifier
     *
     * <p>
     * The Google Pay API response will return an encrypted payment method capable
     * of being charged by a supported gateway after payer authorization
     *
     * @return payment data tokenization for the CARD payment method
     * @throws JSONException
     * @see <a href=
     *      "https://developers.google.com/pay/api/android/reference/object#PaymentMethodTokenizationSpecification">PaymentMethodTokenizationSpecification</a>
     */
    private static JSONObject getTokenizationSpecification(ReadableMap gateway) throws JSONException {
        JSONObject tokenizationSpecification = new JSONObject();
        tokenizationSpecification.put("type", "PAYMENT_GATEWAY");
        switch (gateway.getString("name").toLowerCase()) {
        case "braintree": {
            tokenizationSpecification.put("parameters",
                    new JSONObject().put("gateway", "braintree").put("braintree:apiVersion", "v1")
                            .put("braintree:sdkVersion", gateway.getString("sdkVersion"))
                            .put("braintree:merchantId", gateway.getString("merchantId"))
                            .put("braintree:clientKey", gateway.getString("clientKey")));

            break;
        }
        case "stripe": {
            tokenizationSpecification.put("parameters",
                    new JSONObject().put("gateway", "stripe").put("stripe:sdkVersion", gateway.getString("sdkVersion"))
                            .put("stripe:publishableKey", gateway.getString("clientKey")));

            break;
        }
        default: {
            tokenizationSpecification.put("parameters", new JSONObject().put("gateway", gateway.getString("name"))
                    .put("gatewayMerchantId", gateway.getString("merchantId")));

            break;
        }
        }
        return tokenizationSpecification;
    }

    /**
     * Card networks supported by your app and your gateway
     *
     * @return allowed card networks
     * @see <a href=
     *      "https://developers.google.com/pay/api/android/reference/object#CardParameters">CardParameters</a>
     */
    private static JSONArray getAllowedCardNetworks(ReadableArray cardNetworks) {

        JSONArray jsonArray = new JSONArray();

        for (Object value : cardNetworks.toArrayList()) {
            jsonArray.put(value.toString());
        }

        return jsonArray;
    }

    /**
     * Card authentication methods supported by your app and your gateway
     *
     * @return allowed card authentication methods
     * @see <a href=
     *      "https://developers.google.com/pay/api/android/reference/object#CardParameters">CardParameters</a>
     */
    private static JSONArray getAllowedCardAuthMethods() {
        return new JSONArray()
                // .put("CRYPTOGRAM_3DS")
                .put("PAN_ONLY");
    }

    /**
     * Describe your app's support for the CARD payment method
     *
     * <p>
     * The provided properties are applicable to both an IsReadyToPayRequest and a
     * PaymentDataRequest
     *
     * @return a CARD PaymentMethod object describing accepted cards
     * @throws JSONException
     * @see <a href=
     *      "https://developers.google.com/pay/api/android/reference/object#PaymentMethod">PaymentMethod</a>
     */
    // private static JSONObject getBaseCardPaymentMethod(ReadableMap cardNetworks)
    // throws JSONException {
    // JSONObject cardPaymentMethod = new JSONObject();
    // cardPaymentMethod.put("type", "CARD");

    // JSONObject parameters = new JSONObject().put("allowedAuthMethods",
    // GPay.getAllowedCardAuthMethods());
    // parameters.put("billingAddressRequired", true);
    // JSONObject billingAddressParameters = new JSONObject().put("format", "FULL");
    // parameters.put("billingAddressParameters", billingAddressParameters);

    // cardPaymentMethod.put("parameters", parameters);

    // cardPaymentMethod.put("parameters", new
    // JSONObject().put("allowedAuthMethods", GPay.getAllowedCardAuthMethods())
    // .put("allowedCardNetworks",
    // GPay.getAllowedCardNetworks(cardNetworks.getArray("cardNetworks"))));

    // return cardPaymentMethod;
    // }

    private static JSONObject getBaseCardPaymentMethod(ReadableArray cardNetworks) throws JSONException {
        JSONObject cardPaymentMethod = new JSONObject();
        cardPaymentMethod.put("type", "CARD");

        JSONObject billingAddressParameters = new JSONObject().put("format", "FULL").put("phoneNumberRequired", true);

        cardPaymentMethod.put("parameters",
                new JSONObject().put("allowedAuthMethods", GPay.getAllowedCardAuthMethods())
                        .put("allowedCardNetworks", GPay.getAllowedCardNetworks(cardNetworks))
                        .put("billingAddressRequired", true).put("billingAddressParameters", billingAddressParameters));

        return cardPaymentMethod;
    }

    // private static JSONObject getBaseCardPaymentMethod(ReadableArray
    // cardNetworks) throws JSONException {
    // JSONObject cardPaymentMethod = new JSONObject();
    // cardPaymentMethod.put("type", "CARD");
    // cardPaymentMethod.put("parameters", new
    // JSONObject().put("allowedAuthMethods", GPay.getAllowedCardAuthMethods())
    // .put("allowedCardNetworks", GPay.getAllowedCardNetworks(cardNetworks)));

    // return cardPaymentMethod;
    // }

    /**
     * Describe the expected returned payment data for the CARD payment method
     *
     * @return a CARD PaymentMethod describing accepted cards and optional fields
     * @throws JSONException
     * @see <a href=
     *      "https://developers.google.com/pay/api/android/reference/object#PaymentMethod">PaymentMethod</a>
     */
    private static JSONObject getCardPaymentMethod(ReadableMap cardPaymentMethodMap) throws JSONException {
        JSONObject cardPaymentMethod = GPay.getBaseCardPaymentMethod(cardPaymentMethodMap.getArray("cardNetworks"));
        cardPaymentMethod.put("tokenizationSpecification",
                GPay.getTokenizationSpecification(cardPaymentMethodMap.getMap("gateway")));

        return cardPaymentMethod;
    }

    /**
     * Provide Google Pay API with a payment amount, currency, and amount status
     *
     * @return information about the requested payment
     * @throws JSONException
     * @see <a href=
     *      "https://developers.google.com/pay/api/android/reference/object#TransactionInfo">TransactionInfo</a>
     */
    private static JSONObject getTransactionInfo(ReadableMap transaction) throws JSONException {
        JSONObject transactionInfo = new JSONObject();
        transactionInfo.put("totalPrice", transaction.getString("totalPrice"));
        transactionInfo.put("totalPriceStatus", transaction.getString("totalPriceStatus"));
        transactionInfo.put("currencyCode", transaction.getString("currencyCode"));

        return transactionInfo;
    }

    /**
     * Information about the merchant requesting payment information
     *
     * @return information about the merchant
     * @throws JSONException
     * @see <a href=
     *      "https://developers.google.com/pay/api/android/reference/object#MerchantInfo">MerchantInfo</a>
     */
    private static JSONObject getMerchantInfo(String merchantName) throws JSONException {
        return new JSONObject().put("merchantName", merchantName);
    }

    /**
     * An object describing accepted forms of payment by your app, used to determine
     * a viewer's readiness to pay
     *
     * @return API version and payment methods supported by the app
     * @see <a href=
     *      "https://developers.google.com/pay/api/android/reference/object#IsReadyToPayRequest">IsReadyToPayRequest</a>
     */
    private static JSONObject getIsReadyToPayRequest(ReadableArray cardNetworks) {
        try {
            JSONObject isReadyToPayRequest = GPay.getBaseRequest();
            isReadyToPayRequest.put("allowedPaymentMethods",
                    new JSONArray().put(getBaseCardPaymentMethod(cardNetworks)));
            return isReadyToPayRequest;
        } catch (JSONException e) {
            Log.e("getIsReadyToPayRequest", e.toString());
            return null;
        }
    }

    /**
     * An object describing information requested in a Google Pay payment sheet
     *
     * @return payment data expected by your app
     * @see <a href=
     *      "https://developers.google.com/pay/api/android/reference/object#PaymentDataRequest">PaymentDataRequest</a>
     */
    private static JSONObject getPaymentDataRequest(ReadableMap requestData) {
        try {
            JSONObject paymentDataRequest = GPay.getBaseRequest();
            paymentDataRequest.put("allowedPaymentMethods",
                    new JSONArray().put(GPay.getCardPaymentMethod(requestData.getMap("cardPaymentMethodMap"))));
            paymentDataRequest.put("transactionInfo", GPay.getTransactionInfo(requestData.getMap("transaction")));
            paymentDataRequest.put("merchantInfo", GPay.getMerchantInfo(requestData.getString("merchantName")));
            return paymentDataRequest;
        } catch (JSONException e) {
            Log.e("getPaymentDataRequest", e.toString());
            return null;
        }
    }

    /**
     * A client for interacting with the Google Pay API
     *
     * @see <a href=
     *      "https://developers.google.com/android/reference/com/google/android/gms/wallet/PaymentsClient">PaymentsClient</a>
     */
    private PaymentsClient mPaymentsClient = null;

    private Promise mRequestPaymentPromise = null;

    private final ActivityEventListener mActivityEventListener = new BaseActivityEventListener() {

        /**
         * Handle a resolved activity from the Google Pay payment sheet
         *
         * @param requestCode the request code originally supplied to AutoResolveHelper
         *                    in requestPayment()
         * @param resultCode  the result code returned by the Google Pay API
         * @param data        an Intent from the Google Pay API containing payment or
         *                    error data
         * @see <a href=
         *      "https://developer.android.com/training/basics/intents/result">Getting a
         *      result from an Activity</a>
         */
        @Override
        public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {

            switch (requestCode) {
            // value passed in AutoResolveHelper
            case LOAD_PAYMENT_DATA_REQUEST_CODE:
                switch (resultCode) {
                case Activity.RESULT_OK:
                    PaymentData paymentData = PaymentData.getFromIntent(data);
                    if (paymentData == null) {
                        mRequestPaymentPromise.reject(E_PAYMENT_DATA, "payment data is null");
                    } else {
                        String json = paymentData.toJson();
                        if (json != null) {
                            JSONObject paymentDataJson = null;
                            try {
                                paymentDataJson = new JSONObject(json);
                            } catch (JSONException e) {
                                mRequestPaymentPromise.reject(E_PAYMENT_DATA, e.getMessage());
                            }
                            if (paymentDataJson == null)
                                return;
                            try {
                                Log.i("FEKETE", paymentDataJson.toString());
                                JSONObject paymentMethodData = paymentDataJson.getJSONObject("paymentMethodData");
                                
                                String token = paymentMethodData.getJSONObject("tokenizationData").getString("token");
                                String lastFour = paymentMethodData.getJSONObject("info").getString("cardDetails");
                                JSONObject cardInfo = new JSONObject().put("lastFour", lastFour);
                                JSONObject billing = paymentMethodData.getJSONObject("info")
                                        .getJSONObject("billingAddress");

                                JSONObject contact = new JSONObject();
                                try {
                                    contact.put("phoneNumber", billing.getString("phoneNumber"));
                                } catch (Exception e) {
                                    contact.put("phoneNumber", null);
                                }

                                try {
                                    contact.put("email", paymentDataJson.getString("email"));
                                } catch (Exception e) {
                                    contact.put("email", null);
                                }

                                JSONObject response = new JSONObject().put("details",
                                        new JSONObject().put("paymentData", new JSONObject().put("data", token)));
                                response.put("billing", billing);
                                response.put("contact", contact);
                                response.put("cardInfo", cardInfo);

                                Log.v("Token : ", token);
                                Log.v("Response", paymentMethodData.toString());
                                mRequestPaymentPromise.resolve(response.toString());
                            } catch (JSONException e) {
                                mRequestPaymentPromise.reject(E_PAYMENT_DATA, e.getMessage());
                            }

                        } else {
                            mRequestPaymentPromise.reject(E_AUTO_RESOLVE_FAILED, "method is null");
                        }
                    }
                    break;
                case Activity.RESULT_CANCELED:
                    mRequestPaymentPromise.reject(PAYMENT_CANCELLED, "payment has been canceled");

                    break;
                case AutoResolveHelper.RESULT_ERROR:
                    Status status = AutoResolveHelper.getStatusFromIntent(data);
                    mRequestPaymentPromise.reject(E_AUTO_RESOLVE_FAILED,
                            "auto resolve has been failed. status: " + status.getStatusMessage());
                    break;
                default:
                    // Do nothing.
                }
                break;
            default:
                // Do nothing.
            }

            mRequestPaymentPromise = null;
        }

    };

    /**
     * Constructor
     *
     * @param context
     */
    public GPay(ReactApplicationContext context) {
        // Pass in the context to the constructor and save it so you can emit events
        // https://facebook.github.io/react-native/docs/native-modules-android.html#the-toast-module
        super(context);

        context.addActivityEventListener(mActivityEventListener);

    }

    @Override
    public String getName() {
        return EXPORT_NAME;
    }

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        constants.put(ENVIRONMENT_PRODUCTION_KEY, WalletConstants.ENVIRONMENT_PRODUCTION);
        constants.put(ENVIRONMENT_TEST_KEY, WalletConstants.ENVIRONMENT_TEST);
        return constants;
    }

    /**
     * Check if google pay is available
     *
     * @see <a href=
     *      "https://developers.google.com/android/reference/com/google/android/gms/wallet/PaymentsClient#isReadyToPay(com.google.android.gms.wallet.IsReadyToPayRequest)">PaymentsClient#IsReadyToPay</a>
     */
    @ReactMethod
    public void checkGPayIsEnable(int environment, ReadableArray cardNetworks, final Promise promise) {
        final JSONObject isReadyToPayJson = GPay.getIsReadyToPayRequest(cardNetworks);
        if (isReadyToPayJson == null) {
            promise.reject(NOT_READY_TO_PAY, "not ready to pay");
        }
        IsReadyToPayRequest request = IsReadyToPayRequest.fromJson(isReadyToPayJson.toString());
        if (request == null) {
            promise.reject(NOT_READY_TO_PAY, "not ready to pay");
        }

        Activity activity = getCurrentActivity();

        if (activity == null) {
            promise.reject(E_NO_ACTIVITY, "activity is null");
        }

        Task<Boolean> task = getPaymentsClient(environment, activity).isReadyToPay(request);
        task.addOnCompleteListener(new OnCompleteListener<Boolean>() {
            @Override
            public void onComplete(@NonNull Task<Boolean> task) {
                try {
                    boolean result = task.getResult(ApiException.class);
                    if (result) {
                        promise.resolve(result);
                    } else {
                        promise.reject(NOT_READY_TO_PAY, "not ready to pay");
                    }
                } catch (ApiException exception) {
                    promise.reject(E_FAILED_TO_DETECT_IF_READY, exception.getMessage());
                }
            }
        });
    }

    /**
     * Display the Google Pay payment sheet
     */
    @ReactMethod
    public void show(int environment, ReadableMap requestData, final Promise promise) {

        Activity activity = getCurrentActivity();

        if (activity == null) {
            promise.reject(E_NO_ACTIVITY, "activity is null");
            return;
        }

        this.mRequestPaymentPromise = promise;

        JSONObject paymentDataRequestJson = GPay.getPaymentDataRequest(requestData);
        if (paymentDataRequestJson == null) {
            promise.reject(E_NO_PAYMENT_REQUEST_JSON, "payment data request json is null");
            return;
        }
        PaymentDataRequest request = PaymentDataRequest.fromJson(paymentDataRequestJson.toString());

        if (request != null) {
            AutoResolveHelper.resolveTask(getPaymentsClient(environment, activity).loadPaymentData(request), activity,
                    LOAD_PAYMENT_DATA_REQUEST_CODE);
        } else {
            promise.reject(E_NO_PAYMENT_REQUEST, "payment data request is null");
        }
    }

    private PaymentsClient getPaymentsClient(int environment, @NonNull Activity activity) {

        if (mPaymentsClient == null) {
            mPaymentsClient = Wallet.getPaymentsClient(activity,
                    new Wallet.WalletOptions.Builder().setEnvironment(environment).build());
        }

        return mPaymentsClient;
    }
}