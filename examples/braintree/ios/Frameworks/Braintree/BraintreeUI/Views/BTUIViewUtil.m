#import "BTUIViewUtil.h"
@import AudioToolbox;

@implementation BTUIViewUtil

+ (BTUIPaymentOptionType)paymentMethodTypeForCardType:(BTUICardType *)cardType {

    if (cardType == nil) {
        return BTUIPaymentOptionTypeUnknown;
    }

    if ([cardType.brand isEqualToString:BTUILocalizedString(CARD_TYPE_AMERICAN_EXPRESS)]) {
        return BTUIPaymentOptionTypeAMEX;
    } else if ([cardType.brand isEqualToString:BTUILocalizedString(CARD_TYPE_VISA)]) {
        return BTUIPaymentOptionTypeVisa;
    } else if ([cardType.brand isEqualToString:BTUILocalizedString(CARD_TYPE_MASTER_CARD)]) {
        return BTUIPaymentOptionTypeMasterCard;
    } else if ([cardType.brand isEqualToString:BTUILocalizedString(CARD_TYPE_DISCOVER)]) {
        return BTUIPaymentOptionTypeDiscover;
    } else if ([cardType.brand isEqualToString:BTUILocalizedString(CARD_TYPE_JCB)]) {
        return BTUIPaymentOptionTypeJCB;
    } else if ([cardType.brand isEqualToString:BTUILocalizedString(CARD_TYPE_MAESTRO)]) {
        return BTUIPaymentOptionTypeMaestro;
    } else if ([cardType.brand isEqualToString:BTUILocalizedString(CARD_TYPE_DINERS_CLUB)]) {
        return BTUIPaymentOptionTypeDinersClub;
    } else if ([cardType.brand isEqualToString:BTUILocalizedString(CARD_TYPE_UNION_PAY)]) {
        return BTUIPaymentOptionTypeUnionPay;
    } else {
        return BTUIPaymentOptionTypeUnknown;
    }
}


+ (NSString *)nameForPaymentMethodType:(BTUIPaymentOptionType)paymentMethodType {
  switch (paymentMethodType) {
    case BTUIPaymentOptionTypeUnknown:
      return @"Card";
    case BTUIPaymentOptionTypeAMEX:
          return BTUILocalizedString(CARD_TYPE_AMERICAN_EXPRESS);
    case BTUIPaymentOptionTypeDinersClub:
          return BTUILocalizedString(CARD_TYPE_DINERS_CLUB);
    case BTUIPaymentOptionTypeDiscover:
      return BTUILocalizedString(CARD_TYPE_DISCOVER);
    case BTUIPaymentOptionTypeMasterCard:
        return BTUILocalizedString(CARD_TYPE_MASTER_CARD);
    case BTUIPaymentOptionTypeVisa:
          return BTUILocalizedString(CARD_TYPE_VISA);
    case BTUIPaymentOptionTypeJCB:
          return BTUILocalizedString(CARD_TYPE_JCB);
    case BTUIPaymentOptionTypeLaser:
          return BTUILocalizedString(CARD_TYPE_LASER);
    case BTUIPaymentOptionTypeMaestro:
          return BTUILocalizedString(CARD_TYPE_MAESTRO);
    case BTUIPaymentOptionTypeUnionPay:
          return BTUILocalizedString(CARD_TYPE_UNION_PAY);
    case BTUIPaymentOptionTypeSolo:
          return BTUILocalizedString(CARD_TYPE_SOLO);
    case BTUIPaymentOptionTypeSwitch:
          return BTUILocalizedString(CARD_TYPE_SWITCH);
    case BTUIPaymentOptionTypeUKMaestro:
          return BTUILocalizedString(CARD_TYPE_MAESTRO);
    case BTUIPaymentOptionTypePayPal:
          return BTUILocalizedString(PAYPAL_CARD_BRAND);
    case BTUIPaymentOptionTypeCoinbase:
          return BTUILocalizedString(PAYMENT_METHOD_TYPE_COINBASE);
    case BTUIPaymentOptionTypeVenmo:
          return BTUILocalizedString(PAYMENT_METHOD_TYPE_VENMO);
    }
    
}

+ (void)vibrate {
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

@end
