#if (defined __ANDROID__) ||  (defined ANDROID)

#include <map>
#include <vector>
extern "C" {
#include "mruby.h"  
#include "mruby/data.h"
#include "mruby/class.h"
#include "mruby/string.h"
#include "mruby/value.h"
}
#include "platform/android/jni/jniHelper.h"
#include "safe_jni.hpp"
#include "jni_types.h"
#include "jni_functor.h"

#define JCLASS_CLASS_NAME "JClass"
#define JOBJECT_CLASS_NAME "JObject"
#define JMETHOD_CLASS_NAME "JMethod"
#define JRE_MODULE_NAME "JRE"



typedef mrb_value (*jvalue_to_mrb_value)(mrb_state *mrb, JNIEnv *env, jobject value, std::string const &type_name);
typedef std::map<std::string, jvalue_to_mrb_value> j2m_converter_map_t;

static j2m_converter_map_t j2m_converters;

static mrb_value Boolean_to_mrb(mrb_state *mrb, JNIEnv *env, jobject value, std::string const &type_name);
static mrb_value Character_to_mrb(mrb_state *mrb, JNIEnv *env, jobject value, std::string const &type_name);
static mrb_value Byte_to_mrb(mrb_state *mrb, JNIEnv *env, jobject value, std::string const &type_name);
static mrb_value Short_to_mrb(mrb_state *mrb, JNIEnv *env, jobject value, std::string const &type_name);
static mrb_value Integer_to_mrb(mrb_state *mrb, JNIEnv *env, jobject value, std::string const &type_name);
static mrb_value Long_to_mrb(mrb_state *mrb, JNIEnv *env, jobject value, std::string const &type_name);
static mrb_value Double_to_mrb(mrb_state *mrb, JNIEnv *env, jobject value, std::string const &type_name);
static mrb_value Float_to_mrb(mrb_state *mrb, JNIEnv *env, jobject value, std::string const &type_name);
static mrb_value Object_to_mrb(mrb_state *mrb, JNIEnv *env, jobject value, std::string const &type_name);
static mrb_value String_to_mrb(mrb_state *mrb, JNIEnv *env, jobject value, std::string const &type_name);

//extern bool create_mrb_value(JNIEnv *env, jobject value, mrb_value &store);
//extern jobject create_value(JNIEnv *env, mrb_value const &value);
//extern mrb_value *create_mrb_value_array(JNIEnv *env, int const &num, jobjectArray array);

extern bool rubyval_to_ulong(mrb_state* mrb , mrb_value arg, unsigned long* outValue, const char* funcName="");
extern bool rubyval_to_ushort(mrb_state* mrb, mrb_value arg, unsigned short* outValue, const char* funcName = "");
extern bool rubyval_to_int32(mrb_state* mrb, mrb_value arg, int* outValue, const char* funcName = "");
extern bool rubyval_to_uint32(mrb_state* mrb, mrb_value arg, unsigned int* outValue, const char* funcName = "");
extern bool rubyval_to_uint16(mrb_state* mrb, mrb_value arg, uint16_t* outValue, const char* funcName = "");
extern bool rubyval_to_boolean(mrb_state* mrb, mrb_value arg, bool* outValue, const char* funcName = "");
extern bool rubyval_to_number(mrb_state* mrb, mrb_value arg, double* outValue, const char* funcName = "");
extern bool rubyval_to_long_long(mrb_state* mrb, mrb_value arg, long long* outValue, const char* funcName = "");
extern bool rubyval_to_std_string(mrb_state* mrb, mrb_value arg, std::string* outValue, const char* funcName = "");
extern bool rubyval_to_long(mrb_state* mrb, mrb_value arg, long* outValue, const char* funcName = "");
extern bool rubyval_to_ssize(mrb_state* mrb, mrb_value arg, ssize_t* outValue, const char* funcName = "");
//extern bool rubyval_to_array(mrb_state* mrb, mrb_value arg, __Array** outValue, const char* funcName = "");
//extern bool rubyval_to_dictionary(mrb_state* mrb, mrb_value arg, __Dictionary** outValue, const char* funcName = "");



struct jobject_data {
  JNIEnv *env;
  jobject gref_jobj;
};

static void jobject_free(mrb_state *mrb, void *ptr)
{
    if (NULL != ptr) {
        jobject_data *p = static_cast<jobject_data*>(ptr);
        p->env->DeleteGlobalRef(p->gref_jobj);
        p->env = NULL;
        p->gref_jobj = NULL;
    }
    mrb_free(mrb, ptr);
}

static struct mrb_data_type jobject_type = { JOBJECT_CLASS_NAME, jobject_free };

struct jclass_data {
  JNIEnv *env;
  jclass gref_jclass;
};

static void jcls_free(mrb_state *mrb, void *ptr)
{
  if (NULL != ptr) {
    jclass_data *p = static_cast<jclass_data*>(ptr);
    p->env->DeleteGlobalRef(p->gref_jclass);
    p->env = NULL;
    p->gref_jclass = NULL;
  }
  mrb_free(mrb, ptr);
}

static struct mrb_data_type jcls_type = { JCLASS_CLASS_NAME, jcls_free };


struct jmethod_data {
  JNIEnv *env;
  jmethodID jmid;
  char *signature;
};

static void jmethod_free(mrb_state *mrb, void *ptr)
{
    if (NULL != ptr) {
        jmethod_data *p = static_cast<jmethod_data*>(ptr);
    free(p->signature);
        p->env = NULL;
        p->jmid = NULL;
    p->signature = NULL;
    }
    mrb_free(mrb, ptr);
}

static struct mrb_data_type jmethod_type = { JMETHOD_CLASS_NAME, jmethod_free };

