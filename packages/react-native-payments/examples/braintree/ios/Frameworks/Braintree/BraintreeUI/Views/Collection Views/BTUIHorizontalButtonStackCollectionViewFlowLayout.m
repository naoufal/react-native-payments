#import "BTUIHorizontalButtonStackCollectionViewFlowLayout.h"
#import "BTUIHorizontalButtonStackSeparatorLineView.h"


NSString *BTHorizontalButtonStackCollectionViewFlowLayoutLineSeparatorDecoratorViewKind = @"BTHorizontalButtonStackCollectionViewFlowLayoutLineSeparatorDecoratorViewKind";

@interface BTUIHorizontalButtonStackCollectionViewFlowLayout ()
@property (nonatomic, strong) NSMutableArray *cachedLayoutAttributes;
@end

@implementation BTUIHorizontalButtonStackCollectionViewFlowLayout

- (id)init {
    self = [super init];
    if (self) {
        [self registerClass:[BTUIHorizontalButtonStackSeparatorLineView class] forDecorationViewOfKind:BTHorizontalButtonStackCollectionViewFlowLayoutLineSeparatorDecoratorViewKind];
    }
    return self;
}

- (void)prepareLayout {
    NSAssert(self.collectionView.numberOfSections == 1, @"Must have 1 section");

    [self calculateAndCacheLayoutAttributes];
}

- (CGSize)collectionViewContentSize {
    /// The collection view should never scroll
    return self.collectionView.frame.size;
}

- (NSArray *)layoutAttributesForElementsInRect:(__unused CGRect)rect {
    return [self.cachedLayoutAttributes copy];
}

#pragma mark - Helpers

- (void)calculateAndCacheLayoutAttributes {
    self.cachedLayoutAttributes = [NSMutableArray array];

    NSInteger numberOfButtons = [self.collectionView numberOfItemsInSection:0];
    CGFloat totalWidth = CGRectGetWidth(self.collectionView.frame);
    CGFloat totalHeight = CGRectGetHeight(self.collectionView.frame);
    CGSize buttonSize = CGSizeMake(totalWidth / numberOfButtons, totalHeight);

    for (NSInteger i = 0; i < numberOfButtons; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *cellLayoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        CGRect cellFrame = CGRectMake(buttonSize.width * i, 0, buttonSize.width, buttonSize.height);
        cellLayoutAttributes.frame = cellFrame;
        [self.cachedLayoutAttributes addObject:cellLayoutAttributes];
    }

    if (numberOfButtons > 1) {
        NSArray *layoutAttributesWithoutLastElement = [self.cachedLayoutAttributes subarrayWithRange:NSMakeRange(0, [self.cachedLayoutAttributes count] > 0 ? [self.cachedLayoutAttributes count] - 1 : 0)];
        for (UICollectionViewLayoutAttributes *attributes in layoutAttributesWithoutLastElement) {
            UICollectionViewLayoutAttributes *separatorAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:BTHorizontalButtonStackCollectionViewFlowLayoutLineSeparatorDecoratorViewKind
                                                                                                                                withIndexPath:attributes.indexPath];
            separatorAttributes.frame = CGRectMake(attributes.frame.origin.x + attributes.frame.size.width, attributes.frame.origin.y, 1/2.0f, attributes.frame.size.height);
            [self.cachedLayoutAttributes addObject:separatorAttributes];
        }
    }
}

@end
