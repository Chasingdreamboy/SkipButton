//
//  SkipButton.h
//  AnchorPoint
//
//  Created by 王晓东 on 16/6/2.
//  Copyright © 2016年 Ericdong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^Finished) (void);
@interface SkipButton : UIButton
/**
 *  触发点击事件是否回调finished
 */
@property (assign, nonatomic) BOOL sameActionWithClick;

-(instancetype)initWithFrame:(CGRect)frame circleColor:(UIColor *)tintColor lineWidth:(CGFloat)lineWidth timeCount:(CGFloat)timeCount finished:(Finished)finished;
- (void)startAnimation;
@end