jobject mrb_value_get_jobject(mrb_state *mrb, mrb_value obj)
{
  jobject_data *data = static_cast<jobject_data*>(mrb_get_datatype(mrb, obj, &jobject_type));
  if (NULL == data) {
    return NULL;
  }
  return data->gref_jobj;
}


static bool mrb_value_is_jobject(mrb_state *mrb, mrb_value obj)
{
  jobject_data *data = static_cast<jobject_data*>(mrb_get_datatype(mrb, obj, &jobject_type));
  return NULL == data ? false : true;
}


bool convert_mrb_value_to_jvalue(mrb_state *mrb, JNIEnv *env, mrb_value rval, jvalue &jval, jni_type_t const &type)
{
  switch(mrb_type(rval)) {
  case MRB_TT_FALSE:
    if (type.is_array()) {
      if (mrb_nil_p(rval)) {
        jval.l = NULL;
      } else {
        return false;
      }
    }
    switch(type.type_id()) {
    case JNI_TYPE_BOOLEAN:
      jval.z = JNI_FALSE;
      break;
    case JNI_TYPE_OBJECT:

      if (mrb_nil_p(rval)) {
        jval.l = NULL;
      } else {
        return false;
      }
      break;
    default:
      return false;
    }
    break;
  case MRB_TT_TRUE:
    switch(type.type_id()) {
    case JNI_TYPE_BOOLEAN:
      jval.z = JNI_TRUE;
      break;
    default:
      return false;
    }
    break;
  case MRB_TT_FIXNUM:
    switch(type.type_id()) {
    case JNI_TYPE_BYTE:
      jval.b = static_cast<jbyte>(mrb_fixnum(rval));
      break;
    case JNI_TYPE_CHAR:
      jval.c = static_cast<jchar>(mrb_fixnum(rval));
      break;
    case JNI_TYPE_SHORT:
      jval.s = static_cast<jshort>(mrb_fixnum(rval));
      break;
    case JNI_TYPE_INT:
      jval.i = mrb_fixnum(rval);
      break;
    case JNI_TYPE_LONG:
      jval.j = mrb_fixnum(rval);
      break;
    case JNI_TYPE_FLOAT:
      jval.f = static_cast<jfloat>(mrb_fixnum(rval));
      break;
    case JNI_TYPE_DOUBLE:
      jval.d = static_cast<jdouble>(mrb_fixnum(rval));
      break;
    default:
      return false;
    }
    break;
  case MRB_TT_FLOAT:
    switch(type.type_id()) {
    case JNI_TYPE_FLOAT:
      jval.f = static_cast<jfloat>(mrb_float(rval));
      break;
    case JNI_TYPE_DOUBLE:
      jval.d = mrb_float(rval);
      break;
    default:
      return false;
    }
    break;
  case MRB_TT_STRING:
    switch(type.type_id()) {
    case JNI_TYPE_OBJECT:
    {
      // TODO validate Java object type.
      jval.l = env->NewStringUTF(mrb_string_value_ptr(mrb, rval));
      break;
    }
    default:
      return false;
    }
    break;
  case MRB_TT_DATA:
    switch(type.type_id()) {
    case JNI_TYPE_OBJECT:
      if (!mrb_value_is_jobject(mrb, rval)) {
        return false;
      }
      jval.l = mrb_value_get_jobject(mrb, rval);
      break;
    default:
      return false;
    }
    break;
  default:
    {
          mrb_raise(mrb,E_RUNTIME_ERROR,"convert_mrb_value_to_jvalue");
          return false;
   // jval.l = create_value(env, rval);
    }
    break;
  }
  return true;
}

static mrb_value jobject_2_mrb_value(mrb_state *mrb, JNIEnv *env, jobject obj)
{
  struct RClass* jre_module = mrb_module_get(mrb, JRE_MODULE_NAME);
  RClass *c = mrb_class_get_under(mrb,jre_module, JOBJECT_CLASS_NAME);
  if (NULL == c) {
    return mrb_nil_value();
  }
  jobject_data *ptr = static_cast<jobject_data*>(mrb_malloc(mrb, sizeof(jobject_data)));
  if (NULL == ptr) {
    mrb_raise(mrb,E_RUNTIME_ERROR,"mrb_malloc error for a jobject");
    return mrb_nil_value();
  }
  ptr->env = env;
  ptr->gref_jobj = env->NewGlobalRef(obj);
  return mrb_obj_value(Data_Wrap_Struct(mrb, c, &jobject_type, ptr));
}

static mrb_value jclass_2_mrb_value(mrb_state *mrb, JNIEnv *env, jclass cls)
{
  struct RClass* jre_module = mrb_module_get(mrb, JRE_MODULE_NAME);
  RClass *c = mrb_class_get_under(mrb,jre_module, JCLASS_CLASS_NAME);
  if (NULL == c) {
    return mrb_nil_value();
  }
  jclass_data *ptr = static_cast<jclass_data*>(mrb_malloc(mrb, sizeof(jclass_data)));
  if (NULL == ptr) {
    mrb_raise(mrb,E_RUNTIME_ERROR,"mrb_malloc error a jclass");
    return mrb_nil_value();
  }
  ptr->env = env;
  ptr->gref_jclass = static_cast<jclass>(env->NewGlobalRef(cls));
  return mrb_obj_value(Data_Wrap_Struct(mrb, c, &jcls_type, ptr));
}

