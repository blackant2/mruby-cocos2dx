//
//  RubyEngine.cpp
//  cocos2d_ruby_bindings
//
//  Created by tkyaji on 2015/01/22.
//
//

#include "RubyEngine.h"
#include "ruby_cocos2dx_auto.hpp"
#include "ruby_global_manual.hpp"
#include "RubyBasicConversions.h"
#include "ruby_cocos2dx_ui_auto.hpp"
#include "ruby_cocos2dx_spine_auto.hpp"
#include "ruby_cocos2dx_experimental_video_auto.hpp"
#include "ruby_cocos2dx_experimental_auto.hpp"
#include "ruby_cocos2dx_auto.hpp"
#include "ruby_cocos2dx_audioengine_auto.hpp"
#include "ruby_cocos2dx_3d_auto.hpp"
extern "C" {
#include "mruby/string.h"
#include "mruby/compile.h"
#include "mruby/class.h"
#include "mruby/data.h"
#include "mruby/array.h"
#include "mruby/range.h"
#include "mruby/hash.h"
#include "mruby/proc.h"
#include "mruby/variable.h"

  void mrb_mruby_curl_gem_init(mrb_state* mrb);
  void mrb_mruby_http_gem_init(mrb_state* mrb);
  void mrb_mruby_thread_gem_init(mrb_state* mrb);
  void mrb_mruby_io_gem_init(mrb_state* mrb);
}
extern void register_cocos2dx_unzip_module(mrb_state* mrb);
extern void register_mruby_jre_module(mrb_state* mrb);

