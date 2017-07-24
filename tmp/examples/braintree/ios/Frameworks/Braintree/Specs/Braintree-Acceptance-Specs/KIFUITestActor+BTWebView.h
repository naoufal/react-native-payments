#import "KIFUITestActor.h"

@interface KIFUITestActor (BTWebView)

- (void) waitForUIWebviewXPathElement:(NSString*)xpath;
- (void) tapUIWebviewXPathElement:(NSString*)xpath;

@end