mrb_value jmethod_2_mrb_value(mrb_state *mrb, JNIEnv *env, jmethodID jmid, char const * const sig)
{
 
  struct RClass* jre_module = mrb_module_get(mrb, JRE_MODULE_NAME);
  RClass *c = mrb_class_get_under(mrb,jre_module, JMETHOD_CLASS_NAME);
  if (NULL == c) {
    return mrb_nil_value();
  }
  jmethod_data *ptr = static_cast<jmethod_data*>(mrb_malloc(mrb, sizeof(jmethod_data)));
  if (NULL == ptr) {
    mrb_raise(mrb,E_RUNTIME_ERROR,"mrb_malloc error a jmethod");
    return mrb_nil_value();
  }
  char * const dup = strdup(sig);
  if (NULL == dup) {
    mrb_free(mrb, ptr);
    ptr = NULL;
    return mrb_nil_value();
  }
  ptr->env = env;
  ptr->jmid = jmid;
  ptr->signature = dup;
  return mrb_obj_value(Data_Wrap_Struct(mrb, c, &jmethod_type, ptr));
}



mrb_value convert_jvalue_to_mrb_value(mrb_state *mrb, JNIEnv *env, jni_type_t const &type, jvalue const &ret)
{
  if (type.is_array()) {
    safe_jni::safe_local_ref<jobject> retval(env, ret.l);
    return (NULL == ret.l) ? mrb_nil_value() : jobject_2_mrb_value(mrb, env, retval.get());
  } else {
    switch(type.type_id()) {
    case JNI_TYPE_VOID:
      return mrb_nil_value();
    case JNI_TYPE_BOOLEAN:
      return (ret.z != JNI_FALSE) ? mrb_true_value() : mrb_false_value();
    case JNI_TYPE_BYTE:
      return mrb_fixnum_value(ret.b);
    case JNI_TYPE_CHAR:
      return mrb_fixnum_value(ret.c);
    case JNI_TYPE_SHORT:
      return mrb_fixnum_value(ret.s);
    case JNI_TYPE_INT:
      return mrb_fixnum_value(ret.i);
    case JNI_TYPE_LONG:
      return mrb_fixnum_value((int32_t)ret.j); // TODO if 'Bignum' is supported by mruby, modify this code.
    case JNI_TYPE_FLOAT:
      return mrb_float_value(mrb, ret.f);
    case JNI_TYPE_DOUBLE:
#ifdef MRB_USE_FLOAT
      return mrb_float_value((float)ret.d);
#else
      return mrb_float_value(mrb, ret.d);
#endif
    case JNI_TYPE_OBJECT:
    {
      if (NULL == ret.l) {
        return mrb_nil_value();
      }

      std::string const &name = type.name();

      j2m_converter_map_t::const_iterator it = j2m_converters.find(name);
      if (it == j2m_converters.end()) {
        return Object_to_mrb(mrb, env, ret.l, name);
      } else {
        return it->second(mrb, env, ret.l, name);
      }
    }
    default:
      return mrb_nil_value();
    }
  }
}

jni_type_t get_return_type(mrb_state * mrb,char const * const signature)
{
  char const *p = strchr(signature, ')');
  if (NULL == p) {
    mrb_raisef(mrb,E_RUNTIME_ERROR,"%s: Invalid signature format.", __func__);
    return jni_type_t();
  }

  jni_type_id_t tid = JNI_TYPE_UNKNOWN;
  bool is_array = false;
  std::string name;
  do {
    switch(*p++) {
    case 'L':
      {
        char *next = strchr(p, ';');
        if (NULL == next) {
          return jni_type_t();
        }
        name.assign(p, next - p);
        p = ++next;
        tid = JNI_TYPE_OBJECT;
      }
      break;
    case 'V':
      tid = JNI_TYPE_VOID;
      break;
    case 'Z':
      tid = JNI_TYPE_BOOLEAN;
      break;
    case 'B':
      tid = JNI_TYPE_BYTE;
      break;
    case 'C':
      tid = JNI_TYPE_CHAR;
      break;
    case 'S':
      tid = JNI_TYPE_SHORT;
      break;
    case 'I':
      tid = JNI_TYPE_INT;
      break;
    case 'J':
      tid = JNI_TYPE_LONG;
      break;
    case 'F':
      tid = JNI_TYPE_FLOAT;
      break;
    case 'D':
      tid = JNI_TYPE_DOUBLE;
      break;
    case '[':
      is_array = true;
      break;
    }
  } while(tid == JNI_TYPE_UNKNOWN);

  return name.empty() ? jni_type_t(tid, is_array) : jni_type_t(is_array, name.c_str());
}

bool get_argument_types(mrb_state *mrb, char const * const signature, jni_type_t *types, int num)
{
  char const *p = strchr(signature, '(');
  if (NULL == p) {
    mrb_raisef(mrb,E_RUNTIME_ERROR,"%s: Invalid signature format.", __func__);
    return false;
  }

  for (int i = 0; i < num; ++i) {
    jni_type_id_t tid = JNI_TYPE_UNKNOWN;
    bool is_array = false;
    char const *name = NULL;
    size_t name_len = 0;
    char *separator;
    do {
      switch(*p++) {
      case 'L':
        tid = JNI_TYPE_OBJECT;
        separator = strchr(p, ';');
        if (NULL == separator) {
          return false;
        }
        name = p;
        name_len = separator - p;
        p = separator + 1;
        break;
      case 'V':
        tid = JNI_TYPE_VOID;
        break;
      case 'Z':
        tid = JNI_TYPE_BOOLEAN;
        break;
      case 'B':
        tid = JNI_TYPE_BYTE;
        break;
      case 'C':
        tid = JNI_TYPE_CHAR;
        break;
      case 'S':
        tid = JNI_TYPE_SHORT;
        break;
      case 'I':
        tid = JNI_TYPE_INT;
        break;
      case 'J':
        tid = JNI_TYPE_LONG;
        break;
      case 'F':
        tid = JNI_TYPE_FLOAT;
        break;
      case 'D':
        tid = JNI_TYPE_DOUBLE;
        break;
      case '[':
        is_array = true;
        break;
      case '\0':
      case ')':
        return false;
      }
    } while(tid == JNI_TYPE_UNKNOWN);
    types[i].type_id(tid, is_array);
    if (tid == JNI_TYPE_OBJECT) {
      types[i].name(std::string(name, name_len));
    }
  }

  return true;
}

