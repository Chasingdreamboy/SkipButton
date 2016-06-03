//
//  SkipButton.m
//  AnchorPoint
//
//  Created by 王晓东 on 16/6/2.
//  Copyright © 2016年 Ericdong. All rights reserved.
//

#import "SkipButton.h"
#import <objc/runtime.h>
const char blockKey;
@interface SkipButton ()
@property (strong, nonatomic) UIColor *circleColor;
@property (assign, nonatomic) CGFloat lineWidth;
@property (assign, nonatomic) CGFloat timeCount;
@property  (strong, nonatomic) CAShapeLayer *trackLayer;
@property (strong, nonatomic) CAShapeLayer *shapLayer;
@property (strong, nonatomic) CABasicAnimation *progressAni;
@end

@implementation SkipButton
-(instancetype)initWithFrame:(CGRect)frame circleColor:(UIColor *)tintColor lineWidth:(CGFloat)lineWidth timeCount:(CGFloat)timeCount finished:(Finished)finished {
    CGFloat width = MIN(frame.size.width, frame.size.height);
    frame = CGRectMake(frame.origin.x, frame.origin.y, width, width);
    self = [super initWithFrame:frame];
    if (self) {
        objc_setAssociatedObject(self, &blockKey, finished, OBJC_ASSOCIATION_COPY);
        self.layer.cornerRadius = frame.size.width / 2.0;
//        self.layer.masksToBounds = YES;
        _circleColor = tintColor;
        _lineWidth = lineWidth;
        _timeCount = timeCount;
    }
    return self;
}
- (CAShapeLayer *)shapLayer  {
    if (!_shapLayer) {
        _shapLayer = [CAShapeLayer layer];
        _shapLayer.frame = self.bounds;
        _shapLayer.lineWidth = _lineWidth;
//        _shapLayer.lineCap = kCALineCapRound;
        _shapLayer.strokeColor = _circleColor.CGColor;
        _shapLayer.fillColor = [UIColor clearColor].CGColor;
        _shapLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0) radius:(self.bounds.size.width + _shapLayer.lineWidth) / 2.0 startAngle:-M_PI_2 endAngle:- (M_PI * 2 + M_PI_2)  clockwise:NO].CGPath;
        [self.layer addSublayer:_shapLayer];
    }
    return _shapLayer;
}


- (void)startAnimation {
    if (_sameActionWithClick) {
        [self addTarget:self action:@selector(actionClick) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.shapLayer addAnimation:self.progressAni forKey:@"progressAnimation"];
}
- (CABasicAnimation *)progressAni {
    if (!_progressAni) {
        _progressAni = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        [_progressAni setValue:@"progressAnimation" forKey:@"id"];
        _progressAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        _progressAni.fromValue = @(1.0);
        _progressAni.toValue = @(0.0);
        _progressAni.duration = _timeCount ? : 2;
        _progressAni.removedOnCompletion = NO;
        _progressAni.fillMode = kCAFillModeForwards;
        _progressAni.delegate = self;
    }
    return _progressAni;
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString *aniID = [anim valueForKey:@"id"];
    if ([aniID isEqualToString:@"progressAnimation"]) {
        [_shapLayer removeAnimationForKey:@"progressAnimation"];
        [_shapLayer removeFromSuperlayer];
        _shapLayer = nil;
        Finished finished = objc_getAssociatedObject(self, &blockKey);
        if (finished) {
            finished();
        }
    }
}
- (void)actionClick {
    if (_shapLayer) {
         [_shapLayer removeAnimationForKey:@"progressAnimation"];
        [_shapLayer removeFromSuperlayer];
        _shapLayer = nil;
    }
   
    Finished finished = objc_getAssociatedObject(self, &blockKey);
    if (finished) {
        finished();
    }
}
@end
