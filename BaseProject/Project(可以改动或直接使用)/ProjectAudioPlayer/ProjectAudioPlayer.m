//
//  ProjectAudioPlayer.m
//  GuoRanHao_Merchant
//
//  Created by 意一yiyi on 2017/12/28.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "ProjectAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface ProjectAudioPlayer ()

@property (strong, nonatomic) AVAudioPlayer *player;

@end

@implementation ProjectAudioPlayer

static ProjectAudioPlayer *audioPlayer = nil;
+ (instancetype)sharedAudioPlayer {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        audioPlayer = [[ProjectAudioPlayer alloc] init];
    });
    
    return audioPlayer;
}

- (instancetype)init {
    
    @synchronized(audioPlayer) {
        
        self = [super init];
        if (self != nil) {
            
            // 一些属性的设置
            NSString *filePath = [[NSBundle mainBundle]pathForResource:@"notification" ofType:@"wav"];
            NSURL *url = [[NSURL alloc] initFileURLWithPath:filePath];
            AVAudioSession *session = [AVAudioSession sharedInstance];
            [session setCategory:AVAudioSessionCategoryPlayback error:nil];
            [session setActive:YES error:nil];  
            
            self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        }
        
        return self;
    }
}

- (void)playWithVolume:(NSInteger)volume {
    
    self.player.volume = volume;
    [self.player play];
}

@end