int get_count_of_arguments(mrb_state * mrb,char const * const signature)
{
  char const *p = strchr(signature, '(');
  if (NULL == p) {
    mrb_raisef(mrb,E_RUNTIME_ERROR,"%s: Invalid signature format '%s'.", __func__, signature);
    return false;
  }

  int ret = 0;
  bool is_end = false;
  while(!is_end) {
    switch(*++p) {
    case 'L':
      p = strchr(p, ';');
      if (NULL == p) {
        mrb_raisef(mrb,E_RUNTIME_ERROR,"%s: Invalid signature format '%s'.", __func__, signature);
        return -1;
      }
      // fall through
    case 'V':
    case 'Z':
    case 'B':
    case 'C':
    case 'S':
    case 'I':
    case 'J':
    case 'F':
    case 'D':
      ++ret;
      break;
    case '[':
      break;
    case ')':
      is_end = true;
      break;
    default:
      mrb_raisef(mrb,E_RUNTIME_ERROR,"%s: Invalid signature format '%c:%02x' in '%s'.", __func__, *p, *p, signature);
      return -1;
    }
  }

  return ret;
}

bool is_mrb_value_convertible_to(mrb_state *mrb, mrb_value value, jni_type_t const &type)
{
  if (mrb_nil_p(value)) {
    if (type.is_array()) {
      return true;
    }
    if (JNI_TYPE_OBJECT == type.type_id()) {
      return true;
    }
    return false;
  }

  mrb_vtype const vtype = mrb_type(value);

  switch (vtype) {
  case MRB_TT_FALSE:
  case MRB_TT_TRUE:
    if (JNI_TYPE_BOOLEAN == type.type_id()) {
      return true;
    }
    return false;
  case MRB_TT_FIXNUM:
    switch (type.type_id()) {
    case JNI_TYPE_BYTE:
    case JNI_TYPE_CHAR:
    case JNI_TYPE_SHORT:
    case JNI_TYPE_INT:
    case JNI_TYPE_LONG:
    case JNI_TYPE_FLOAT:
    case JNI_TYPE_DOUBLE:
      return true;
    }
    return false;
  case MRB_TT_FLOAT:
    switch (type.type_id()) {
    case JNI_TYPE_FLOAT:
      return true;
    case JNI_TYPE_DOUBLE:
      return true;
    }
    return false;
  case MRB_TT_STRING:
    if (JNI_TYPE_OBJECT != type.type_id()) {
      return false;
    }
    if (type.name() == "java/lang/String") {
      return true;
    }
    return false;
  case MRB_TT_DATA:
  case MRB_TT_OBJECT:
    if (JNI_TYPE_OBJECT != type.type_id()) {
      return false;
    }
    if (!mrb_value_is_jobject(mrb, value)) {
      return true;
    }
    return false;
  default:
    return false;
  }
}

static mrb_value Boolean_to_mrb(mrb_state *mrb, JNIEnv *env, jobject value, std::string const &type_name)
{
  safe_jni::method<bool> boolean_value(env, value, "booleanValue", "()Z");
  return boolean_value(value) ? mrb_true_value() : mrb_false_value();
}

static mrb_value Character_to_mrb(mrb_state *mrb, JNIEnv *env, jobject value, std::string const &type_name)
{
  safe_jni::method<uint16_t> char_value(env, value, "charValue", "()C");
  return mrb_fixnum_value(char_value(value));
}

static mrb_value Byte_to_mrb(mrb_state *mrb, JNIEnv *env, jobject value, std::string const &type_name)
{
  safe_jni::method<int8_t> int_value(env, value, "intValue", "()I");
  return mrb_fixnum_value(int_value(value));
}

static mrb_value Short_to_mrb(mrb_state *mrb, JNIEnv *env, jobject value, std::string const &type_name)
{
  safe_jni::method<int16_t> int_value(env, value, "intValue", "()I");
  return mrb_fixnum_value(int_value(value));
}

static mrb_value Integer_to_mrb(mrb_state *mrb, JNIEnv *env, jobject value, std::string const &type_name)
{
  safe_jni::method<int32_t> int_value(env, value, "intValue", "()I");
  return mrb_fixnum_value(int_value(value));
}

static mrb_value Long_to_mrb(mrb_state *mrb, JNIEnv *env, jobject value, std::string const &type_name)
{
  mrb_raise(mrb, E_RUNTIME_ERROR, "not implemented conversion fromn 'java/lang/Long' to mruby value.");
  return mrb_nil_value();
}

static mrb_value Double_to_mrb(mrb_state *mrb, JNIEnv *env, jobject value, std::string const &type_name)
{
  safe_jni::method<double> double_value(env, value, "doubleValue", "()D");
#ifdef MRB_USE_FLOAT
  return mrb_float_value(mrb, (float)double_value(value));
#else
  return mrb_float_value(mrb, double_value(value));
#endif
}

static mrb_value Float_to_mrb(mrb_state *mrb, JNIEnv *env, jobject value, std::string const &type_name)
{
  safe_jni::method<float> float_value(env, value, "floatValue", "()F");
  return mrb_float_value(mrb, float_value(value));
}

static mrb_value Object_to_mrb(mrb_state *mrb, JNIEnv *env, jobject value, std::string const &type_name)
{
  safe_jni::safe_local_ref<jobject> retval(env, value);
  return (NULL == value) ? mrb_nil_value() : jobject_2_mrb_value(mrb, env, retval.get());
}

static mrb_value String_to_mrb(mrb_state *mrb, JNIEnv *env, jobject value, std::string const &type_name)
{
  safe_jni::safe_string str(env, static_cast<jstring>(value));
  return mrb_str_new_cstr(mrb, str.string());
}



