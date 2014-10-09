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



static mrb_value Application_getCurrentLanguageCode(mrb_state *mrb, mrb_value self){
  cocos2d::Application*	app =static_cast<cocos2d::Application*>(DATA_PTR(self));
 const char * retval=app->getCurrentLanguageCode();
	return retval==NULL?mrb_nil_value():mrb_str_new_cstr(mrb, retval);;
}
static mrb_value Application_getInstance(mrb_state *mrb, mrb_value self){
		cocos2d::Application *app=cocos2d::Application::getInstance();
		//mrb_data_type *dtype =cocos2d::Application::getMrbNameMap()[typeid(*app).name()];
		//struct RClass* tc=getCocos2dClass(mrb,dtype->struct_name);
		//  mrb_value	instance=mrb_obj_value(Data_Wrap_Struct(mrb, tc, dtype, NULL));
		//	DATA_PTR(instance)=(void *)app;
		//	app->bindMrbValue(&instance);
	mrb_value 	instance=app->getMrbValue();
			return instance;
}

	static mrb_value Application_onEnterBackground(mrb_state *mrb, mrb_value self){
	mrb_value blk;
   struct RProc *p;
   mrb_get_args(mrb, "&", &blk);
    p = mrb_proc_ptr(blk);
    if (!MRB_PROC_STRICT_P(p)) {
     struct RProc *p2 = (struct RProc*)mrb_obj_alloc(mrb, MRB_TT_PROC, p->c);
    mrb_proc_copy(p2, p);
     p2->flags |= MRB_PROC_STRICT;
     p=p2;
   }
   mrb_iv_set(mrb,self,mrb_intern_lit(mrb, "@onEnterBackground_proc"),mrb_obj_value(p));
   return mrb_nil_value();
	}
	static mrb_value Application_onEnterForeground(mrb_state *mrb, mrb_value self){
	mrb_value blk;
   struct RProc *p;
   mrb_get_args(mrb, "&", &blk);
    p = mrb_proc_ptr(blk);
    if (!MRB_PROC_STRICT_P(p)) {
     struct RProc *p2 = (struct RProc*)mrb_obj_alloc(mrb, MRB_TT_PROC, p->c);
    mrb_proc_copy(p2, p);
     p2->flags |= MRB_PROC_STRICT;
     p=p2;
   }
   mrb_iv_set(mrb,self,mrb_intern_lit(mrb, "@onEnterForeground_proc"),mrb_obj_value(p));
   return mrb_nil_value();
	}

static struct mrb_data_type dataType_Application = { "Application", cocos2d_empty_free };
void DefineApplication(mrb_state* mrb,struct RClass *mod)
{
	cocos2d::Application::setMrbType(typeid(cocos2d::Application).name(),&dataType_Application);
	//cocos2d::Application::getMrbNameMap()[typeid(cocos2d::Application).name()]=&dataType_Application;
	struct RClass * tc=mrb_define_class_under(mrb,mod,"Application",mrb->object_class);
  MRB_SET_INSTANCE_TT(tc, MRB_TT_DATA);
  mrb_define_class_method(mrb,tc,"getInstance",Application_getInstance,MRB_ARGS_NONE());
  mrb_define_method(mrb, tc,"onEnterBackground",Application_onEnterBackground,MRB_ARGS_NONE());
  mrb_define_method(mrb, tc,"onEnterForeground",Application_onEnterForeground,MRB_ARGS_NONE());
  //virtual const char * 	getCurrentLanguageCode ()
  mrb_define_method(mrb, tc,"getCurrentLanguageCode",Application_getCurrentLanguageCode,MRB_ARGS_NONE());
}
