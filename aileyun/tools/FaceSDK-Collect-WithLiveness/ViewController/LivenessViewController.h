//
//  LivenessViewController.h
//  IDLFaceSDKDemoOC
//
//  Created by 阿凡树 on 2017/5/23.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "FaceBaseViewController.h"

@protocol LivenessDelegate <NSObject>

-(void)imageString:(NSString *)string;

@end

@interface LivenessViewController : FaceBaseViewController

@property(nonatomic,assign)id<LivenessDelegate> delegate;

- (void)livenesswithList:(NSArray *)livenessArray order:(BOOL)order numberOfLiveness:(NSInteger)numberOfLiveness;

@end
