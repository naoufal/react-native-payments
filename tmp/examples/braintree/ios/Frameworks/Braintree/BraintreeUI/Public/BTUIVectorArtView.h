#import <UIKit/UIKit.h>

/*!
 @class BTUIVectorArtView
 @brief Subclassed to easily draw vector art into a scaled UIView.
 @discussion Useful for using generated UIBezierPath code from
 [PaintCode](http://www.paintcodeapp.com/) verbatim.
*/
@interface BTUIVectorArtView : UIView

/*!
 @brief Subclass and implement this method to draw within a context pre-scaled to the view's size.
*/
- (void)drawArt;

/*!
 @brief This property informs the BTVectorArtView drawRect method of the dimensions of the artwork.
*/
@property (nonatomic, assign) CGSize artDimensions;

- (UIImage *)imageOfSize:(CGSize)size;

@end
