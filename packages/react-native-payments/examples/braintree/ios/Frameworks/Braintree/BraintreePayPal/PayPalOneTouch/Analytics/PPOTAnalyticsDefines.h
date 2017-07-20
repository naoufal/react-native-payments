//
//  PPOTAnalyticsDefines.h

#ifndef TRACKING_DEFINES_H
#define TRACKING_DEFINES_H

// "Page" is analytics-talk for "Screen"
// "Link" is analytics-talk for "Button, underlined text, or other tappable affordance"

// Versioning
#define kAnalyticsVersion                   @"iOS:MODE:"

// AppSwitch
#define kAnalyticsAppSwitchWalletPresent    @"mobile:otc:checkwallet:present:"  // followed by protocol
#define kAnalyticsAppSwitchWalletAbsent     @"mobile:otc:checkwallet:absent:"   // followed by protocol

#define kAnalyticsAppSwitchPreflightBrowser @"mobile:otc:preflight:browser:"    // followed by protocol
#define kAnalyticsAppSwitchPreflightWallet  @"mobile:otc:preflight:wallet:"     // followed by protocol
#define kAnalyticsAppSwitchPreflightNone    @"mobile:otc:preflight:none:"       // followed by protocol

#define kAnalyticsAppSwitchToBrowser        @"mobile:otc:switchaway:browser:"   // followed by protocol
#define kAnalyticsAppSwitchToWallet         @"mobile:otc:switchaway:wallet:"    // followed by protocol

#define kAnalyticsAppSwitchCancel           @"mobile:otc:switchback:cancel:"
#define kAnalyticsAppSwitchReturn           @"mobile:otc:switchback:return:"

#endif /* TRACKING_DEFINES_H */

