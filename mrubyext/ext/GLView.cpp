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
#include "mruby/string.h"
#include "mruby_cocos2dx.h"

static struct mrb_data_type dataType_GLView = { "GLView", cocos2d_empty_free };

//static GLView * 	create (const std::string &viewname)
static mrb_value GLView_create(mrb_state *mrb, mrb_value self){
    mrb_value args;
    mrb_get_args(mrb, "S", &args);
    std::string  p0=std::string(RSTRING_PTR(args),RSTRING_LEN(args));
    cocos2d::GLView * view=cocos2d::GLView::create(p0);
    if(view==NULL){
    	return mrb_nil_value();
    }
    else{
	    mrb_data_type *dtype= cocos2d::Application::getMrbType(typeid(*view).name()); 
	    	//cocos2d::Application::getMrbNameMap()[typeid(*view).name()];
	  	struct RClass* tc=getCocos2dClass(mrb,dtype->struct_name);
	  	mrb_value	instance=mrb_obj_value(Data_Wrap_Struct(mrb, tc, dtype, NULL));
	  	DATA_PTR(instance)=(void *)view;
	  	return instance;
    }
}

void DefineGLView(mrb_state * mrb,struct RClass *mod){
		cocos2d::Application::setMrbType(typeid(cocos2d::GLView).name(),&dataType_GLView);
	//cocos2d::Application::getMrbNameMap()[typeid(cocos2d::GLView).name()]=&dataType_GLView;
	struct RClass * parent=getCocos2dClass(mrb,"Ref");
	struct RClass * tc=mrb_define_class_under(mrb,mod,"GLView",parent);
  MRB_SET_INSTANCE_TT(tc, MRB_TT_DATA);
  //static GLView * 	create (const std::string &viewname)
  mrb_define_class_method(mrb,tc,"create",GLView_create,MRB_ARGS_REQ(1));
}