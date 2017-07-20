#import "BTCardNonce_Internal.h"

@implementation BTCardNonce

- (instancetype)initWithNonce:(NSString *)nonce
                  description:(NSString *)description
                  cardNetwork:(BTCardNetwork)cardNetwork
                      lastTwo:(NSString *)lastTwo
                    isDefault:(BOOL)isDefault
{
    self = [super initWithNonce:nonce localizedDescription:description type:[BTCardNonce stringFromCardNetwork:cardNetwork] isDefault:isDefault];
    if (self) {
        _cardNetwork = cardNetwork;
        _lastTwo = lastTwo;
    }
    return self;
}

+ (NSString *)stringFromCardNetwork:(BTCardNetwork)cardNetwork {
    switch (cardNetwork) {
        case BTCardNetworkAMEX:
            return @"AMEX";
        case BTCardNetworkDinersClub:
            return @"DinersClub";
        case BTCardNetworkDiscover:
            return @"Discover";
        case BTCardNetworkMasterCard:
            return @"MasterCard";
        case BTCardNetworkVisa:
            return @"Visa";
        case BTCardNetworkJCB:
            return @"JCB";
        case BTCardNetworkLaser:
            return @"Laser";
        case BTCardNetworkMaestro:
            return @"Maestro";
        case BTCardNetworkUnionPay:
            return @"UnionPay";
        case BTCardNetworkSolo:
            return @"Solo";
        case BTCardNetworkSwitch:
            return @"Switch";
        case BTCardNetworkUKMaestro:
            return @"UKMaestro";
        case BTCardNetworkUnknown:
        default:
            return @"Unknown";
    }
}

+ (instancetype)cardNonceWithJSON:(BTJSON *)cardJSON {
    // Normalize the card network string in cardJSON to be lowercase so that our enum mapping is case insensitive
    BTJSON *cardType = [[BTJSON alloc] initWithValue:[cardJSON[@"details"][@"cardType"] asString].lowercaseString];
    return [[[self class] alloc] initWithNonce:[cardJSON[@"nonce"] asString]
                                   description:[cardJSON[@"description"] asString]
                                   cardNetwork:[cardType asEnum:@{
                                                                  @"american express": @(BTCardNetworkAMEX),
                                                                  @"diners club": @(BTCardNetworkDinersClub),
                                                                  @"unionpay": @(BTCardNetworkUnionPay),
                                                                  @"discover": @(BTCardNetworkDiscover),
                                                                  @"maestro": @(BTCardNetworkMaestro),
                                                                  @"mastercard": @(BTCardNetworkMasterCard),
                                                                  @"jcb": @(BTCardNetworkJCB),
                                                                  @"laser": @(BTCardNetworkLaser),
                                                                  @"solo": @(BTCardNetworkSolo),
                                                                  @"switch": @(BTCardNetworkSwitch),
                                                                  @"uk maestro": @(BTCardNetworkUKMaestro),
                                                                  @"visa": @(BTCardNetworkVisa),}
                                                      orDefault:BTCardNetworkUnknown]
                                       lastTwo:[cardJSON[@"details"][@"lastTwo"] asString]
                                     isDefault:[cardJSON[@"default"] isTrue]];
}

@end
