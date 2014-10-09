#include "mruby_cocos2dx.h"

/*
std::map<std::string, mrb_data_type *>& nameMap(){
	static std::map<std::string, mrb_data_type *> gnameMap;
		return gnameMap;
}
*/
void cocos2d_empty_free(mrb_state *mrb, void*){}
struct RClass* getCocos2dClass(mrb_state *mrb, const char* className) {
  RClass* mod = mrb_module_get(mrb, "Cocos2d");
  return mrb_class_get_under(mrb, mod, className);
}
static void DefineConst(mrb_state *mrb,  struct RClass* cocos2d){
	//LanguageType
	struct RClass * LanguageTypemod=mrb_define_module_under(mrb,cocos2d,"LanguageType");
mrb_define_const(mrb, LanguageTypemod, "ENGLISH", mrb_fixnum_value((int)cocos2d::LanguageType::ENGLISH));
mrb_define_const(mrb, LanguageTypemod, "CHINESE", mrb_fixnum_value((int)cocos2d::LanguageType::CHINESE));
mrb_define_const(mrb, LanguageTypemod, "FRENCH", mrb_fixnum_value((int)cocos2d::LanguageType::FRENCH));
mrb_define_const(mrb, LanguageTypemod, "ITALIAN", mrb_fixnum_value((int)cocos2d::LanguageType::ITALIAN));
mrb_define_const(mrb, LanguageTypemod, "GERMAN", mrb_fixnum_value((int)cocos2d::LanguageType::GERMAN));
mrb_define_const(mrb, LanguageTypemod, "SPANISH", mrb_fixnum_value((int)cocos2d::LanguageType::SPANISH));
mrb_define_const(mrb, LanguageTypemod, "DUTCH", mrb_fixnum_value((int)cocos2d::LanguageType::DUTCH));
mrb_define_const(mrb, LanguageTypemod, "RUSSIAN", mrb_fixnum_value((int)cocos2d::LanguageType::RUSSIAN));
mrb_define_const(mrb, LanguageTypemod, "KOREAN", mrb_fixnum_value((int)cocos2d::LanguageType::KOREAN));
mrb_define_const(mrb, LanguageTypemod, "JAPANESE", mrb_fixnum_value((int)cocos2d::LanguageType::JAPANESE));
mrb_define_const(mrb, LanguageTypemod, "HUNGARIAN", mrb_fixnum_value((int)cocos2d::LanguageType::HUNGARIAN));

  //TextHAlignment
	struct RClass * TextHAlignmentmod=mrb_define_module_under(mrb,cocos2d,"TextHAlignment");
	mrb_define_const(mrb, TextHAlignmentmod, "LEFT", mrb_fixnum_value((int)cocos2d::TextHAlignment::LEFT));
	mrb_define_const(mrb, TextHAlignmentmod, "CENTER", mrb_fixnum_value((int)cocos2d::TextHAlignment::CENTER));
	mrb_define_const(mrb, TextHAlignmentmod, "RIGHT", mrb_fixnum_value((int)cocos2d::TextHAlignment::RIGHT));
  //TextVAlignment
  struct RClass *TextVAlignmentmod=mrb_define_module_under(mrb,cocos2d,"TextVAlignment");
	mrb_define_const(mrb, TextVAlignmentmod, "TOP", mrb_fixnum_value((int)cocos2d::TextVAlignment::TOP));
	mrb_define_const(mrb, TextVAlignmentmod, "CENTER", mrb_fixnum_value((int)cocos2d::TextVAlignment::CENTER));
	mrb_define_const(mrb, TextVAlignmentmod, "BOTTOM", mrb_fixnum_value((int)cocos2d::TextVAlignment::BOTTOM));
}
MRB_API void
mrb_mruby_cocos2dx_gem_init(mrb_state* mrb)
{
	  struct RClass* mod = mrb_define_module(mrb, "Cocos2d");
	  DefineConst(mrb,mod);
	  DefineApplication(mrb,mod);
	  DefineSize(mrb,mod);
	  DefineRef(mrb,mod);
	  DefineGLView(mrb,mod); 
	  DefineDirector(mrb,mod);
	  DefineNode(mrb,mod);
	  DefineSpriteBatchNode(mrb,mod);
	  DefineLabel(mrb,mod);
	  DefineScene(mrb,mod);
	  
}