void throw_exception(JNIEnv *env, char const *name, char const *message)
{
  safe_jni::safe_local_ref<jclass> clazz(env, env->FindClass(name));
  if (!clazz) {
    return;
  }
  env->ThrowNew(clazz.get(), message);
}






static mrb_value mrb_jre_get_class_static(mrb_state* mrb, mrb_value self){
    mrb_value* argv;
    int argc;
    mrb_get_args(mrb, "*", &argv, &argc);

    bool ok = true;
    do {
        if (argc == 1) {
             JNIEnv* env = cocos2d::JniHelper::getEnv();
             if(NULL==env){
                mrb_raise(mrb,E_RUNTIME_ERROR,"can't getEnv from JniHelper");
                return mrb_nil_value();
             }

        
          std::string className; 
          ok = rubyval_to_std_string(mrb, argv[0], &className, "JRE::get_class"); 
          if (!ok) { break; }

          jstring _jstrClassName = env->NewStringUTF(className.c_str());

        jclass _clazz = (jclass) env->CallObjectMethod(cocos2d::JniHelper::classloader,
                                                   cocos2d::JniHelper::loadclassMethod_methodID,
                                                   _jstrClassName);

        
        env->DeleteLocalRef(_jstrClassName);

        if (NULL == _clazz) {
            env->ExceptionClear();
            mrb_raisef(mrb, E_RUNTIME_ERROR, "can not find jclass %s", className.c_str());
            return mrb_nil_value();
          }
          env->ExceptionClear();
          safe_jni::safe_local_ref<jclass> cls(env, _clazz);
          return jclass_2_mrb_value(mrb, env, cls.get());
        }
    }while (0);

   mrb_raise(mrb, E_RUNTIME_ERROR, "expect JRE::get_class(string class_name) ");
   return mrb_nil_value();
}

static mrb_value  mrb_jre_object_get_class_static(mrb_state* mrb, mrb_value self){
  do{
       jobject_data *data = static_cast<jobject_data*>(mrb_get_datatype(mrb, self, &jobject_type));
      JNIEnv *env = data->env;
      if(NULL==env){
          mrb_raise(mrb,E_RUNTIME_ERROR,"can't getEnv from JniHelper");
          return mrb_nil_value();
       }

     jclass _clazz =env->GetObjectClass(data->gref_jobj);
     if( NULL==_clazz){
          mrb_raise(mrb,E_RUNTIME_ERROR,"JRE::JObject can not GetObjectClass");
          return mrb_nil_value();
     }
     env->ExceptionClear();
     safe_jni::safe_local_ref<jclass> cls(env, _clazz);
     return jclass_2_mrb_value(mrb, env, cls.get());
  }  while(0);

  return mrb_nil_value();
}

static mrb_value mrb_jre_object_get_method(mrb_state* mrb, mrb_value self){
    mrb_value name, signature;
    int const argc = mrb_get_args(mrb, "SS", &name, &signature);
    if (2 != argc) {
      mrb_raise(mrb,E_RUNTIME_ERROR,"JRE::JClass.get_method expect args (string methodname,string signature)");
      return mrb_nil_value();
    }
    bool ok = true;

   

    std::string str_signature; 
    ok = rubyval_to_std_string(mrb, signature, &str_signature, "JRE::JClass.get_method"); 
    if (!ok) {  
      mrb_raise(mrb,E_RUNTIME_ERROR,"JRE::JClass.get_method ");
      return mrb_nil_value(); 
    }
    std::string str_name; 
    ok = rubyval_to_std_string(mrb, name, &str_name, "JRE::JClass.get_method"); 
    if (!ok) {  
      mrb_raise(mrb,E_RUNTIME_ERROR,"JRE::JClass.get_method ");
      return mrb_nil_value(); 
    }
   
   jobject_data *obj_data = static_cast<jobject_data*>(mrb_get_datatype(mrb, self, &jobject_type));
   jobject obj= obj_data->gref_jobj   ;
   JNIEnv *env = obj_data->env;
   
   safe_jni::safe_local_ref<jclass> safe_clazz(env, env->GetObjectClass(obj));
   if (NULL == safe_clazz){ 
      mrb_raise(mrb,E_RUNTIME_ERROR,"can not find class for object ");  
      return mrb_nil_value();
    }
   jclass clazz=safe_clazz.get();
   if (NULL == safe_clazz){ 
      mrb_raise(mrb,E_RUNTIME_ERROR,"can not find jclass for object !");  
      return mrb_nil_value();
    }



    char const * const sig = str_signature.c_str();
    jmethodID jmid = env->GetMethodID(clazz, str_name.c_str(), sig);
    if (NULL == jmid) {
      env->ExceptionClear();
      return mrb_nil_value();
    }
    return jmethod_2_mrb_value(mrb, env, jmid, sig);

}


static mrb_value mrb_jre_class_get_method(mrb_state* mrb, mrb_value self){
    mrb_value name, signature;
    int const argc = mrb_get_args(mrb, "SS", &name, &signature);
    if (2 != argc) {
      mrb_raise(mrb,E_RUNTIME_ERROR,"JRE::JClass.get_method expect args (string methodname,string signature)");
      return mrb_nil_value();
    }
    bool ok = true;
    jclass_data *data = static_cast<jclass_data*>(mrb_get_datatype(mrb, self, &jcls_type));
    JNIEnv *env = data->env;
    if(NULL==env){
        mrb_raise(mrb,E_RUNTIME_ERROR,"can't getEnv from JniHelper");
        return mrb_nil_value(); 
    }
   

    std::string str_signature; 
    ok = rubyval_to_std_string(mrb, signature, &str_signature, "JRE::JClass.get_method"); 
    if (!ok) {  
      mrb_raise(mrb,E_RUNTIME_ERROR,"JRE::JClass.get_method ");
      return mrb_nil_value(); 
    }
    std::string str_name; 
    ok = rubyval_to_std_string(mrb, name, &str_name, "JRE::JClass.get_method"); 
    if (!ok) {  
      mrb_raise(mrb,E_RUNTIME_ERROR,"JRE::JClass.get_method ");
      return mrb_nil_value(); 
    }

    char const * const sig = str_signature.c_str();
    jmethodID jmid = env->GetStaticMethodID(data->gref_jclass, str_name.c_str(), sig);
    if (NULL == jmid) {
      env->ExceptionClear();
      return mrb_nil_value();
    }
    return jmethod_2_mrb_value(mrb, env, jmid, sig);

}

