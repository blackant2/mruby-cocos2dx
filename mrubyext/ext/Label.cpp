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

static struct mrb_data_type dataType_Label = { "Label", cocos2d_empty_free };

static mrb_value wrap_Cocos2d_Label(mrb_state * mrb,cocos2d::Label * label){
			struct RClass* tc=getCocos2dClass(mrb,dataType_Label.struct_name);
			mrb_value instance=mrb_obj_value(Data_Wrap_Struct(mrb, tc, &dataType_Label, NULL));
			DATA_TYPE(instance)=&dataType_Label;
			DATA_PTR(instance)=(void *)label;
			cocos2d::Application::setMrbObj(label,instance); //::getMrbObjMap()[node]=instance;
			return instance;
}
static mrb_value Label_create(mrb_state *mrb, mrb_value self){
	 cocos2d::Label * label=cocos2d::Label::create();
			return wrap_Cocos2d_Label(mrb,label);
}
  //static Label *  createWithTTF (const std::string &text, 
  //const std::string &fontFile,
  // float fontSize, 
  //const Size &dimensions=Size::ZERO, 
  //TextHAlignment hAlignment=TextHAlignment::LEFT, 
  //TextVAlignment vAlignment=TextVAlignment::TOP) 
static mrb_value Label_createWithTTF(mrb_state *mrb, mrb_value self) {
	//mrb_intern_lit(mrb, "ZERO")
	mrb_value* argv;
  int argc;
  mrb_get_args(mrb, "*", &argv, &argc);
  
  std::string  text=std::string(RSTRING_PTR(argv[0]),RSTRING_LEN(argv[0]));
	std::string  fontFile=std::string(RSTRING_PTR(argv[1]),RSTRING_LEN(argv[1]));
	float fontSize=mrb_float(argv[2]);
	const cocos2d::Size* dimensions;
	if(argc<4){
			dimensions=&cocos2d::Size::ZERO;
	}
	else{
		 dimensions=(static_cast<cocos2d::Size*>(DATA_PTR(argv[3])));
	}
	cocos2d::TextHAlignment hAlignment;
	if(argc<5){
		hAlignment=cocos2d::TextHAlignment::LEFT;
	}
	else{
		hAlignment=(cocos2d::TextHAlignment)mrb_fixnum(argv[4]);
	}
	cocos2d::TextVAlignment vAlignment;
	if(argc<6){
	  vAlignment=cocos2d::TextVAlignment::TOP;
	}
	else{
	  vAlignment=(cocos2d::TextVAlignment)mrb_fixnum(argv[5]);
	}
	cocos2d::Label * label=cocos2d::Label::createWithTTF(text,fontFile,fontSize,*dimensions,hAlignment,vAlignment);

	return	wrap_Cocos2d_Label(mrb,label);
	
}

//virtual void 	setPosition (float x, float y)
//virtual void 	setPosition (const Vec2 &position)
static mrb_value Label_setPosition(mrb_state *mrb, mrb_value self) {
	cocos2d::Label * instance=static_cast<cocos2d::Label*>(DATA_PTR(self));
		mrb_value* argv;
  int argc;
  mrb_get_args(mrb, "*", &argv, &argc);
  if(argc==1){
  }
  else{
  	 float x=mrb_float(argv[0]);
  	 float y=mrb_float(argv[1]);
  	 instance->setPosition(x,y);
  }
	return self;
}



void DefineLabel(mrb_state * mrb,struct RClass *mod){
	//cocos2d::Application::getMrbNameMap()[typeid(cocos2d::Node).name()]=&dataType_Node;
	cocos2d::Application::setMrbType(typeid(cocos2d::Label).name(),&dataType_Label);
	struct RClass * parent=getCocos2dClass(mrb,"SpriteBatchNode");
	struct RClass * tc=mrb_define_class_under(mrb,mod,"Label",parent);
  MRB_SET_INSTANCE_TT(tc, MRB_TT_DATA);
 //static Label * 	create ()
  mrb_define_class_method(mrb, tc,"create",Label_create,MRB_ARGS_NONE());
  //static Label *  createWithTTF (const std::string &text, 
  //const std::string &fontFile,
  // float fontSize, 
  //const Size &dimensions=Size::ZERO, 
  //TextHAlignment hAlignment=TextHAlignment::LEFT, 
  //TextVAlignment vAlignment=TextVAlignment::TOP)
  mrb_define_class_method(mrb, tc, "createWithTTF", Label_createWithTTF, MRB_ARGS_ARG(3,6));
 //virtual void 	setPosition (float x, float y)
 //virtual void 	setPosition (const Vec2 &position)
 mrb_define_method(mrb, tc, "setPosition", Label_setPosition, MRB_ARGS_ARG(1,2));
}