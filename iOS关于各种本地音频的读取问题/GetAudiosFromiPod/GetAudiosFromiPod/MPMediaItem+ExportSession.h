//
//  MPMediaItem+ExportSession.h
//  GetAudiosFromiPod
//
//  Created by 李宏远 on 16/3/23.
//  Copyright © 2016年 李宏远. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

@interface MPMediaItem (ExportSession)

- (void)convertToMp3: (MPMediaItem *)song withCount:(NSInteger)count;

@end
