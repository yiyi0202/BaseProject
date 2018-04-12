//
//  ProjectAudioPlayer.h
//  GuoRanHao_Merchant
//
//  Created by 意一yiyi on 2017/12/28.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectAudioPlayer : NSObject

+ (instancetype)sharedAudioPlayer;

/**
 *  播放音效
 */
- (void)playWithVolume:(NSInteger)volume;

@end
