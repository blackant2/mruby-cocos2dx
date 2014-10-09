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

static struct mrb_data_type dataType_Node = { "Node", cocos2d_empty_free };

static mrb_value Node_create(mrb_state *mrb, mrb_value self){
	 cocos2d::Node * node=cocos2d::Node::create();
	struct RClass* tc=getCocos2dClass(mrb,dataType_Node.struct_name);
			mrb_value instance=mrb_obj_value(Data_Wrap_Struct(mrb, tc, &dataType_Node, NULL));
			DATA_TYPE(instance)=&dataType_Node;
			DATA_PTR(instance)=(void *)node;
			cocos2d::Application::setMrbObj(node,instance); //::getMrbObjMap()[node]=instance;
			return instance;
	 	
}

void DefineNode(mrb_state * mrb,struct RClass *mod){
	//cocos2d::Application::getMrbNameMap()[typeid(cocos2d::Node).name()]=&dataType_Node;
	cocos2d::Application::setMrbType(typeid(cocos2d::Node).name(),&dataType_Node);
	struct RClass * parent=getCocos2dClass(mrb,"Ref");
	struct RClass * tc=mrb_define_class_under(mrb,mod,"Node",parent);
  MRB_SET_INSTANCE_TT(tc, MRB_TT_DATA);
  //static Node * 	create ()
  mrb_define_class_method(mrb, tc,"create",Node_create,MRB_ARGS_NONE());
 
}