
#ifndef __ruby_cocos2dx_audioengine_auto__
#define __ruby_cocos2dx_audioengine_auto__
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_MAC || CC_TARGET_PLATFORM == CC_PLATFORM_WIN32
#ifndef __cocos2dx_audioengine_h__
#define __cocos2dx_audioengine_h__

#include "base/ccConfig.h"
extern "C" {
#include "mruby.h"
}
void register_all_cocos2dx_audioengine(mrb_state* mrb);

























#endif // __cocos2dx_audioengine_h__
#endif //#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_MAC || CC_TARGET_PLATFORM == CC_PLATFORM_WIN32
#endif