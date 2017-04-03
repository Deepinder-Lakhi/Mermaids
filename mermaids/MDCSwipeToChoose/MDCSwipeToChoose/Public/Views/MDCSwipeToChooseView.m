//
// MDCSwipeToChooseView.m
//
// Copyright (c) 2014 to present, Brian Gesiak @modocache
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "MDCSwipeToChooseView.h"
#import "MDCSwipeToChoose.h"
#import "MDCGeometry.h"
#import "UIView+MDCBorderedLabel.h"
#import "UIColor+MDCRGB8Bit.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat const MDCSwipeToChooseViewHorizontalPadding = 10.f;
static CGFloat const MDCSwipeToChooseViewTopPadding = 20.f;
static CGFloat const MDCSwipeToChooseViewLabelWidth = 65.f;

@interface MDCSwipeToChooseView ()
@property (nonatomic, strong) MDCSwipeToChooseViewOptions *options;
@end

@implementation MDCSwipeToChooseView

#pragma mark - Object Lifecycle

- (instancetype)initWithFrame:(CGRect)frame options:(MDCSwipeToChooseViewOptions *)options {
    self = [super initWithFrame:frame];
    if (self) {
        _options = options ? options : [MDCSwipeToChooseViewOptions new];
        [self setupView];
        
        [self constructScrollView];
//        [self constructLikedView];
//        [self constructNopeImageView];
        [self setupSwipeToChoose];
    }
    return self;
}

#pragma mark - Internal Methods

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    //David edited 2/6/17
    self.layer.cornerRadius = 10.f;
    self.layer.masksToBounds = YES;
//    self.layer.borderWidth = 2.f;
//    self.layer.borderColor = [UIColor colorWith8BitRed:220.f
//                                                 green:220.f
//                                                  blue:220.f
//                                                 alpha:1.f].CGColor;
}

- (void)constructScrollView {
    CGRect frame = self.bounds;
    frame.size.height -= 60;
    _scrollView = [[UIScrollView alloc] initWithFrame:frame];
    _scrollView.clipsToBounds = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = false;
    _scrollView.showsVerticalScrollIndicator = false;
    _scrollView.contentSize = CGSizeMake(frame.size.width, frame.size.height * 4);
    [self addSubview:_scrollView];
}

- (void)constructscrollViewFor:(int)count {
    CGRect frame = self.bounds;
    frame.size.height -= 60;
    _scrollView.contentSize = CGSizeMake(frame.size.width, frame.size.height * count);
}


- (void)constructImageViewWith:(UIImage *)image onPosition:(NSUInteger)position {
    NSLog(@"Downloaded Image:%@",image);
    CGRect frame = self.bounds;
    frame.size.height -= 60;
    frame.origin.y = position * frame.size.height;
    _imageView = [[UIImageView alloc] initWithFrame:frame];
    NSString* imageStr = @"https://api.mermaidsdating.com/images/95/DESKTOP-HDWALLPAPERS(5)_1485440520_UP.jpg";
    Global.sharedInstance.setImageFromUrl(str: imageStr, completion:  {
        (image: UIImage) in
        print("Downloaded Image:\(image)")
        DispatchQueue.main.sync {
//            self.constructImageView(with: image, onPosition: 0)
            _imageView.image = image;
        }
    })
//    _imageView.image = image;
    _imageView.clipsToBounds = YES;
    [_scrollView insertSubview:_imageView atIndex:0];
}

- (void)constructLikedView {
    CGRect frame = CGRectMake(MDCSwipeToChooseViewHorizontalPadding,
                              MDCSwipeToChooseViewTopPadding,
                              CGRectGetMidX(_imageView.bounds),
                              MDCSwipeToChooseViewLabelWidth);
    self.likedView = [[UIView alloc] initWithFrame:frame];
    [self.likedView constructBorderedLabelWithText:self.options.likedText
                                             color:self.options.likedColor
                                             angle:self.options.likedRotationAngle];
    self.likedView.alpha = 0.f;
    [self addSubview:self.likedView];
}

- (void)constructNopeImageView {
    CGFloat width = CGRectGetMidX(self.imageView.bounds);
    CGFloat xOrigin = CGRectGetMaxX(_imageView.bounds) - width - MDCSwipeToChooseViewHorizontalPadding;
    self.nopeView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin,
                                                                  MDCSwipeToChooseViewTopPadding,
                                                                  width,
                                                                  MDCSwipeToChooseViewLabelWidth)];
    [self.nopeView constructBorderedLabelWithText:self.options.nopeText
                                            color:self.options.nopeColor
                                            angle:self.options.nopeRotationAngle];
    self.nopeView.alpha = 0.f;
    [self addSubview:self.nopeView];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // Test the offset and calculate the current page after scrolling ends
//    let pageHeight:CGFloat = scrollView.frame.height
    CGFloat pageHeight = _scrollView.frame.size.height;
    CGFloat currentPage = floor((scrollView.contentOffset.y-pageHeight/2)/pageHeight)+1;
    self.pageControl.currentPage = (int)ceilf(currentPage);
    
    NSLog(@"%f",currentPage);
    
//    let currentPage:CGFloat = floor((scrollView.contentOffset.y-pageHeight/2)/pageHeight)+1
//    // Change the indicator
//    self.pageControl.currentPage = Int(currentPage);
//    self.pageControl.updateDots()
}

- (void)setupSwipeToChoose {
    MDCSwipeOptions *options = [MDCSwipeOptions new];
    options.delegate = self.options.delegate;
    options.threshold = self.options.threshold;

    __block UIView *likedImageView = self.likedView;
    __block UIView *nopeImageView = self.nopeView;
    __weak MDCSwipeToChooseView *weakself = self;
    options.onPan = ^(MDCPanState *state) {
        if (state.direction == MDCSwipeDirectionNone) {
            likedImageView.alpha = 0.f;
            nopeImageView.alpha = 0.f;
        } else if (state.direction == MDCSwipeDirectionLeft) {
            likedImageView.alpha = 0.f;
            nopeImageView.alpha = state.thresholdRatio;
        } else if (state.direction == MDCSwipeDirectionRight) {
            likedImageView.alpha = state.thresholdRatio;
            nopeImageView.alpha = 0.f;
        }

        if (weakself.options.onPan) {
            weakself.options.onPan(state);
        }
    };

    [self mdc_swipeToChooseSetup:options];
}

@end
