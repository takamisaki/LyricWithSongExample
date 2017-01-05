#import <UIKit/UIKit.h>

@interface lrcUILabel : UILabel

@property (nonatomic, assign) NSInteger currentTime;     //获取传递来的歌曲当前时间

-(void)inputLrc:(NSString*)name andType:(NSString*)type; //获取传递来的歌词文件
-(void)initializeLrc;                                    //初始化歌词配置, 为播放做好准备

@end