const uint8_t
#if defined __GNUC__
__attribute__((aligned(4)))
#elif defined _MSC_VER
__declspec(align(4))
#endif
MODULE_CC_TO_S[] = {
0x45,0x54,0x49,0x52,0x30,0x30,0x30,0x33,0xb5,0xf1,0x00,0x00,0x0b,0x66,0x4d,0x41,
0x54,0x5a,0x30,0x30,0x30,0x30,0x49,0x52,0x45,0x50,0x00,0x00,0x0a,0xfa,0x30,0x30,
0x30,0x30,0x00,0x00,0x00,0x2f,0x00,0x01,0x00,0x02,0x00,0x01,0x00,0x00,0x00,0x04,
0x05,0x00,0x80,0x00,0x44,0x00,0x80,0x00,0x45,0x00,0x80,0x00,0x4a,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x01,0x00,0x02,0x43,0x43,0x00,0x00,0x00,0x00,
0xdf,0x00,0x01,0x00,0x03,0x00,0x08,0x00,0x00,0x00,0x21,0x00,0x05,0x00,0x80,0x00,
0x05,0x00,0x00,0x01,0x43,0x00,0x80,0x00,0x45,0x00,0x80,0x00,0x05,0x00,0x80,0x00,
0x05,0x00,0x00,0x01,0x43,0x40,0x80,0x00,0xc5,0x00,0x80,0x00,0x05,0x00,0x80,0x00,
0x05,0x00,0x00,0x01,0x43,0x80,0x80,0x00,0x45,0x01,0x80,0x00,0x05,0x00,0x80,0x00,
0x05,0x00,0x00,0x01,0x43,0xc0,0x80,0x00,0xc5,0x01,0x80,0x00,0x05,0x00,0x80,0x00,
0x05,0x00,0x00,0x01,0x43,0x00,0x81,0x00,0x45,0x02,0x80,0x00,0x05,0x00,0x80,0x00,
0x05,0x00,0x00,0x01,0x43,0x40,0x81,0x00,0xc5,0x02,0x80,0x00,0x05,0x00,0x80,0x00,
0x05,0x00,0x00,0x01,0x43,0x80,0x81,0x00,0x45,0x03,0x80,0x00,0x05,0x00,0x80,0x00,
0x05,0x00,0x00,0x01,0x43,0xc0,0x81,0x00,0xc5,0x03,0x80,0x00,0x29,0x00,0x80,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x08,0x00,0x04,0x56,0x65,0x63,0x32,0x00,0x00,
0x04,0x56,0x65,0x63,0x33,0x00,0x00,0x04,0x56,0x65,0x63,0x34,0x00,0x00,0x04,0x53,
0x69,0x7a,0x65,0x00,0x00,0x04,0x52,0x65,0x63,0x74,0x00,0x00,0x07,0x43,0x6f,0x6c,
0x6f,0x72,0x33,0x42,0x00,0x00,0x07,0x43,0x6f,0x6c,0x6f,0x72,0x34,0x42,0x00,0x00,
0x07,0x43,0x6f,0x6c,0x6f,0x72,0x34,0x46,0x00,0x00,0x00,0x00,0x62,0x00,0x01,0x00,
0x05,0x00,0x01,0x00,0x00,0x00,0x09,0x00,0x06,0x00,0x80,0x00,0x84,0x00,0x00,0x01,
0x04,0x01,0x80,0x01,0x20,0x01,0x80,0x00,0x48,0x00,0x80,0x00,0xc0,0x00,0x00,0x01,
0x46,0x80,0x80,0x00,0x04,0x01,0x80,0x00,0x29,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x03,0x00,0x0c,0x61,0x6c,0x69,0x61,0x73,0x5f,0x6d,0x65,0x74,0x68,
0x6f,0x64,0x00,0x00,0x0b,0x6e,0x61,0x74,0x69,0x76,0x65,0x5f,0x74,0x6f,0x5f,0x73,
0x00,0x00,0x04,0x74,0x6f,0x5f,0x73,0x00,0x00,0x00,0x00,0x70,0x00,0x02,0x00,0x07,
0x00,0x00,0x00,0x00,0x00,0x0b,0x00,0x00,0x26,0x00,0x00,0x00,0x3d,0x00,0x00,0x01,
0x06,0x00,0x80,0x01,0x20,0x40,0x80,0x01,0x06,0x00,0x00,0x02,0x20,0x80,0x00,0x02,
0x06,0x00,0x80,0x02,0x20,0xc0,0x80,0x02,0xb7,0xc1,0x80,0x01,0xa0,0x00,0x00,0x01,
0x29,0x00,0x00,0x01,0x00,0x00,0x00,0x01,0x00,0x00,0x0d,0x25,0x73,0x5b,0x78,0x3a,
0x25,0x66,0x2c,0x79,0x3a,0x25,0x66,0x5d,0x00,0x00,0x00,0x04,0x00,0x01,0x25,0x00,
0x00,0x0b,0x6e,0x61,0x74,0x69,0x76,0x65,0x5f,0x74,0x6f,0x5f,0x73,0x00,0x00,0x01,
0x78,0x00,0x00,0x01,0x79,0x00,0x00,0x00,0x00,0x62,0x00,0x01,0x00,0x05,0x00,0x01,
0x00,0x00,0x00,0x09,0x06,0x00,0x80,0x00,0x84,0x00,0x00,0x01,0x04,0x01,0x80,0x01,
0x20,0x01,0x80,0x00,0x48,0x00,0x80,0x00,0xc0,0x00,0x00,0x01,0x46,0x80,0x80,0x00,
0x04,0x01,0x80,0x00,0x29,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x03,
0x00,0x0c,0x61,0x6c,0x69,0x61,0x73,0x5f,0x6d,0x65,0x74,0x68,0x6f,0x64,0x00,0x00,
0x0b,0x6e,0x61,0x74,0x69,0x76,0x65,0x5f,0x74,0x6f,0x5f,0x73,0x00,0x00,0x04,0x74,
0x6f,0x5f,0x73,0x00,0x00,0x00,0x00,0x81,0x00,0x02,0x00,0x08,0x00,0x00,0x00,0x00,
0x00,0x0d,0x00,0x00,0x26,0x00,0x00,0x00,0x3d,0x00,0x00,0x01,0x06,0x00,0x80,0x01,
0x20,0x40,0x80,0x01,0x06,0x00,0x00,0x02,0x20,0x80,0x00,0x02,0x06,0x00,0x80,0x02,
0x20,0xc0,0x80,0x02,0x06,0x00,0x00,0x03,0x20,0x00,0x01,0x03,0x37,0xc2,0x80,0x01,
0xa0,0x00,0x00,0x01,0x29,0x00,0x00,0x01,0x00,0x00,0x00,0x01,0x00,0x00,0x12,0x25,
0x73,0x5b,0x78,0x3a,0x25,0x66,0x2c,0x79,0x3a,0x25,0x66,0x2c,0x7a,0x3a,0x25,0x66,
0x5d,0x00,0x00,0x00,0x05,0x00,0x01,0x25,0x00,0x00,0x0b,0x6e,0x61,0x74,0x69,0x76,
0x65,0x5f,0x74,0x6f,0x5f,0x73,0x00,0x00,0x01,0x78,0x00,0x00,0x01,0x79,0x00,0x00,
0x01,0x7a,0x00,0x00,0x00,0x00,0x62,0x00,0x01,0x00,0x05,0x00,0x01,0x00,0x00,0x00,
0x09,0x00,0x00,0x00,0x06,0x00,0x80,0x00,0x84,0x00,0x00,0x01,0x04,0x01,0x80,0x01,
0x20,0x01,0x80,0x00,0x48,0x00,0x80,0x00,0xc0,0x00,0x00,0x01,0x46,0x80,0x80,0x00,
0x04,0x01,0x80,0x00,0x29,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x03,
0x00,0x0c,0x61,0x6c,0x69,0x61,0x73,0x5f,0x6d,0x65,0x74,0x68,0x6f,0x64,0x00,0x00,
0x0b,0x6e,0x61,0x74,0x69,0x76,0x65,0x5f,0x74,0x6f,0x5f,0x73,0x00,0x00,0x04,0x74,
0x6f,0x5f,0x73,0x00,0x00,0x00,0x00,0x92,0x00,0x02,0x00,0x09,0x00,0x00,0x00,0x00,
0x00,0x0f,0x00,0x00,0x26,0x00,0x00,0x00,0x3d,0x00,0x00,0x01,0x06,0x00,0x80,0x01,
0x20,0x40,0x80,0x01,0x06,0x00,0x00,0x02,0x20,0x80,0x00,0x02,0x06,0x00,0x80,0x02,
0x20,0xc0,0x80,0x02,0x06,0x00,0x00,0x03,0x20,0x00,0x01,0x03,0x06,0x00,0x80,0x03,
0x20,0x40,0x81,0x03,0xb7,0xc2,0x80,0x01,0xa0,0x00,0x00,0x01,0x29,0x00,0x00,0x01,
0x00,0x00,0x00,0x01,0x00,0x00,0x17,0x25,0x73,0x5b,0x78,0x3a,0x25,0x66,0x2c,0x79,
0x3a,0x25,0x66,0x2c,0x7a,0x3a,0x25,0x66,0x2c,0x77,0x3a,0x25,0x66,0x5d,0x00,0x00,
0x00,0x06,0x00,0x01,0x25,0x00,0x00,0x0b,0x6e,0x61,0x74,0x69,0x76,0x65,0x5f,0x74,
0x6f,0x5f,0x73,0x00,0x00,0x01,0x78,0x00,0x00,0x01,0x79,0x00,0x00,0x01,0x7a,0x00,
0x00,0x01,0x77,0x00,0x00,0x00,0x00,0x62,0x00,0x01,0x00,0x05,0x00,0x01,0x00,0x00,
0x00,0x09,0x00,0x00,0x06,0x00,0x80,0x00,0x84,0x00,0x00,0x01,0x04,0x01,0x80,0x01,
0x20,0x01,0x80,0x00,0x48,0x00,0x80,0x00,0xc0,0x00,0x00,0x01,0x46,0x80,0x80,0x00,
0x04,0x01,0x80,0x00,0x29,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x03,
0x00,0x0c,0x61,0x6c,0x69,0x61,0x73,0x5f,0x6d,0x65,0x74,0x68,0x6f,0x64,0x00,0x00,
0x0b,0x6e,0x61,0x74,0x69,0x76,0x65,0x5f,0x74,0x6f,0x5f,0x73,0x00,0x00,0x04,0x74,
0x6f,0x5f,0x73,0x00,0x00,0x00,0x00,0x82,0x00,0x02,0x00,0x07,0x00,0x00,0x00,0x00,
0x00,0x0b,0x00,0x00,0x26,0x00,0x00,0x00,0x3d,0x00,0x00,0x01,0x06,0x00,0x80,0x01,
0x20,0x40,0x80,0x01,0x06,0x00,0x00,0x02,0x20,0x80,0x00,0x02,0x06,0x00,0x80,0x02,
0x20,0xc0,0x80,0x02,0xb7,0xc1,0x80,0x01,0xa0,0x00,0x00,0x01,0x29,0x00,0x00,0x01,
0x00,0x00,0x00,0x01,0x00,0x00,0x16,0x25,0x73,0x5b,0x77,0x69,0x64,0x74,0x68,0x3a,
0x25,0x66,0x2c,0x68,0x65,0x69,0x67,0x68,0x74,0x3a,0x25,0x66,0x5d,0x00,0x00,0x00,
0x04,0x00,0x01,0x25,0x00,0x00,0x0b,0x6e,0x61,0x74,0x69,0x76,0x65,0x5f,0x74,0x6f,
0x5f,0x73,0x00,0x00,0x05,0x77,0x69,0x64,0x74,0x68,0x00,0x00,0x06,0x68,0x65,0x69,
0x67,0x68,0x74,0x00,0x00,0x00,0x00,0xf0,0x00,0x01,0x00,0x05,0x00,0x06,0x00,0x00,
0x00,0x1c,0x00,0x00,0x06,0x00,0x80,0x00,0x84,0x00,0x00,0x01,0x04,0x01,0x80,0x01,
0x20,0x01,0x80,0x00,0x06,0x00,0x80,0x00,0x84,0x01,0x00,0x01,0x04,0x02,0x80,0x01,
0x20,0x01,0x80,0x00,0x48,0x00,0x80,0x00,0xc0,0x00,0x00,0x01,0x46,0x40,0x81,0x00,
0x48,0x00,0x80,0x00,0xc0,0x02,0x00,0x01,0x46,0x80,0x81,0x00,0x48,0x00,0x80,0x00,
0xc0,0x04,0x00,0x01,0x46,0xc0,0x81,0x00,0x48,0x00,0x80,0x00,0xc0,0x06,0x00,0x01,
0x46,0x00,0x82,0x00,0x48,0x00,0x80,0x00,0xc0,0x08,0x00,0x01,0x46,0x80,0x80,0x00,
0x48,0x00,0x80,0x00,0xc0,0x0a,0x00,0x01,0x46,0x00,0x81,0x00,0x04,0x02,0x80,0x00,
0x29,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x09,0x00,0x0c,0x61,0x6c,
0x69,0x61,0x73,0x5f,0x6d,0x65,0x74,0x68,0x6f,0x64,0x00,0x00,0x15,0x6e,0x61,0x74,
0x69,0x76,0x65,0x5f,0x63,0x6f,0x6e,0x74,0x61,0x69,0x6e,0x73,0x5f,0x70,0x6f,0x69,
0x6e,0x74,0x00,0x00,0x0e,0x63,0x6f,0x6e,0x74,0x61,0x69,0x6e,0x73,0x5f,0x70,0x6f,
0x69,0x6e,0x74,0x00,0x00,0x0b,0x6e,0x61,0x74,0x69,0x76,0x65,0x5f,0x74,0x6f,0x5f,
0x73,0x00,0x00,0x04,0x74,0x6f,0x5f,0x73,0x00,0x00,0x01,0x78,0x00,0x00,0x01,0x79,
0x00,0x00,0x05,0x77,0x69,0x64,0x74,0x68,0x00,0x00,0x06,0x68,0x65,0x69,0x67,0x68,
0x74,0x00,0x00,0x00,0x00,0x3b,0x00,0x02,0x00,0x04,0x00,0x00,0x00,0x00,0x00,0x05,
0x26,0x00,0x00,0x00,0x06,0x00,0x00,0x01,0x20,0x00,0x00,0x01,0x20,0x40,0x00,0x01,
0x29,0x00,0x00,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x02,0x00,0x06,0x6f,0x72,
0x69,0x67,0x69,0x6e,0x00,0x00,0x01,0x78,0x00,0x00,0x00,0x00,0x3b,0x00,0x02,0x00,
0x04,0x00,0x00,0x00,0x00,0x00,0x05,0x00,0x26,0x00,0x00,0x00,0x06,0x00,0x00,0x01,
0x20,0x00,0x00,0x01,0x20,0x40,0x00,0x01,0x29,0x00,0x00,0x01,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x02,0x00,0x06,0x6f,0x72,0x69,0x67,0x69,0x6e,0x00,0x00,0x01,0x79,
0x00,0x00,0x00,0x00,0x3d,0x00,0x02,0x00,0x04,0x00,0x00,0x00,0x00,0x00,0x05,0x00,
0x26,0x00,0x00,0x00,0x06,0x00,0x00,0x01,0x20,0x00,0x00,0x01,0x20,0x40,0x00,0x01,
0x29,0x00,0x00,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x02,0x00,0x04,0x73,0x69,
0x7a,0x65,0x00,0x00,0x05,0x77,0x69,0x64,0x74,0x68,0x00,0x00,0x00,0x00,0x3e,0x00,
0x02,0x00,0x04,0x00,0x00,0x00,0x00,0x00,0x05,0x00,0x00,0x00,0x26,0x00,0x00,0x00,
0x06,0x00,0x00,0x01,0x20,0x00,0x00,0x01,0x20,0x40,0x00,0x01,0x29,0x00,0x00,0x01,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x02,0x00,0x04,0x73,0x69,0x7a,0x65,0x00,0x00,
0x06,0x68,0x65,0x69,0x67,0x68,0x74,0x00,0x00,0x00,0x01,0x20,0x00,0x04,0x00,0x09,
0x00,0x00,0x00,0x00,0x00,0x21,0x00,0x00,0x26,0x00,0x10,0x02,0x97,0x00,0x40,0x00,
0x97,0x00,0x40,0x00,0x05,0x00,0x00,0x01,0x01,0x40,0x00,0x02,0x91,0x00,0x80,0x02,
0xa0,0x00,0x00,0x02,0x99,0x01,0x40,0x02,0x01,0x80,0x00,0x02,0x91,0x00,0x80,0x02,
0xa0,0x00,0x00,0x02,0x19,0x04,0x40,0x02,0x06,0x00,0x00,0x02,0x11,0x02,0x80,0x02,
0x93,0x01,0x80,0x02,0x01,0x40,0x00,0x03,0x01,0x80,0x80,0x03,0x20,0x41,0x81,0x02,
0xa0,0x80,0x00,0x02,0x17,0x06,0x40,0x00,0x01,0x40,0x00,0x02,0x11,0x02,0x80,0x02,
0x93,0x01,0x80,0x02,0xa0,0x00,0x00,0x02,0x19,0x02,0x40,0x02,0x06,0x00,0x00,0x02,
0x01,0x40,0x80,0x02,0xa0,0x80,0x00,0x02,0x97,0x01,0x40,0x00,0x06,0x00,0x00,0x02,
0x3d,0x00,0x80,0x02,0xa0,0x80,0x01,0x02,0x29,0x00,0x00,0x02,0x00,0x00,0x00,0x01,
0x00,0x00,0x3b,0x75,0x6e,0x6b,0x6e,0x6f,0x77,0x20,0x61,0x72,0x67,0x73,0x20,0x2c,
0x65,0x78,0x70,0x65,0x63,0x74,0x20,0x28,0x4e,0x75,0x6d,0x65,0x72,0x69,0x63,0x20,
0x78,0x2c,0x4e,0x75,0x6d,0x65,0x72,0x69,0x63,0x20,0x79,0x29,0x20,0x6f,0x72,0x20,
0x28,0x43,0x43,0x3a,0x3a,0x56,0x65,0x63,0x32,0x20,0x76,0x65,0x63,0x29,0x00,0x00,
0x00,0x07,0x00,0x05,0x69,0x73,0x5f,0x61,0x3f,0x00,0x00,0x07,0x4e,0x75,0x6d,0x65,
0x72,0x69,0x63,0x00,0x00,0x15,0x6e,0x61,0x74,0x69,0x76,0x65,0x5f,0x63,0x6f,0x6e,
0x74,0x61,0x69,0x6e,0x73,0x5f,0x70,0x6f,0x69,0x6e,0x74,0x00,0x00,0x04,0x56,0x65,
0x63,0x32,0x00,0x00,0x02,0x43,0x43,0x00,0x00,0x03,0x6e,0x65,0x77,0x00,0x00,0x05,
0x72,0x61,0x69,0x73,0x65,0x00,0x00,0x00,0x00,0xa4,0x00,0x02,0x00,0x09,0x00,0x00,
0x00,0x00,0x00,0x0f,0x26,0x00,0x00,0x00,0x3d,0x00,0x00,0x01,0x06,0x00,0x80,0x01,
0x20,0x40,0x80,0x01,0x06,0x00,0x00,0x02,0x20,0x80,0x00,0x02,0x06,0x00,0x80,0x02,
0x20,0xc0,0x80,0x02,0x06,0x00,0x00,0x03,0x20,0x00,0x01,0x03,0x06,0x00,0x80,0x03,
0x20,0x40,0x81,0x03,0xb7,0xc2,0x80,0x01,0xa0,0x00,0x00,0x01,0x29,0x00,0x00,0x01,
0x00,0x00,0x00,0x01,0x00,0x00,0x20,0x25,0x73,0x5b,0x78,0x3a,0x25,0x66,0x2c,0x79,
0x3a,0x25,0x66,0x2c,0x77,0x69,0x64,0x74,0x68,0x3a,0x25,0x66,0x2c,0x68,0x65,0x69,
0x67,0x68,0x74,0x3a,0x25,0x66,0x5d,0x00,0x00,0x00,0x06,0x00,0x01,0x25,0x00,0x00,
0x0b,0x6e,0x61,0x74,0x69,0x76,0x65,0x5f,0x74,0x6f,0x5f,0x73,0x00,0x00,0x01,0x78,
0x00,0x00,0x01,0x79,0x00,0x00,0x05,0x77,0x69,0x64,0x74,0x68,0x00,0x00,0x06,0x68,
0x65,0x69,0x67,0x68,0x74,0x00,0x00,0x00,0x00,0x62,0x00,0x01,0x00,0x05,0x00,0x01,
0x00,0x00,0x00,0x09,0x06,0x00,0x80,0x00,0x84,0x00,0x00,0x01,0x04,0x01,0x80,0x01,
0x20,0x01,0x80,0x00,0x48,0x00,0x80,0x00,0xc0,0x00,0x00,0x01,0x46,0x80,0x80,0x00,
0x04,0x01,0x80,0x00,0x29,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x03,
0x00,0x0c,0x61,0x6c,0x69,0x61,0x73,0x5f,0x6d,0x65,0x74,0x68,0x6f,0x64,0x00,0x00,
0x0b,0x6e,0x61,0x74,0x69,0x76,0x65,0x5f,0x74,0x6f,0x5f,0x73,0x00,0x00,0x04,0x74,
0x6f,0x5f,0x73,0x00,0x00,0x00,0x00,0x8d,0x00,0x02,0x00,0x08,0x00,0x00,0x00,0x00,
0x00,0x0d,0x00,0x00,0x26,0x00,0x00,0x00,0x3d,0x00,0x00,0x01,0x06,0x00,0x80,0x01,
0x20,0x40,0x80,0x01,0x06,0x00,0x00,0x02,0x20,0x80,0x00,0x02,0x06,0x00,0x80,0x02,
0x20,0xc0,0x80,0x02,0x06,0x00,0x00,0x03,0x20,0x00,0x01,0x03,0x37,0xc2,0x80,0x01,
0xa0,0x00,0x00,0x01,0x29,0x00,0x00,0x01,0x00,0x00,0x00,0x01,0x00,0x00,0x1e,0x25,
0x73,0x5b,0x72,0x3a,0x30,0x78,0x25,0x30,0x32,0x58,0x2c,0x67,0x3a,0x30,0x78,0x25,
0x30,0x32,0x58,0x2c,0x62,0x3a,0x30,0x78,0x25,0x30,0x32,0x58,0x5d,0x00,0x00,0x00,
0x05,0x00,0x01,0x25,0x00,0x00,0x0b,0x6e,0x61,0x74,0x69,0x76,0x65,0x5f,0x74,0x6f,
0x5f,0x73,0x00,0x00,0x01,0x72,0x00,0x00,0x01,0x67,0x00,0x00,0x01,0x62,0x00,0x00,
0x00,0x00,0x62,0x00,0x01,0x00,0x05,0x00,0x01,0x00,0x00,0x00,0x09,0x00,0x00,0x00,
0x06,0x00,0x80,0x00,0x84,0x00,0x00,0x01,0x04,0x01,0x80,0x01,0x20,0x01,0x80,0x00,
0x48,0x00,0x80,0x00,0xc0,0x00,0x00,0x01,0x46,0x80,0x80,0x00,0x04,0x01,0x80,0x00,
0x29,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x03,0x00,0x0c,0x61,0x6c,
0x69,0x61,0x73,0x5f,0x6d,0x65,0x74,0x68,0x6f,0x64,0x00,0x00,0x0b,0x6e,0x61,0x74,
0x69,0x76,0x65,0x5f,0x74,0x6f,0x5f,0x73,0x00,0x00,0x04,0x74,0x6f,0x5f,0x73,0x00,
0x00,0x00,0x00,0xa2,0x00,0x02,0x00,0x09,0x00,0x00,0x00,0x00,0x00,0x0f,0x00,0x00,
0x26,0x00,0x00,0x00,0x3d,0x00,0x00,0x01,0x06,0x00,0x80,0x01,0x20,0x40,0x80,0x01,
0x06,0x00,0x00,0x02,0x20,0x80,0x00,0x02,0x06,0x00,0x80,0x02,0x20,0xc0,0x80,0x02,
0x06,0x00,0x00,0x03,0x20,0x00,0x01,0x03,0x06,0x00,0x80,0x03,0x20,0x40,0x81,0x03,
0xb7,0xc2,0x80,0x01,0xa0,0x00,0x00,0x01,0x29,0x00,0x00,0x01,0x00,0x00,0x00,0x01,
0x00,0x00,0x27,0x25,0x73,0x5b,0x72,0x3a,0x30,0x78,0x25,0x30,0x32,0x58,0x2c,0x67,
0x3a,0x30,0x78,0x25,0x30,0x32,0x58,0x2c,0x62,0x3a,0x30,0x78,0x25,0x30,0x32,0x58,
0x2c,0x61,0x3a,0x30,0x78,0x25,0x30,0x32,0x58,0x5d,0x00,0x00,0x00,0x06,0x00,0x01,
0x25,0x00,0x00,0x0b,0x6e,0x61,0x74,0x69,0x76,0x65,0x5f,0x74,0x6f,0x5f,0x73,0x00,
0x00,0x01,0x72,0x00,0x00,0x01,0x67,0x00,0x00,0x01,0x62,0x00,0x00,0x01,0x61,0x00,
0x00,0x00,0x00,0x62,0x00,0x01,0x00,0x05,0x00,0x01,0x00,0x00,0x00,0x09,0x00,0x00,
0x06,0x00,0x80,0x00,0x84,0x00,0x00,0x01,0x04,0x01,0x80,0x01,0x20,0x01,0x80,0x00,
0x48,0x00,0x80,0x00,0xc0,0x00,0x00,0x01,0x46,0x80,0x80,0x00,0x04,0x01,0x80,0x00,
0x29,0x00,0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x03,0x00,0x0c,0x61,0x6c,
0x69,0x61,0x73,0x5f,0x6d,0x65,0x74,0x68,0x6f,0x64,0x00,0x00,0x0b,0x6e,0x61,0x74,
0x69,0x76,0x65,0x5f,0x74,0x6f,0x5f,0x73,0x00,0x00,0x04,0x74,0x6f,0x5f,0x73,0x00,
0x00,0x00,0x00,0x92,0x00,0x02,0x00,0x09,0x00,0x00,0x00,0x00,0x00,0x0f,0x00,0x00,
0x26,0x00,0x00,0x00,0x3d,0x00,0x00,0x01,0x06,0x00,0x80,0x01,0x20,0x40,0x80,0x01,
0x06,0x00,0x00,0x02,0x20,0x80,0x00,0x02,0x06,0x00,0x80,0x02,0x20,0xc0,0x80,0x02,
0x06,0x00,0x00,0x03,0x20,0x00,0x01,0x03,0x06,0x00,0x80,0x03,0x20,0x40,0x81,0x03,
0xb7,0xc2,0x80,0x01,0xa0,0x00,0x00,0x01,0x29,0x00,0x00,0x01,0x00,0x00,0x00,0x01,
0x00,0x00,0x17,0x25,0x73,0x5b,0x72,0x3a,0x25,0x66,0x2c,0x67,0x3a,0x25,0x66,0x2c,
0x62,0x3a,0x25,0x66,0x2c,0x61,0x3a,0x25,0x66,0x5d,0x00,0x00,0x00,0x06,0x00,0x01,
0x25,0x00,0x00,0x0b,0x6e,0x61,0x74,0x69,0x76,0x65,0x5f,0x74,0x6f,0x5f,0x73,0x00,
0x00,0x01,0x72,0x00,0x00,0x01,0x67,0x00,0x00,0x01,0x62,0x00,0x00,0x01,0x61,0x00,
0x4c,0x56,0x41,0x52,0x00,0x00,0x00,0x4e,0x00,0x00,0x00,0x02,0x00,0x01,0x78,0x00,
0x01,0x79,0xff,0xff,0x00,0x00,0xff,0xff,0x00,0x00,0xff,0xff,0x00,0x00,0xff,0xff,
0x00,0x00,0xff,0xff,0x00,0x00,0xff,0xff,0x00,0x00,0xff,0xff,0x00,0x00,0xff,0xff,
0x00,0x00,0x00,0x00,0x00,0x01,0x00,0x01,0x00,0x02,0xff,0xff,0x00,0x00,0xff,0xff,
0x00,0x00,0xff,0xff,0x00,0x00,0xff,0xff,0x00,0x00,0xff,0xff,0x00,0x00,0x45,0x4e,
0x44,0x00,0x00,0x00,0x00,0x08,
};
 


