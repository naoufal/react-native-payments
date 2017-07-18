#import "KIFUITestActor+BTWebView.h"

@implementation KIFUITestActor (BTWebView)

- (UIWebView *)_getWebViewOnCurrentScreen:(NSArray *)views
{
    for (UIView *view in views) {
        if ([NSStringFromClass([view class]) isEqual:@"UIWebView"]) {
            return (UIWebView*) view;
        }
        UIWebView* found = [self _getWebViewOnCurrentScreen:view.subviews];
        if (found != nil)
            return found;
    }
    return nil;
}

- (UIWebView *)getWebViewOnCurrentScreen {
    return [self _getWebViewOnCurrentScreen:[[UIApplication sharedApplication] windows]];
}


// If the send in xpath doesn't find any element the return CGPoint will be -1,-1
- (CGPoint)webViewElementCoordinates:(NSString *)xpath {
    UIWebView *currentWebView = [self getWebViewOnCurrentScreen];
    if (currentWebView) {
        [currentWebView stringByEvaluatingJavaScriptFromString:@"var script = document.createElement('script');"
                             "script.type = 'text/javascript';"
                             "script.text = \"function findPos(obj) {var curtop = 0; if (obj.offsetParent) { do { curtop += obj.offsetTop; } while (obj = obj.offsetParent); return [curtop]; }}; function getElementsByXPath(xpath, contextNode) { try { if(contextNode === undefined) { var xpathResult = document.evaluate(xpath, document, null, XPathResult.ANY_TYPE, null); } else { var xpathResult = contextNode.evaluate(xpath, contextNode, null, XPathResult.ANY_TYPE, null); } var array = []; var element; element = xpathResult.iterateNext(); while(element) { array[array.length] = element; element = xpathResult.iterateNext(); } if (array.length >= 0) { var element = array[0]; window.scroll(0,findPos(element)); var rect = element.getBoundingClientRect(); var elementLeft,elementTop; var scrollTop = document.documentElement.scrollTop?document.documentElement.scrollTop:document.body.scrollTop; var scrollLeft = document.documentElement.scrollLeft? document.documentElement.scrollLeft:document.body.scrollLeft; elementTop = rect.top+scrollTop; elementLeft = rect.left+scrollLeft; return elementLeft + ',' + elementTop + ',' + document.documentElement.scrollTop + ',' + document.body.scrollTop; } else { return ''; } } catch(err) { return 'xpath not found';} };\";"
                             "document.getElementsByTagName('head')[0].appendChild(script);"];
        NSString *message = [currentWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@%@%@", @"getElementsByXPath('", xpath, @"');"]];
        // This sleep is to allow scrolling to the element happening
        [self waitForTimeInterval:0.1];
        if (![message isEqualToString:@""] &&  ![message isEqualToString:@"xpath not found"]) {
            NSArray *list = [message componentsSeparatedByString:@","];
            CGPoint domCoordinates = CGPointMake([list[0] floatValue], [list[1] floatValue]);
            CGPoint windowCoordinates = [currentWebView.scrollView convertPoint:domCoordinates
                                                                         toView:[[UIApplication sharedApplication] keyWindow]];

            return windowCoordinates;
        }
    }
    return CGPointMake(-1, -1);
}

- (void)waitForUIWebviewXPathElement:(NSString *)xpath  {

    [self runBlock:^KIFTestStepResult(NSError **error) {
        CGPoint point = [self webViewElementCoordinates:xpath];
        KIFTestWaitCondition(point.x != -1 && point.y != -1, error, @"Cannot find element with xpath \"%@\"", xpath);
        return KIFTestStepResultSuccess;
    } timeout:10.0];

}

- (void)tapUIWebviewXPathElement:(NSString *)xpath {
    [self runBlock:^KIFTestStepResult(NSError **error) {
        CGPoint point = [self webViewElementCoordinates:xpath];
        KIFTestWaitCondition(point.x != -1 && point.y != -1, error, @"Cannot find element with xpath \"%@\"", xpath);
        [self tapScreenAtPoint:point];
        return KIFTestStepResultSuccess;
    } timeout:10.0];
    
}

@end
