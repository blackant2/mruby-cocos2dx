#ifndef __ruby_cocos2dx_experimental_video_auto__
#define  __ruby_cocos2dx_experimental_video_auto__
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#ifndef __cocos2dx_experimental_video_h__
#define __cocos2dx_experimental_video_h__

#include "base/ccConfig.h"
extern "C" {
#include "mruby.h"
}
void register_all_cocos2dx_experimental_video(mrb_state* mrb);

















#endif // __cocos2dx_experimental_video_h__
#endif //#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#endif