NS_CC_BEGIN

RubyEngine* RubyEngine::_defaultEngine = nullptr;

static const std::string TEXT_FILE_EXT = ".rb";
static const std::string BYTE_FILE_EXT = ".rbc";

RubyEngine* RubyEngine::getInstance(void)
{
    if (!_defaultEngine)
    {
        _defaultEngine = new RubyEngine();
        _defaultEngine->init();
    }
    return _defaultEngine;
}

RubyEngine::RubyEngine(void) {
    _mrb = mrb_open();
}

RubyEngine::~RubyEngine(void)
{
    _defaultEngine = nullptr;
    if (_mrb) {
        mrb_close(_mrb);
    }
}

bool RubyEngine::init(void)
{
    if (!_mrb) {
        return false;
    }
    
#if CC_ENABLE_SCRIPT_BINDING_MEMORY_CONTROL
    mrb_value refpool = mrb_ary_new(_mrb);
    mrb_gv_set(_mrb, mrb_intern_cstr(_mrb, "$__REFERENCE_POOL__"), refpool);
    mrb_gv_set(_mrb, mrb_intern_cstr(_mrb, "$__REFERENCE_POOL_COUNTER__"), mrb_fixnum_value(0));
#endif
    
    register_all_global_manual(_mrb);
    
    register_all_cocos2dx(_mrb);
    register_all_cocos2dx_ui(_mrb);
    register_all_cocos2dx_audioengine(_mrb);
    register_all_cocos2dx_experimental(_mrb);
    register_all_cocos2dx_3d(_mrb);
    register_all_cocos2dx_spine(_mrb);
    register_all_cocos2dx_experimental_video(_mrb);
    register_cocos2dx_unzip_module(_mrb);
    register_mruby_jre_module(_mrb);

    mrb_mruby_curl_gem_init(_mrb);
    mrb_mruby_http_gem_init(_mrb);    
    mrb_mruby_thread_gem_init(_mrb);
    mrb_mruby_io_gem_init(_mrb);

    int ai = mrb_gc_arena_save(_mrb);
    mrb_load_irep(_mrb, MODULE_CC_TO_S);
    if (_mrb->exc) {
        mrb_print_error(_mrb);
        exit(EXIT_FAILURE);
    }
    mrb_gc_arena_restore(_mrb, ai);

    
    return true;
}

