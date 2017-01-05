#import "lrcUILabel.h"

@interface lrcUILabel ()

@property (nonatomic, copy  ) NSString       *lrcName;          //歌词文件名字
@property (nonatomic, copy  ) NSString       *lrcType;          //歌词文件格式
@property (nonatomic, strong) NSMutableArray *lrcArray;         //每句歌词形成的数组
@property (nonatomic, strong) NSMutableArray *lrcShowTimeArray; //每句歌词出现时间形成的数组

@end

@implementation lrcUILabel

//获取传递来的 歌词文件名字 和 歌词文件格式
-(void)inputLrc:(NSString*)name andType:(NSString*)type{
    self.lrcName = name;
    self.lrcType = type;
}

//初始化歌词各个数组
-(void)initializeLrc{
    
    //读取这个歌词文件名字和格式获取文件 path
    NSString *path = [[NSBundle mainBundle] pathForResource:self.lrcName ofType:self.lrcType];
    
    /*
     如果读取到了文件
     1. 获取文件内容, 根据回车符分割, 形成原始歌词数组. 初始化 歌词数组 和 播放时间数组
     2. 遍历原始数组, 截取出分钟和秒, 转换成数值, 加入播放时间数组
     3. 同时截取出每句歌词的文字部分, 加入歌词数组
    */
    
    if ([path length]) {
        
        NSString *wholeLrc         = [NSString stringWithContentsOfFile:path
                                                               encoding:NSUTF8StringEncoding
                                                                  error:nil];

        NSArray* tempWholeLrcArray = [wholeLrc componentsSeparatedByString:@"\n"];

        self.lrcArray              = [NSMutableArray new];
        self.lrcShowTimeArray      = [NSMutableArray new];
        
        
        for (NSString *tempLine in tempWholeLrcArray)
        {
            if ([tempLine length])
            {
                NSString *minute   = [tempLine substringWithRange: NSMakeRange(1, 2)];
                NSString *second   = [tempLine substringWithRange: NSMakeRange(4, 2)];

                NSNumber *showTime = [NSNumber numberWithInteger:
                                      [minute integerValue]*60 + [second integerValue]];
                
                NSString *lrc      = [tempLine substringFromIndex:10];
                
                [self.lrcArray         addObject:lrc     ];
                [self.lrcShowTimeArray addObject:showTime];
            }
        }
    }
}


//重写 currentTime 的 setter, getter
@synthesize currentTime = _currentTime;

-(void)setCurrentTime:(NSInteger)currentTime
{
    _currentTime = currentTime;
    [self showLrc]; //调用显示歌词方法,开始根据传入的时间显示歌词
}

-(NSInteger)currentTime
{
    return _currentTime;
}


//显示歌词方法: 遍历歌词数组, 获取和当前时间对应的成员的 index, 显示歌词数组对应 index 的成员
-(void)showLrc{
    
    for (NSNumber *lrcShowTime in self.lrcShowTimeArray)
    {
        NSInteger lrcShowTimeInteger = [lrcShowTime integerValue];
        
        if (self.currentTime == lrcShowTimeInteger)
        {
            NSInteger index = [_lrcShowTimeArray indexOfObject:lrcShowTime];
            self.text       = self.lrcArray[index];
            return;
        }
    }
}

@end
