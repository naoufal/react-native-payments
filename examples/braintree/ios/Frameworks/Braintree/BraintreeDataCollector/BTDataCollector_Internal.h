#import "BTDataCollector.h"
#import "KDataCollector.h"

@interface BTDataCollector ()

/*!
 @brief The Kount SDK device collector, exposed internally for testing
*/
@property (nonatomic, strong, nonnull) KDataCollector *kount;

/*!
 @brief The `PPDataCollector` class, exposed internally for injecting test doubles for unit tests
*/
+ (void)setPayPalDataCollectorClass:(nonnull Class)payPalDataCollectorClass;

@end