void RubyEngine::removeScriptObjectByObject(Ref* pObj)
{
    if (pObj->_scriptObject) {
        _ScriptObject* script_obj = (_ScriptObject*)pObj->_scriptObject;
        delete script_obj;
    }
}

bool RubyEngine::retainScriptObjectByObject(Ref* obj)
{
#if CC_ENABLE_SCRIPT_BINDING_MEMORY_CONTROL
    static mrb_int ref_index = 0;
    if (obj->_scriptObject) {
        _ScriptObject *script_obj = (_ScriptObject*)obj->_scriptObject;
        mrb_value refpool = mrb_gv_get(_mrb, mrb_intern_cstr(_mrb, "$__REFERENCE_POOL__"));
        if (! mrb_array_p(refpool)) {
            return false;
        }
        if (script_obj->ref_count == 0) {
            mrb_ary_set(_mrb, refpool, ref_index, script_obj->mrb_val);
            script_obj->refpool_idx = ref_index;
            ref_index++;
        }
        script_obj->ref_count++;
        return true;
    }
#endif
    return false;
}

bool RubyEngine::releaseScriptObjectByObject(Ref* obj)
{
#if CC_ENABLE_SCRIPT_BINDING_MEMORY_CONTROL
    if (obj->_scriptObject) {
        _ScriptObject *script_obj = (_ScriptObject*)obj->_scriptObject;
        mrb_value refpool = mrb_gv_get(_mrb, mrb_intern_cstr(_mrb, "$__REFERENCE_POOL__"));
        if (! mrb_array_p(refpool)) {
            return false;
        }
        if (script_obj->refpool_idx < 0) {
            return false;
        }
        script_obj->ref_count--;
        if (script_obj->ref_count == 0) {
            mrb_ary_set(_mrb, refpool, script_obj->refpool_idx, mrb_nil_value());
            script_obj->refpool_idx = -1;
        }
        return true;
    }
#endif
    return false;
}

