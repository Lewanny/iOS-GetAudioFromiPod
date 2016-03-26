//
//  ViewController.m
//  BlueToothText
//
//  Created by 李宏远 on 16/3/21.
//  Copyright © 2016年 李宏远. All rights reserved.
//

#import "ViewController.h"
#import "musicTableViewCell.h"
#import "MBProgressHUD.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#import "MPMediaItem+ExportSession.h"

@interface ViewController ()<AVAudioPlayerDelegate, UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)AVAudioPlayer *player;

// 存放导入的音频
@property(nonatomic, strong)NSMutableArray *arrMusics;


@property(nonatomic, strong)UIButton *btnSearch;
@property(nonatomic, strong)UILabel *labelMusicList;

@property(nonatomic, strong)MBProgressHUD *loading;

@end


@implementation ViewController


- (void)dealloc {
    
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.861 green:0.942 blue:0.960 alpha:1.000];
    
    // 判断APP是否已经导入本地音乐
    self.arrMusics = [[NSUserDefaults standardUserDefaults] objectForKey:@"localMusicsList"];
    if (self.arrMusics.count == 0) {
        self.arrMusics = [NSMutableArray arrayWithCapacity:0];
        [self createSearchBtn];
    } else {
        
        [self createLabelMusicList];
        [self createTableView];
    }
    
    
    // 导入完成的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOutPutComplete:) name:@"outPutComplete" object:nil];
    
    // 完成每一个音频导入的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOnePutComplete:) name:@"outOneComplete" object:nil];
}

- (void)handleOnePutComplete:(NSNotification *)noti {
    
    // 刷新HUD
    self.loading.labelText = [NSString stringWithFormat:@"导入“%@”", noti.object];
    
}

- (void)handleOutPutComplete:(NSNotification *)noti {
    
    // 读取完成后刷新界面
        self.loading.labelText = [NSString stringWithFormat:@"导入“%@”", noti.object];
    
        dispatch_async(dispatch_get_main_queue(), ^{
    
            // 延时执行
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.loading hide:YES];
                self.btnSearch.hidden = YES;
                [self createLabelMusicList];
                self.tableView.hidden = NO;
                
            });
            
    
        });
    
}

#pragma mark - 创建控件
// 创建查找按钮
- (void)createSearchBtn {
    
    self.btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnSearch.frame = CGRectMake(self.view.bounds.size.width / 2 - 70, 60, 140, 40);
    self.btnSearch.backgroundColor = [UIColor blackColor];
    [self.btnSearch setTitle:@"扫描本地音乐" forState:UIControlStateNormal];
    [self.btnSearch addTarget:self action:@selector(QureyAllMusic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnSearch];
    
}

// 创建播放列表label
- (void)createLabelMusicList {
    
    self.labelMusicList = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - 80, 60, 160, 40)];
    self.labelMusicList.text = @"本地播放列表";
    self.labelMusicList.backgroundColor = [UIColor whiteColor];
    self.labelMusicList.font = [UIFont systemFontOfSize:19];
    self.labelMusicList.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.labelMusicList];
    
}

// 创建播放列表的tableView
- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, self.view.bounds.size.width, 300) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[musicTableViewCell class] forCellReuseIdentifier:@"reuse"];
    
}

#pragma mark - TableView的协议方法
// tableView协议方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    musicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    cell.labelMusic.text = [self.arrMusics objectAtIndex:indexPath.row];
    return cell;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arrMusics.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}

#pragma mark - cell点击播放音乐
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //创建音乐文件路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    NSString *musicFilePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", [self.arrMusics objectAtIndex:indexPath.row] ,@".m4a"]];
    

    
    //判断文件是否存在, 若存在, 播放音频
    if ([[NSFileManager defaultManager] fileExistsAtPath:musicFilePath])
    {
        NSURL *musicURL = [NSURL fileURLWithPath:musicFilePath];
        NSError *myError = nil;
        //创建播放器
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:&myError];
        if (self.player == nil)
        {
            NSLog(@"error === %@",[myError description]);
        }
        [self.player setVolume:1];
        self.player.numberOfLoops = -1;
        [self.player play];
        
        // [NSString stringWithFormat:@"%@", self]
        NSLog(@"文件存在");
        
    } else {
        
        NSLog(@"文件不存在");
    }
    
    //设置锁屏仍能继续播放
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
}


#pragma mark - 扫描本机音乐方法
/*
 * 注意:扫描本机音乐时，会扫描所有iPod库中的音乐，其中包含导入的音乐和通过Apple Music下载的音乐。
 * 需通过MPMediaItemPropertyAssetURL判断其URL是否为空来区分，导入的音乐可以获取URL，后者则为null.
 * 添加过滤通过Apple Music下载的音频。
 *
 */
- (void)QureyAllMusic {
 
    self.loading = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.loading.dimBackground = YES;
    self.loading.animationType = 2;
    self.loading.labelText = @"正在读取音乐文件";
    
    // 获取音乐库文件
    MPMediaQuery *allAudios = [[MPMediaQuery alloc] init];
    NSLog(@"正在读取...");
    NSArray *arrayAudios = [allAudios items];
    
    NSLog(@"count = %lu", (unsigned long)arrayAudios.count);
    for (MPMediaItem *song in arrayAudios)
    {
        // 名字 歌手 专辑 评论 url等...
        NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
        NSURL *songURL = [song valueForProperty:MPMediaItemPropertyAssetURL];
        NSString *songURLString = [songURL absoluteString];
        
        // 判断是导入的音乐还是通过Apple Music下载的音乐,
        // 通过Apple Music下载的音乐MPMediaItemPropertyAssetURL为空
        if (songURLString != nil) {
            
            [self.arrMusics addObject:songTitle];
        }
        
        NSLog(@"url = %@", songURLString);
    }
    
    
    // 判断是否有导入的音乐
    if (self.arrMusics.count == 0) {
        [self.loading hide:YES afterDelay:1];
        // 加入提示框
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"未扫描到音乐" message:@"快去导入音乐吧" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action];
        
        // 延时执行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self presentViewController:alert animated:YES completion:^{
                
            }];
            
        });
        
    } else {
        
        [[NSUserDefaults standardUserDefaults] setObject:self.arrMusics forKey:@"localMusicsList"];
        
        // 执行导出每一个音频的操作
        for (MPMediaItem *song in arrayAudios)
        {
            [song convertToMp3:song withCount:self.arrMusics.count];
            
        }
        [self createTableView];
        self.tableView.hidden = YES;
        
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