void init_mrb_jre_converters()
{
  if (0 != j2m_converters.size()) {
    return;
  }
  j2m_converters.insert(j2m_converter_map_t::value_type("java/lang/Boolean",   Boolean_to_mrb));
  j2m_converters.insert(j2m_converter_map_t::value_type("java/lang/Character", Character_to_mrb));
  j2m_converters.insert(j2m_converter_map_t::value_type("java/lang/Byte",      Byte_to_mrb));
  j2m_converters.insert(j2m_converter_map_t::value_type("java/lang/Short",     Short_to_mrb));
  j2m_converters.insert(j2m_converter_map_t::value_type("java/lang/Integer",   Integer_to_mrb));
  j2m_converters.insert(j2m_converter_map_t::value_type("java/lang/Long",      Long_to_mrb));
  j2m_converters.insert(j2m_converter_map_t::value_type("java/lang/Double",    Double_to_mrb));
  j2m_converters.insert(j2m_converter_map_t::value_type("java/lang/Float",     Float_to_mrb));
  j2m_converters.insert(j2m_converter_map_t::value_type("java/lang/Object",    Object_to_mrb));
  j2m_converters.insert(j2m_converter_map_t::value_type("java/lang/String",    String_to_mrb));
}



char *get_message_from_jthrowable(JNIEnv *env, jthrowable e)
{
  safe_jni::safe_local_ref<jclass> cls(env, env->GetObjectClass(e));
  if (cls.get()) {
    jmethodID mid = env->GetMethodID(cls.get(), "getMessage", "()Ljava/lang/String;");
    if (NULL != mid) {
      safe_jni::safe_local_ref<jstring> str(env, static_cast<jstring>(env->CallObjectMethod(e, mid)));
      safe_jni::safe_string msg_str(env, str.get());
      return strdup(msg_str.string());
    }
  }
  return NULL;
}

jobject new_jobject_instance(mrb_state *mrb, JNIEnv *env, jclass jcls, jmethodID jmid, jvalue* args)
{   
  jobject new_obj = env->NewObjectA(jcls, jmid, args);
  safe_jni::safe_local_ref<jthrowable> e(env, env->ExceptionOccurred());
  if (NULL != e) {
    env->ExceptionClear();
    char *msg = get_message_from_jthrowable(env, e.get());
    mrb_raisef(mrb,E_RUNTIME_ERROR,"new_jobject_instance %s",msg);
  }
  return new_obj;
}


template <typename JType> static jvalue call_method(mrb_state *mrb, JNIEnv *env, jni_type_t const &type, JType obj, jmethodID jmid, jvalue* args)
{
  jvalue const &ret = jni_functor<JType>(env)(type, obj, jmid, args);
  safe_jni::safe_local_ref<jthrowable> e(env, env->ExceptionOccurred());
  if (NULL != e) {
      env->ExceptionClear();
      char *msg = get_message_from_jthrowable(env, e.get());
      LOGE("call method Error %s",msg);
      env->ExceptionClear();
      mrb_raisef(mrb,E_RUNTIME_ERROR,"call method Error %s",msg);
  }
  return ret;
}

static mrb_value mrb_jre_object_call(mrb_state *mrb, mrb_value self){

   mrb_value rb_jmthd;
   int rb_argc;
   mrb_value *rb_argv;

   int const argc = mrb_get_args(mrb, "o*", &rb_jmthd, &rb_argv, &rb_argc);

   if (argc < 1) {
     mrb_raise(mrb,E_RUNTIME_ERROR,"first args must be a JRE::JMethod");
     return mrb_nil_value();
   }


    jmethod_data* jmd_data = static_cast<jmethod_data*>(mrb_get_datatype(mrb, rb_jmthd, &jmethod_type));
    if(NULL== jmd_data){
        mrb_raise(mrb,E_RUNTIME_ERROR,"first args must be a JRE::JMethod");
        return mrb_nil_value();
    }
    //验证第一下参数  //signature jmid
    jmethodID  jmid= jmd_data->jmid;
    char * signature=jmd_data->signature;
    if(NULL== signature  || NULL == jmid ){
        mrb_raise(mrb,E_RUNTIME_ERROR,"first args must be a JRE::JMethod");
        return mrb_nil_value();
    }



    jobject_data *obj_data = static_cast<jobject_data*>(mrb_get_datatype(mrb, self, &jobject_type));
    jobject obj= obj_data->gref_jobj   ;
   JNIEnv *env = obj_data->env;
   
   safe_jni::safe_local_ref<jclass> safe_clazz(env, env->GetObjectClass(obj));
   if (NULL == safe_clazz){ 
      mrb_raise(mrb,E_RUNTIME_ERROR,"can not find class for object ");  
      return mrb_nil_value();
    }
   jclass clazz=safe_clazz.get();
   if (NULL == safe_clazz){ 
      mrb_raise(mrb,E_RUNTIME_ERROR,"can not find jclass for object !");  
      return mrb_nil_value();
    }

   std::vector<jvalue> jvals(rb_argc);
  if (static_cast<std::size_t>(rb_argc) > jvals.size()) {
    mrb_raise(mrb,E_RUNTIME_ERROR,"memory error.");
    return mrb_nil_value();
  }

  std::vector<jni_type_t> types(rb_argc);
  if (static_cast<std::size_t>(rb_argc) > types.size()) {
     mrb_raise(mrb,E_RUNTIME_ERROR,"memory error.");
    return mrb_nil_value();
  }
  
  if (!get_argument_types(mrb, signature, &types[0], rb_argc)) {
    mrb_raise(mrb,E_RUNTIME_ERROR,"memory error.");
    return mrb_nil_value();
  }

  for (int i = 0; i < rb_argc; ++i) {
        bool converted=convert_mrb_value_to_jvalue(mrb, env, rb_argv[i], jvals[i], types[i]);
    if (!converted){
       mrb_raisef(mrb,E_RUNTIME_ERROR," convert arg:%d  expect  %s convert %d",i ,types[i].name().c_str(),converted);
    }
  }
  jni_type_t const ret_type =  get_return_type(mrb, signature);
  jvalue const &ret = call_method(mrb, env, ret_type, obj, jmid, &jvals[0]); 
  return convert_jvalue_to_mrb_value(mrb, env, ret_type, ret);

}