void RubyEngine::removeScriptHandler(int nHandler)
{
}

int RubyEngine::executeString(const char* codes)
{
    return executeString(codes, "code");
}

int RubyEngine::executeString(const char* codes, const char* filename)
{
    mrb_state* mrb = _mrb;
    
    mrbc_context *cxt = mrbc_context_new(mrb);
    mrbc_filename(mrb, cxt, filename);
    
    int arn = mrb_gc_arena_save(mrb);
    
    mrb_load_string_cxt(mrb, codes, cxt);
    
    bool ret = 0;
    if (mrb->exc) {
        printError();
        ret = 1;
    }
    
    mrb_gc_arena_restore(mrb, arn);
    
    mrbc_context_free(mrb, cxt);
    
    return ret;
}

int RubyEngine::executeScriptFile(const char* filename)
{
    std::string filename_str(filename);
    std::string realfile = findFile(filename_str);
    
    auto utils = cocos2d::FileUtils::getInstance();
    ssize_t size = 0;
    unsigned char* file_text = utils->getFileData(realfile, "rb", &size);
    std::string codes((char*)file_text, size);
    
    return executeString(codes.c_str(), filename);
}

int RubyEngine::executeGlobalFunction(const char* functionName)
{
    return 0;
}

int RubyEngine::sendEvent(ScriptEvent* evt)
{
    return 0;
}

