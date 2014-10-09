#include "mruby.h"
#include <stdio.h>
#include <time.h>
#include <map>
#include <string>
#include <typeinfo>
#include "mruby/class.h"
#include "mruby/data.h"
#include "mruby/proc.h"
#include "mruby/variable.h"
#include "mruby_cocos2dx.h"



static struct mrb_data_type dataType_Ref = { "Ref", cocos2d_empty_free };
void DefineRef(mrb_state * mrb,struct RClass *mod){
		cocos2d::Application::setMrbType(typeid(cocos2d::Ref).name(),&dataType_Ref);
	struct RClass * tc=mrb_define_class_under(mrb,mod,"Ref",mrb->object_class);
  MRB_SET_INSTANCE_TT(tc, MRB_TT_DATA);
  //void 	retain ()
  // mrb_define_method(mrb, tc,"retain",Ref_retain,MRB_ARGS_NONE());
}