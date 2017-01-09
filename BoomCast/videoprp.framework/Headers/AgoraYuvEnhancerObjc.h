// TODO: remove this line
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AgoraEnhancerType) {
    AgoraEnhancerTypeNone = -1,
    AgoraEnhancerTypeGPU = 0,
    AgoraEnhancerTypeCPUNFLS = 1,
    AgoraEnhancerTypeCPUBG = 2
};

@interface AgoraYuvEnhancerObjc : NSObject
@property (assign, atomic) CGFloat lighteningFactor;
@property (assign, atomic) CGFloat smoothness;
@property (assign, atomic) AgoraEnhancerType type;

- (void)turnOn;
- (void)turnOff;
@end
