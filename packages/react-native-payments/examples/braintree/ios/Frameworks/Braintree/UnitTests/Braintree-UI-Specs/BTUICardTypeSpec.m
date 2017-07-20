#import <UIKit/UIKit.h>
#import "BTSpecDependencies.h"
#import "BTUICardType.h"
#import "EXPMatchers+haveKerning.h"
#import "BTUIViewUtil.h"

SpecBegin(BTUICardType)

describe(@"BTUICardType", ^{

    it(@"should only have one instance of each brand", ^{
        BTUICardType *t1 = [BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_AMERICAN_EXPRESS)];
        BTUICardType *t2 = [BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_AMERICAN_EXPRESS)];
        expect(t1).to.beIdenticalTo(t2);
    });

    describe(@"possible card types for number", ^{

        it(@"should recognize all cards with empty string", ^{
            NSArray *possibleCardTypes = [BTUICardType possibleCardTypesForNumber:@""];
            expect(possibleCardTypes.count).to.equal(9);
        });

        it(@"should recognize no cards starting with 1", ^{
            NSArray *possibleCardTypes = [BTUICardType possibleCardTypesForNumber:@"1"];
            expect(possibleCardTypes.count).to.equal(0);
        });

        it(@"should recognize AmEx and Diners Club and JCB cards with 3", ^{
            NSArray *possibleCardTypes = [BTUICardType possibleCardTypesForNumber:@"3"];
            expect(possibleCardTypes.count).to.equal(3);
            expect(possibleCardTypes).to.contain([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_DINERS_CLUB)]);
            expect(possibleCardTypes).to.contain([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_AMERICAN_EXPRESS)]);
            expect(possibleCardTypes).to.contain([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_JCB)]);
        });

        it(@"should recognize MasterCard and Maestro with a 5", ^{
            NSArray *possibleCardTypes = [BTUICardType possibleCardTypesForNumber:@"5"];
            expect(possibleCardTypes.count).to.equal(2);
            expect(possibleCardTypes).to.contain([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_MASTER_CARD)]);
            expect(possibleCardTypes).to.contain([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_MAESTRO)]);
        });
        
        it(@"should recognize Maestro cards starting with 63", ^{
            NSArray *possibleCardTypes = [BTUICardType possibleCardTypesForNumber:@"63"];
            expect(possibleCardTypes).to.contain([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_MAESTRO)]);
        });
        
        it(@"should recognize Maestro cards starting with 67", ^{
            NSArray *possibleCardTypes = [BTUICardType possibleCardTypesForNumber:@"67"];
            expect(possibleCardTypes).to.contain([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_MAESTRO)]);
        });

        it(@"should recognize the start of a Visa", ^{
            NSArray *possibleCardTypes = [BTUICardType possibleCardTypesForNumber:@"4"];
            expect(possibleCardTypes).to.contain([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_VISA)]);
            expect(possibleCardTypes.count).to.equal(1);
        });

        it(@"should recognize a whole Visa", ^{
            NSArray *possibleCardTypes = [BTUICardType possibleCardTypesForNumber:@"4111111111111111"];
            expect(possibleCardTypes).to.contain([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_VISA)]);
            expect(possibleCardTypes.count).to.equal(1);
        });
    });

    describe(@"payment method type for card type", ^{
        it(@"recognizes Visa", ^{
            BTUICardType *cardType = [BTUICardType cardTypeForBrand:@"Visa"];
            expect([BTUIViewUtil paymentMethodTypeForCardType:cardType]).to.equal(BTUIPaymentOptionTypeVisa);
        });

        it(@"recognizes MasterCard", ^{
            BTUICardType *cardType = [BTUICardType cardTypeForBrand:@"MasterCard"];
            expect([BTUIViewUtil paymentMethodTypeForCardType:cardType]).to.equal(BTUIPaymentOptionTypeMasterCard);
        });

        it(@"recognizes Amex", ^{
            BTUICardType *cardType = [BTUICardType cardTypeForBrand:@"American Express"];
            expect([BTUIViewUtil paymentMethodTypeForCardType:cardType]).to.equal(BTUIPaymentOptionTypeAMEX);
        });

        it(@"recognizes Discover", ^{
            BTUICardType *cardType = [BTUICardType cardTypeForBrand:@"Discover"];
            expect([BTUIViewUtil paymentMethodTypeForCardType:cardType]).to.equal(BTUIPaymentOptionTypeDiscover);
        });

        it(@"recognizes JCB", ^{
            BTUICardType *cardType = [BTUICardType cardTypeForBrand:@"JCB"];
            expect([BTUIViewUtil paymentMethodTypeForCardType:cardType]).to.equal(BTUIPaymentOptionTypeJCB);
        });

        it(@"recognizes Maestro", ^{
            BTUICardType *cardType = [BTUICardType cardTypeForBrand:@"Maestro"];
            expect([BTUIViewUtil paymentMethodTypeForCardType:cardType]).to.equal(BTUIPaymentOptionTypeMaestro);
        });

        it(@"recognizes Diners Club", ^{
            BTUICardType *cardType = [BTUICardType cardTypeForBrand:@"Diners Club"];
            expect([BTUIViewUtil paymentMethodTypeForCardType:cardType]).to.equal(BTUIPaymentOptionTypeDinersClub);
        });

        it(@"ignores unknown card brands", ^{
            BTUICardType *cardType = [BTUICardType cardTypeForBrand:@"Unknown Card Brand"];
            expect([BTUIViewUtil paymentMethodTypeForCardType:cardType]).to.equal(BTUIPaymentOptionTypeUnknown);
        });
    });

    describe(@"card number recognition", ^{

        it(@"should recognize a valid, formatted Visa", ^{
            expect([BTUICardType cardTypeForNumber:@"4111 1111 1111 1111"]).to.equal([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_VISA)]);
        });

        it(@"should recognize an invalid Visa", ^{
            expect([BTUICardType cardTypeForNumber:@"4111 1111 1111 1112"]).to.equal([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_VISA)]);
        });

        it(@"should recognize a non-formatted Visa", ^{
            expect([BTUICardType cardTypeForNumber:@"4111111111111111"]).to.equal([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_VISA)]);
        });

        it(@"should recognize an incomplete Visa", ^{
            expect([BTUICardType cardTypeForNumber:@"4"]).to.equal([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_VISA)]);
        });

        it(@"should recognize a valid MasterCard", ^{
            expect([BTUICardType cardTypeForNumber:@"5555555555554444"]).to.equal([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_MASTER_CARD)]);
        });

        it(@"should recognize a valid American Express", ^{
            expect([BTUICardType cardTypeForNumber:@"378282246310005"]).to.equal([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_AMERICAN_EXPRESS)]);
        });

        it(@"should recognize a valid Discover", ^{
            expect([BTUICardType cardTypeForNumber:@"6011 1111 1111 1117"]).to.equal([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_DISCOVER)]);
        });

        it(@"should recognize a valid JCB", ^{
            expect([BTUICardType cardTypeForNumber:@"3530 1113 3330 0000"]).to.equal([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_JCB)]);
        });

        it(@"should recognize a valid Union Pay", ^{
            expect([BTUICardType cardTypeForNumber:@"6221 2345 6789 0123 450"]).to.equal([BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_UNION_PAY)]);
        });

        it(@"should not recognize a non-number", ^{
            expect([BTUICardType cardTypeForNumber:@"notanumber"]).to.beNil();
        });

        it(@"should not recognize an unrecognizable number", ^{
            expect([BTUICardType cardTypeForNumber:@"notanumber"]).to.beNil();
        });

    });

    describe(@"validNumber", ^{
        NSArray *braintreeTestCardNumbers =
        @[
          @[@"378282246310005", BTUILocalizedString(CARD_TYPE_AMERICAN_EXPRESS)],
          @[@"371449635398431", BTUILocalizedString(CARD_TYPE_AMERICAN_EXPRESS)],
          @[@"6011111111111117", BTUILocalizedString(CARD_TYPE_DISCOVER)],
          @[@"3530111333300000", BTUILocalizedString(CARD_TYPE_JCB)],
          @[@"6304000000000000", BTUILocalizedString(CARD_TYPE_MAESTRO)],
          @[@"5555555555554444", BTUILocalizedString(CARD_TYPE_MASTER_CARD)],
          @[@"4111111111111111", BTUILocalizedString(CARD_TYPE_VISA)],
          @[@"4005519200000004", BTUILocalizedString(CARD_TYPE_VISA)],
          @[@"4009348888881881", BTUILocalizedString(CARD_TYPE_VISA)],
          @[@"4012000033330026", BTUILocalizedString(CARD_TYPE_VISA)],
          @[@"4012000077777777", BTUILocalizedString(CARD_TYPE_VISA)],
          @[@"4012888888881881", BTUILocalizedString(CARD_TYPE_VISA)],
          @[@"4217651111111119", BTUILocalizedString(CARD_TYPE_VISA)],
          @[@"4500600000000061", BTUILocalizedString(CARD_TYPE_VISA)],
          @[@"6221234567890123450", BTUILocalizedString(CARD_TYPE_UNION_PAY)],
          ];

        for (NSArray *testCase in braintreeTestCardNumbers) {
            NSString *testNumber = testCase[0];
            NSString *cardBrand = testCase[1];
            BTUICardType *cardType = [BTUICardType cardTypeForBrand:cardBrand];
            it([NSString stringWithFormat:@"should recognize %@ as a valid %@", testNumber, cardBrand], ^{
                expect([cardType validNumber:testNumber]).to.beTruthy();
            });
        }

        context(@"when card type is Union Pay", ^{
            it(@"returns true when number is not Luhn valid", ^{
                BTUICardType *cardType = [BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_UNION_PAY)];
                expect([cardType validNumber:@"6221234567890123451"]).to.beTruthy();
            });
        });
    });

    describe(@"validAndNecessarilyCompleteNumber", ^{

        it(@"should return NO for short Maestro", ^{
            BTUICardType *cardType = [BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_MAESTRO)];
            expect([cardType validAndNecessarilyCompleteNumber:@"630400000000"]).to.beFalsy();
            expect([cardType validAndNecessarilyCompleteNumber:@"6304000000000000"]).to.beFalsy();
        });

        it(@"should return YES for full-length Maestro", ^{
            BTUICardType *cardType = [BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_MAESTRO)];
            expect([cardType validAndNecessarilyCompleteNumber:@"6304000000000000000"]).to.beTruthy();
        });

    });

    describe(@"card number formatting", ^{

        it(@"should format a non-number as an empty string", ^{
            expect([[[BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_VISA)] formatNumber:@"notanumber"] string]).to.equal(@"");
        });

        it(@"should return a too-long number without formatting", ^{
            expect([[[BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_VISA)] formatNumber:@"00000000000000000"] string]).to.equal(@"00000000000000000");
        });

        it(@"should format a valid, formatted number as a Visa", ^{
            expect([[BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_VISA)] formatNumber:@"0000 0000 0000 0000"]).to.haveKerning(@[@3, @7, @11]);
        });

        it(@"should format a non-formatted number as a Visa", ^{
            expect([[BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_VISA)] formatNumber:@"0000000000000000"]).to.haveKerning(@[@3, @7, @11]);
        });

        it(@"should format an incomplete number as a Visa", ^{
            expect([[[BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_VISA)] formatNumber:@"0"] string]).to.equal(@"0");
        });

        it(@"should format as a MasterCard", ^{
            expect([[BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_MASTER_CARD)] formatNumber:@"0000000000000000"]).to.haveKerning(@[@3, @7, @11]);
        });

        it(@"should format as an American Express", ^{
            expect([[BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_AMERICAN_EXPRESS)] formatNumber:@"000000000000000"]).to.haveKerning(@[@3, @9]);
        });

        it(@"should format as an incomplete American Express", ^{
            expect([[BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_AMERICAN_EXPRESS)] formatNumber:@"00000"]).to.haveKerning(@[@3]);
        });

        it(@"should format as a Discover", ^{
            expect([[BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_DISCOVER)] formatNumber:@"1234123412341234"]).to.haveKerning(@[@3, @7, @11]);
        });

        it(@"should format as a JCB", ^{
            expect([[BTUICardType cardTypeForBrand:BTUILocalizedString(CARD_TYPE_JCB)] formatNumber:@"1234123412341234"]).to.haveKerning(@[@3, @7, @11]);
        });
    });
});

SpecEnd
