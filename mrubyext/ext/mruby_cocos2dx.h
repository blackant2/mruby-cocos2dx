#ifndef __MRUBY_COCOS2DX__H_
#define __MRUBY_COCOS2DX__H_

#include "mruby.h"
#include "mruby/data.h"
#include "mruby/compile.h"
#include "mruby/variable.h"
#include "mruby/string.h"
#ifdef LINUX
#include "linux/CCApplication.h"
#endif

#include "cocos2d.h"

/*
typedef struct Cocos2dPtr{
	void * ptr;
} Cocos2dPtr;
*/

void cocos2d_empty_free(mrb_state *mrb, void*);
struct RClass* getCocos2dClass(mrb_state *mrb, const char* className);

void DefineApplication(mrb_state * mrb,struct RClass *mod);
void DefineSize(mrb_state * mrb,struct RClass *mod);
void DefineRef(mrb_state * mrb,struct RClass *mod);
void DefineGLView(mrb_state * mrb,struct RClass *mod); 
void DefineDirector(mrb_state * mrb,struct RClass *mod);
void DefineNode(mrb_state * mrb,struct RClass *mod);
void DefineSpriteBatchNode(mrb_state * mrb,struct RClass *mod);
void DefineLabel(mrb_state * mrb,struct RClass *mod);
void DefineScene(mrb_state * mrb,struct RClass *mod);
MRB_API void mrb_mruby_cocos2dx_gem_init(mrb_state* mrb);

#endif // __MRUBY_COCOS2DX__H_