static mrb_value mrb_jre_object_to_string(mrb_state *mrb, mrb_value self){
    jobject_data *obj_data = static_cast<jobject_data*>(mrb_get_datatype(mrb, self, &jobject_type));
    jobject obj= obj_data->gref_jobj   ;
   JNIEnv *env = obj_data->env;
   
   safe_jni::safe_local_ref<jclass> safe_clazz(env, env->GetObjectClass(obj));
   if (NULL == safe_clazz){ 
      mrb_raise(mrb,E_RUNTIME_ERROR,"can not find class for object ");  
      return mrb_nil_value();
    }
   jclass clazz=safe_clazz.get();
   if (NULL == safe_clazz){ 
      mrb_raise(mrb,E_RUNTIME_ERROR,"can not find jclass for object !");  
      return mrb_nil_value();
    }
  
   const char * signature="()Ljava/lang/String;";
   jmethodID jmid = env->GetMethodID(clazz, "toString", signature);

    if( NULL == jmid ){
        mrb_raise(mrb,E_RUNTIME_ERROR,"can not find toString method");
        return mrb_nil_value();
    }

    std::vector<jvalue> jvals(0);
    std::vector<jni_type_t> types(0);

    jni_type_t const ret_type =  get_return_type(mrb, signature);
    jvalue const &ret = call_method(mrb, env, ret_type, obj, jmid, &jvals[0]); 
    return convert_jvalue_to_mrb_value(mrb, env, ret_type, ret);
}

static mrb_value mrb_jre_class_new_instance(mrb_state *mrb, mrb_value self){
  mrb_value jmthd;
  int rb_argc;
  mrb_value *rb_argv;
  mrb_value init_sig;
  bool ok = true;


   jclass_data *cls_data = static_cast<jclass_data*>(mrb_get_datatype(mrb, self, &jcls_type));
   if(NULL==cls_data){
      mrb_raise(mrb,E_RUNTIME_ERROR,"self must be a JRE:JClass");
   }

   jclass clazz=cls_data->gref_jclass;

     //检查运行环境
    JNIEnv *env = cls_data->env;
    if(NULL==env){
        mrb_raise(mrb,E_RUNTIME_ERROR,"can't getEnv from JniHelper");
        return mrb_nil_value(); 
    }


     int const argc = mrb_get_args(mrb, "S*", &init_sig , &rb_argv, &rb_argc);
   if (argc < 1) {
     mrb_raise(mrb,E_RUNTIME_ERROR,"first args must be a JRE::JMethod");
     return mrb_nil_value();
   }


    std::string str_signature; 
    ok = rubyval_to_std_string(mrb, init_sig, &str_signature, "JRE::JClass#new_instance"); 
    if (!ok) {  
      mrb_raise(mrb,E_RUNTIME_ERROR,"JRE::JClass#new_instance ");
      return mrb_nil_value(); 
    }
    const char * init_name="<init>"; 
    char const * const sig = str_signature.c_str();
    jmethodID jmid = env->GetMethodID(clazz, init_name, sig);
   

  std::vector<jvalue> jvals(rb_argc);
  if (static_cast<std::size_t>(rb_argc) > jvals.size()) {
    mrb_raise(mrb,E_RUNTIME_ERROR,"can not init a vector in JRE::JClass#new_instance");  
    return mrb_nil_value();
  }


  std::vector<jni_type_t> types(rb_argc);
   if (static_cast<std::size_t>(rb_argc) > types.size()) {
    mrb_raise(mrb,E_RUNTIME_ERROR,"can not init a vector in JRE::JClass#new_instance");  
    return mrb_nil_value();
  }
  
  if (!get_argument_types(mrb, sig, &types[0], rb_argc)) {
    mrb_raisef(mrb,E_RUNTIME_ERROR,"can not match args  in JRE::JClass#new_instance expect %s",sig); 
    return mrb_nil_value();
  }

  for (int i = 0; i < rb_argc; i++) {
    bool converted=convert_mrb_value_to_jvalue(mrb, env, rb_argv[i], jvals[i], types[i]);
   if (!converted){
    mrb_raisef(mrb,E_RUNTIME_ERROR," convert arg:%d  expect  %s convert %d",i ,types[i].name().c_str(),converted);
    }
  }

  jobject obj = new_jobject_instance(mrb, env, clazz, jmid, &jvals[0]);

  jobject_data *ptr = static_cast<jobject_data*>(mrb_malloc(mrb, sizeof(jobject_data)));
  if (NULL == ptr) {
     mrb_raise(mrb,E_RUNTIME_ERROR,"mrb_malloc  jobject_data error");
    return mrb_nil_value();

  }
  ptr->env = env;
  ptr->gref_jobj = env->NewGlobalRef(obj);


  struct RClass* jre_module = mrb_module_get(mrb, JRE_MODULE_NAME);
  RClass *cls = mrb_class_get_under(mrb,jre_module, JOBJECT_CLASS_NAME);
  return mrb_obj_value(Data_Wrap_Struct(mrb, cls, &jobject_type, ptr));
}

