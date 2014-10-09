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


static void cocos2d_Size_free(mrb_state *mrb, void* ptr){
	((cocos2d::Size *)ptr)->~Size();
		mrb_free(mrb,ptr);
}
static struct mrb_data_type dataType_Size = { "Size", cocos2d_Size_free };

static mrb_value Size_Initialize(mrb_state *mrb, mrb_value self){
	mrb_value* argv;
  int argc;
  mrb_get_args(mrb, "*", &argv, &argc);
  if(argc==1){
  	return mrb_nil_value();
  }
  else{
  	int w=mrb_float(argv[0]);
  	int h=mrb_float(argv[1]);
  	cocos2d::Size * retval = new(mrb_malloc(mrb, sizeof(cocos2d::Size))) cocos2d::Size(w, h);
    DATA_TYPE(self) = &dataType_Size; 
    DATA_PTR(self) = retval; 
    return self;
  }
}
void DefineSize(mrb_state * mrb,struct RClass *mod){
	cocos2d::Application::setMrbType(typeid(cocos2d::Size).name(),&dataType_Size);
	struct RClass * tc=mrb_define_class_under(mrb,mod,"Size",mrb->object_class);
  MRB_SET_INSTANCE_TT(tc, MRB_TT_DATA);

  cocos2d::Size* ptrZero = new(mrb_malloc(mrb, sizeof(cocos2d::Size)))cocos2d::Size(0,0);
  const mrb_value mrbZero = mrb_obj_value(Data_Wrap_Struct(mrb, tc, &dataType_Size, NULL));
   DATA_TYPE(mrbZero) = &dataType_Size; 
   DATA_PTR(mrbZero) = ptrZero; 	
  mrb_define_const(mrb,tc,"ZERO",mrbZero);
  mrb_define_method(mrb, tc, "initialize", Size_Initialize, MRB_ARGS_ARG(1,2)); 
}