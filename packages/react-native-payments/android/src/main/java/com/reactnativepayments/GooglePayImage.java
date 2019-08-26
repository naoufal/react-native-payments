package com.reactnativepayments;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.RelativeLayout;

/**
 * Image of Google Pay Button (buy_with_googlepay_button)
 * see https://developers.google.com/pay/api/android/guides/brand-guidelines
 */
public class GooglePayImage extends RelativeLayout {

    public GooglePayImage(Context context) {
        super(context);

        View view =  LayoutInflater.from(getContext()).inflate(
                R.layout.buy_with_googlepay_button, null);

        this.addView(view);
    }
}