static mrb_value mrb_jre_class_call_static(mrb_state *mrb, mrb_value self){
   mrb_value jmthd;
   int rb_argc;
   mrb_value *rb_argv;
    //检查class
   jclass_data *cls_data = static_cast<jclass_data*>(mrb_get_datatype(mrb, self, &jcls_type));
   if(NULL==cls_data){
      mrb_raise(mrb,E_RUNTIME_ERROR,"self must be a JRE:JClass");
   }
   jclass clazz=cls_data->gref_jclass;
     //检查运行环境
    JNIEnv *env = cls_data->env;
    if(NULL==env){
        mrb_raise(mrb,E_RUNTIME_ERROR,"can't getEnv from JniHelper");
        return mrb_nil_value(); 
    }
  //检查第一个参数，必须是JRE::JMethod
   int const argc = mrb_get_args(mrb, "o*", &jmthd, &rb_argv, &rb_argc);
   if (argc < 1) {
     mrb_raise(mrb,E_RUNTIME_ERROR,"first args must be a JRE::JMethod");
     return mrb_nil_value();
   }
   jmethod_data* mthd_data = static_cast<jmethod_data*>(mrb_get_datatype(mrb, jmthd, &jmethod_type));
  if (NULL == mthd_data) {
    mrb_raise(mrb,E_RUNTIME_ERROR,"first args must be a JRE::JMethod");
    return mrb_nil_value();
  }
  char const * const sig = mthd_data->signature;
  if (NULL == sig) {
    mrb_raise(mrb,E_RUNTIME_ERROR,"JRE::JMethod must have signature");
    return mrb_nil_value();
  }
  jmethodID jmid=mthd_data->jmid;
  if (NULL == jmid) {
    mrb_raise(mrb,E_RUNTIME_ERROR,"JRE::JMethod must have jmid");
    return mrb_nil_value();
  }
  
  //其它的参数
  std::vector<jvalue> jvals(rb_argc);
  if (static_cast<std::size_t>(rb_argc) > jvals.size()) {
    mrb_raise(mrb,E_RUNTIME_ERROR,"can not init a vector in JRE::JClass#call");  
    return mrb_nil_value();
  }
  std::vector<jni_type_t> types(rb_argc);
  if (static_cast<std::size_t>(rb_argc) > types.size()) {
    mrb_raise(mrb,E_RUNTIME_ERROR,"can not init a vector in JRE::JClass#call");  
    return mrb_nil_value();
  }
  if (!get_argument_types(mrb, sig, &types[0], rb_argc)) {
    mrb_raisef(mrb,E_RUNTIME_ERROR,"can not match args  in JRE::JClass#call expect %s",sig); 
    return mrb_nil_value();
  }
 for (int i = 0; i < rb_argc; ++i) {
    bool converted=convert_mrb_value_to_jvalue(mrb, env, rb_argv[i], jvals[i], types[i]);
    if (!converted){
       mrb_raisef(mrb,E_RUNTIME_ERROR," convert arg:%d  expect  %s convert %d",i ,types[i].name().c_str(),converted);
    }
  }
  jni_type_t const ret_type =  get_return_type(mrb, sig);
  jvalue const &ret = call_method(mrb, env, ret_type, clazz, jmid, &jvals[0]); 
  return convert_jvalue_to_mrb_value(mrb, env, ret_type, ret);
}

void register_mruby_jre_module(mrb_state* mrb){
   init_mrb_jre_converters();
   struct RClass* jre_module = mrb_define_module(mrb, JRE_MODULE_NAME);
   mrb_define_class_method(mrb, jre_module, "get_class", mrb_jre_get_class_static, MRB_ARGS_REQ(1));

   struct RClass *jobj_class = mrb_define_class_under(mrb, jre_module, JOBJECT_CLASS_NAME, mrb->object_class);
   MRB_SET_INSTANCE_TT(jobj_class, MRB_TT_DATA);
   mrb_define_method(mrb, jobj_class, "class", mrb_jre_object_get_class_static, ARGS_NONE());
   mrb_define_method(mrb,jobj_class,"call",mrb_jre_object_call,ARGS_REQ(1));
   mrb_define_method(mrb,jobj_class,"to_s",mrb_jre_object_to_string,ARGS_NONE());
   mrb_define_method(mrb,jobj_class,"get_method",mrb_jre_object_get_method,ARGS_REQ(2));

   struct RClass *jcls_class= mrb_define_class_under(mrb,jre_module,JCLASS_CLASS_NAME,mrb->object_class);
   MRB_SET_INSTANCE_TT(jcls_class, MRB_TT_DATA);
   mrb_define_method(mrb,jcls_class,"new_instance",mrb_jre_class_new_instance,ARGS_REQ(1));
   mrb_define_method(mrb, jcls_class, "call", mrb_jre_class_call_static, ARGS_REQ(1));
   mrb_define_method(mrb,jcls_class,"get_method",mrb_jre_class_get_method,ARGS_REQ(2));

   struct RClass *jmethod_class= mrb_define_class_under(mrb,jre_module,JMETHOD_CLASS_NAME,mrb->object_class);
   MRB_SET_INSTANCE_TT(jmethod_class, MRB_TT_DATA);

}


#endif