//
//  MPMediaItem+ExportSession.m
//  GetAudiosFromiPod
//
//  Created by 李宏远 on 16/3/23.
//  Copyright © 2016年 李宏远. All rights reserved.
//

#import "MPMediaItem+ExportSession.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

static NSInteger i = 0;

@implementation MPMediaItem (ExportSession)

/*
 * 
 *
 *
 */

- (void)convertToMp3:(MPMediaItem *)song withCount:(NSInteger)count{
    
    // 通过AVAssetExportSession导入沙盒目录
    
    NSURL *url = [song valueForProperty:MPMediaItemPropertyAssetURL];
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectoryPath = [dirs objectAtIndex:0];
    
    NSArray* ar = [AVAssetExportSession exportPresetsCompatibleWithAsset: songAsset];
    
    NSLog(@"%@", ar);
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc]
    
                                     initWithAsset: songAsset
    
                                     presetName:AVAssetExportPresetAppleM4A];
    
    NSLog(@"created exporter. supportedFileTypes: %@", exporter.supportedFileTypes);
    
    exporter.outputFileType = @"com.apple.m4a-audio";
    
    NSString *exportFile = [documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a", [song valueForProperty: MPMediaItemPropertyTitle]]];
    
    NSError *error1;
    
    if([fileManager fileExistsAtPath:exportFile]){
    
        [fileManager removeItemAtPath:exportFile error:&error1];
    
    }
    
    NSURL *urlPath= [NSURL fileURLWithPath:exportFile];
    
    exporter.outputURL=urlPath;
    
    NSLog(@"---------%@",urlPath);
    
 
    // 执行异步导出方法
    [exporter exportAsynchronouslyWithCompletionHandler:^
    
        {
        // 导出状态
             int exportStatus = exporter.status;
    
             switch (exportStatus) {
    
                 case AVAssetExportSessionStatusFailed: {
    
                     // log error to text view
                     NSError *exportError = exporter.error;
                     NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
    
                     break;
                 }
    
                 case AVAssetExportSessionStatusCompleted: {
    
                     NSLog (@"AVAssetExportSessionStatusCompleted");
    //                 NSLog(@"%f", exporter.progress);
                     i++;
                     if (i == count) {
                       
                         NSLog(@"导入第%ld首",(long)i);
                         NSLog(@"全部导入完毕");
                         NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"outPutComplete" object:songTitle];
                         
                     } else {
                         
                          NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"outOneComplete" object:songTitle];
                         
                         NSLog(@"导入第%ld首",(long)i);
                     }
    
                     break;
                 }
    
                 case AVAssetExportSessionStatusUnknown: {
                     NSLog (@"AVAssetExportSessionStatusUnknown");
                     break;
                 }
                 case AVAssetExportSessionStatusExporting: {
                     NSLog (@"AVAssetExportSessionStatusExporting");
                     break;
                 }
    
                 case AVAssetExportSessionStatusCancelled: {
                     NSLog (@"AVAssetExportSessionStatusCancelled");
                     break;
                 }
                     
                 case AVAssetExportSessionStatusWaiting: {
                     NSLog (@"AVAssetExportSessionStatusWaiting");
                     break;
                 }
                     
                 default:
                 { NSLog (@"didn't get export status");
                     break;
                 }
             }
             
             
         }];
}

@end
