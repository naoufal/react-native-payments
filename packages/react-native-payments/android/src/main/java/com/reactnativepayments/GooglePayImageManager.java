package com.reactnativepayments;

import android.view.LayoutInflater;
import android.view.View;

import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;

public class GooglePayImageManager extends SimpleViewManager<View> {

    public static final String REACT_CLASS = "GooglePayImageView";

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    protected View createViewInstance(ThemedReactContext reactContext) {
        return LayoutInflater.from(reactContext).inflate(
                R.layout.buy_with_googlepay_button, null);
    }
}
