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

static struct mrb_data_type dataType_SpriteBatchNode = { "SpriteBatchNode", cocos2d_empty_free };
/*
static mrb_value SpriteBatchNode_create(mrb_state *mrb, mrb_value self){
	 cocos2d::SpriteBatchNode * spriteBatchNode=cocos2d::SpriteBatchNode::create();
	struct RClass* tc=getCocos2dClass(mrb,dataType_SpriteBatchNode.struct_name);
			mrb_value instance=mrb_obj_value(Data_Wrap_Struct(mrb, tc, &dataType_SpriteBatchNode, NULL));
			DATA_TYPE(instance)=&dataType_SpriteBatchNode;
			DATA_PTR(instance)=(void *)spriteBatchNode;
			cocos2d::Application::setMrbObj(spriteBatchNode,instance); //::getMrbObjMap()[node]=instance;
			return instance;
	 	
}
*/
void DefineSpriteBatchNode(mrb_state * mrb,struct RClass *mod){
	//cocos2d::Application::getMrbNameMap()[typeid(cocos2d::Node).name()]=&dataType_Node;
	cocos2d::Application::setMrbType(typeid(cocos2d::SpriteBatchNode).name(),&dataType_SpriteBatchNode);
	struct RClass * parent=getCocos2dClass(mrb,"Node");
	struct RClass * tc=mrb_define_class_under(mrb,mod,"SpriteBatchNode",parent);
  MRB_SET_INSTANCE_TT(tc, MRB_TT_DATA);
  //static Node * 	create ()
  //mrb_define_class_method(mrb, tc,"create",SpriteBatchNode_create,MRB_ARGS_NONE());
 
}