int RubyEngine::handleTouchEvent(void* data)
{
    return 0;
}

int RubyEngine::handleMenuClickedEvent(void* data)
{
    return 0;
}

bool RubyEngine::handleAssert(const char *msg)
{
    return true;
}

bool RubyEngine::parseConfig(ConfigType type, const std::string& str)
{
    return true;
}

void RubyEngine::addSearchPath(const char* path)
{
    mrb_state* mrb = _mrb;
    mrb_value load_path_arr = mrb_gv_get(mrb, mrb_intern_cstr(mrb, "$LOAD_PATH"));
    
    if (! mrb_array_p(load_path_arr)) {
        load_path_arr = mrb_ary_new(mrb);
        mrb_value path_val = mrb_str_new_cstr(mrb, path);
        mrb_ary_push(mrb, load_path_arr, path_val);
        mrb_gv_set(mrb, mrb_intern_cstr(mrb, "$LOAD_PATH"), load_path_arr);
    } else {
        mrb_value path_val = mrb_str_new_cstr(mrb, path);
        mrb_ary_push(mrb, load_path_arr, path_val);
    }
}

void RubyEngine::printError()
{
    mrb_state* mrb = _mrb;
    mrb_print_error(mrb);
    mrb->exc = 0;
}

std::string RubyEngine::findFile(std::string filename)
{
    mrb_state* mrb = _mrb;
    
    mrb_value load_path_arr = mrb_gv_get(mrb, mrb_intern_cstr(mrb, "$LOAD_PATH"));
    
    size_t pos = filename.rfind(".");
    if (pos > 0) {
        filename = filename.substr(0, pos);
    }
    
    auto utils = cocos2d::FileUtils::getInstance();
    bool is_notify = utils->isPopupNotify();
    utils->setPopupNotify(false);
    std::string realfile = "";
    bool find = false;
    
    if (mrb_array_p(load_path_arr)) {
        mrb_int len = mrb_ary_len(mrb, load_path_arr);
        for (mrb_int i = 0; i < len; i++) {
            mrb_value path = mrb_ary_ref(mrb, load_path_arr, i);
            if (mrb_string_p(path)) {
                char* path_cstr = mrb_str_to_cstr(mrb, path);
                std::string path_str(path_cstr);
                path_str = path_str.append("/");
                
                realfile = path_str.append(filename).append(TEXT_FILE_EXT);
                if (utils->isFileExist(realfile)) {
                    find = true;
                    break;
                }
                realfile = path_str.append(filename).append(BYTE_FILE_EXT);
                if (utils->isFileExist(realfile)) {
                    find = true;
                    break;
                }
            }
        }
    }
    
    if (! find) {
        realfile = filename.append(TEXT_FILE_EXT);
        if (utils->isFileExist(realfile)) {
            find = true;
        }
        if (! find) {
            realfile = filename.append(BYTE_FILE_EXT);
            if (utils->isFileExist(realfile)) {
                find = true;
            }
        }
    }
    
    if (! find) {
        mrb_raise(mrb, E_RUNTIME_ERROR, "specific file is not exist.");
    }
    
    utils->setPopupNotify(is_notify);
    
    return realfile;
}

NS_CC_END