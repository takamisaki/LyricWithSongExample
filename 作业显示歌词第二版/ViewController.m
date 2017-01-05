#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "lrcUILabel.h"

@interface ViewController ()

@property (nonatomic, weak  ) IBOutlet lrcUILabel *lrcLabel;   //显示歌词的 label
@property (nonatomic, weak  ) IBOutlet lrcUILabel *currentTimeLabel; //显示当前时间的 label
@property (nonatomic, strong) AVAudioPlayer       *songPlayer; //播放器
@property (nonatomic, strong) NSURL               *songURL;    //歌曲 url
@property (nonatomic, strong) NSTimer             *timer;      //定时器

@end


@implementation ViewController

//播放按钮点击 action: 开始播放, 添加定时器
- (IBAction)playClicked:(UIButton *)sender
{
    [self.songPlayer play];
    [self addTimer];
}


//暂停按钮点击 action: 暂停播放, 取消定时器
- (IBAction)pauseClicked:(UIButton *)sender
{
    [self.songPlayer pause];
    [self.timer invalidate];
}


//停止按钮点击 action: 停止播放, 进度归零, 取消定时器, 歌词 label 显示0秒时的歌词, 时间 label 显示0
- (IBAction)stopClicked:(UIButton *)sender
{
    [self.songPlayer stop];
    [self.songPlayer setCurrentTime:0];
    [self.timer      invalidate];
    
    self.lrcLabel.currentTime  = 0;
    self.currentTimeLabel.text = 0;
}


//视图载入后: 导入音乐, 添加播放器, 导入歌词, 初始化歌词
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self inputSong:@"陈粒 - 正趣果上果" andType:@"mp3"];
    [self addSongPlayer];
    
    [self.lrcLabel inputLrc:@"陈粒 - 正趣果上果" andType:@"lrc"];
    [self.lrcLabel initializeLrc];
}


//导入音乐方法设置: 获取 path,赋值给 url
-(void)inputSong:(NSString*)name andType:(NSString*)type
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"陈粒 - 正趣果上果" ofType:@"mp3"];
    self.songURL   = [NSURL fileURLWithPath:path];
}


//添加播放器方法设置: 建立播放器, 使用 url 属性
-(void)addSongPlayer
{
    self.songPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.songURL error:nil];
}

//添加定时器方法设置: 500毫秒频率重复执行 显示当前进度时间 和 传递时间给歌词 class, 添加定时器到 runloop
-(void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                  target:self
                                                selector:@selector(showAndTransferCurrentTime)
                                                userInfo:nil
                                                 repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}


//显示进度时间 和 传递时间给歌词 class 方法设置: 获取歌曲当前时间, 取 integerValue并传递给歌词 class
-(void)showAndTransferCurrentTime
{
    self.currentTimeLabel.text = [NSString stringWithFormat:@"%.f", self.songPlayer.currentTime];
    
    self.lrcLabel.currentTime  = [self.currentTimeLabel.text integerValue];
}

@end