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

static struct mrb_data_type dataType_Director = { "Director", cocos2d_empty_free };
  
 //static Director * 	getInstance ()
static mrb_value Director_getInstance(mrb_state *mrb, mrb_value self){
	cocos2d::Director *director=cocos2d::Director::getInstance();
	mrb_value* instance=cocos2d::Application::getMrbObj(director);
		if(instance !=NULL){
			return *instance;
		}
		else{
			struct RClass* tc=getCocos2dClass(mrb,dataType_Director.struct_name);
			mrb_value instance=mrb_obj_value(Data_Wrap_Struct(mrb, tc, &dataType_Director, NULL));
			DATA_TYPE(instance)=&dataType_Director;
			DATA_PTR(instance)=(void *)director;
			//cocos2d::Application::getMrbObjMap()[director]=instance;
			cocos2d::Application::setMrbObj(director,instance);
			return instance;
		}
}

static mrb_value Director_getOpenGLView(mrb_state *mrb, mrb_value self){
	cocos2d::Director*	instance =static_cast<cocos2d::Director*>(DATA_PTR(self));
  cocos2d::GLView * view=instance->getOpenGLView();
  if (view==NULL){
  	return mrb_nil_value();
  }
  else{
  	mrb_data_type *dtype=  cocos2d::Application::getMrbType(typeid(*view).name()); //cocos2d::Application::getMrbNameMap()[typeid(*view).name()];
  	struct RClass* tc=getCocos2dClass(mrb,dtype->struct_name);
  	mrb_value	instance=mrb_obj_value(Data_Wrap_Struct(mrb, tc, dtype, NULL));
  	DATA_PTR(instance)=(void *)view;
  	return instance;
  }
}

 //void setOpenGLView	(	GLView * 	openGLView	)	
static mrb_value Director_setOpenGLView(mrb_state *mrb, mrb_value self){
	mrb_value openGLView;
  mrb_get_args(mrb, "o", &openGLView);
	cocos2d::Director* 	instance =static_cast<cocos2d::Director*>(DATA_PTR(self));
	cocos2d::GLView * ptrGLView=static_cast<cocos2d::GLView*>(DATA_PTR(openGLView));
		instance->setOpenGLView(ptrGLView);
	return self;
}
static mrb_value Director_setDisplayStats(mrb_state *mrb, mrb_value self){
	cocos2d::Director*	instance =static_cast<cocos2d::Director*>(DATA_PTR(self));
	mrb_value displayStats;
  mrb_get_args(mrb, "b", &displayStats);
  instance->setDisplayStats(mrb_bool(displayStats));
  return self;
}

static mrb_value Director_setAnimationInterval(mrb_state *mrb, mrb_value self){
	cocos2d::Director*	instance =static_cast<cocos2d::Director*>(DATA_PTR(self));
	mrb_value interval;
  mrb_get_args(mrb, "f", &interval);
  instance->setAnimationInterval(mrb_float(interval));
  return self;
}
static mrb_value Director_runWithScene(mrb_state *mrb, mrb_value self){
  cocos2d::Director*	instance =static_cast<cocos2d::Director*>(DATA_PTR(self));
  mrb_value scene;
  mrb_get_args(mrb, "o", &scene);
  instance->runWithScene(static_cast<cocos2d::Scene*>(DATA_PTR(scene)));
  return self;
}

void DefineDirector(mrb_state * mrb,struct RClass *mod){
	cocos2d::Application::setMrbType(typeid(cocos2d::Director).name(),&dataType_Director);
	struct RClass * parent=getCocos2dClass(mrb,"Ref");
	struct RClass * tc=mrb_define_class_under(mrb,mod,"Director",parent);
  MRB_SET_INSTANCE_TT(tc, MRB_TT_DATA);
  //static Director * 	getInstance ()
  mrb_define_class_method(mrb, tc,"getInstance",Director_getInstance,MRB_ARGS_NONE());
  //GLView* getOpenGLView	(		)	
  mrb_define_method(mrb, tc,"getOpenGLView",Director_getOpenGLView,MRB_ARGS_NONE());
  //void setOpenGLView	(	GLView * 	openGLView	)	
  mrb_define_method(mrb, tc,"setOpenGLView",Director_setOpenGLView,MRB_ARGS_REQ(1));
  //void 	setDisplayStats (bool displayStats)
  mrb_define_method(mrb, tc,"setDisplayStats",Director_setDisplayStats,MRB_ARGS_REQ(1));
  //virtual void setAnimationInterval	(	double 	interval	)	
 mrb_define_method(mrb, tc,"setAnimationInterval",Director_setAnimationInterval,MRB_ARGS_REQ(1));
 //void 	runWithScene (Scene *scene)
  mrb_define_method(mrb, tc,"runWithScene",Director_runWithScene,MRB_ARGS_REQ(1));
}