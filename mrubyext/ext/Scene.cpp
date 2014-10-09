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

static struct mrb_data_type dataType_Scene = { "Scene", cocos2d_empty_free };

static mrb_value Scene_create(mrb_state *mrb, mrb_value self){
	 cocos2d::Scene * scene=cocos2d::Scene::create();
	struct RClass* tc=getCocos2dClass(mrb,dataType_Scene.struct_name);
	mrb_value instance=mrb_obj_value(Data_Wrap_Struct(mrb, tc, &dataType_Scene, NULL));
	DATA_TYPE(instance)=&dataType_Scene;
	DATA_PTR(instance)=(void *)scene;
	cocos2d::Application::setMrbObj(scene,instance); 
	return instance;
}
static mrb_value Scene_addChild(mrb_state *mrb, mrb_value self){
	cocos2d::Scene * scene=static_cast<cocos2d::Scene*>(DATA_PTR(self));
	mrb_value* argv;
  int argc;
  mrb_get_args(mrb, "*", &argv, &argc);
  if(argc==1 && mrb_obj_is_kind_of(mrb,argv[0],getCocos2dClass(mrb,"Node")) ){

     scene->addChild(static_cast<cocos2d::Node*>(DATA_PTR(argv[0])));
  }
	return self;
}
void DefineScene(mrb_state * mrb,struct RClass *mod){
	cocos2d::Application::setMrbType(typeid(cocos2d::Scene).name(),&dataType_Scene);
	struct RClass * parent=getCocos2dClass(mrb,"Node");
	struct RClass * tc=mrb_define_class_under(mrb,mod,"Scene",parent);
  MRB_SET_INSTANCE_TT(tc, MRB_TT_DATA);
  //static Node * 	create ()
  mrb_define_class_method(mrb, tc,"create",Scene_create,MRB_ARGS_NONE());
  //virtual void 	addChild (Node *child)
 mrb_define_method(mrb, tc,"addChild",Scene_addChild,MRB_ARGS_REQ(1));
}