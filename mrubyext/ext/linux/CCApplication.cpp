/****************************************************************************
Copyright (c) 2011      Laschweinski
Copyright (c) 2013-2014 Chukong Technologies Inc.

http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/

#include "base/CCPlatformConfig.h"
#if CC_TARGET_PLATFORM == CC_PLATFORM_LINUX

#include "CCApplication.h"
#include <unistd.h>
#include <sys/time.h>
#include <string>
#include <typeinfo>
#include "base/CCDirector.h"
#include "platform/CCFileUtils.h"
#include "platform/desktop/CCGLView.h"
#include "mruby.h"

#include "mruby_cocos2dx.h"
NS_CC_BEGIN


// sharedApplication pointer
Application * Application::sm_pSharedApplication = 0;
mrb_state * Application::mrb=0;
std::map<std::string,mrb_data_type *> Application::mrbNameMap;
std::map<void *,mrb_value> Application::mrbObjMap;
	

static long getCurrentMillSecond() {
    long lLastTime;
    struct timeval stCurrentTime;

    gettimeofday(&stCurrentTime,NULL);
    lLastTime = stCurrentTime.tv_sec*1000+stCurrentTime.tv_usec*0.001; //millseconds
    return lLastTime;
}

bool Application::applicationDidFinishLaunching() {
	  const char *fpath=scriptFile.c_str();
	   FILE * file = fopen(fpath, "r");
     mrb_load_file(mrb,file);
    
    // create a scene. it's an autorelease object
    //auto scene = HelloWorld::createScene();

    // run
    //director->runWithScene(scene);
    //printf("applicationDidFinishLaunching\r\n");
    return true;
}
mrb_value& Application::getMrbValue(){
	return self;
}
void Application::applicationDidEnterBackground(){
	mrb_sym sym=mrb_intern_lit(mrb, "@onEnterBackground_proc");
 mrb_bool definedMethod=
 			mrb_obj_iv_defined(mrb,mrb_obj_ptr(self),sym);
 printf("application Did Enter Background\r\n");			
 if(definedMethod){
 		mrb_value  mrbproc=mrb_iv_get(mrb,self,sym);
 		mrb_funcall(mrb,mrbproc,"call",1, self);
 }
}

void Application::applicationWillEnterForeground(){
 mrb_sym sym=mrb_intern_lit(mrb, "@onEnterForeground_proc");
 mrb_bool definedMethod=
 			mrb_obj_iv_defined(mrb,mrb_obj_ptr(self),sym);
 printf("application Will Enter Foreground\r\n");			
 if(definedMethod){
 		mrb_value  mrbproc=mrb_iv_get(mrb,self,sym);
 		mrb_funcall(mrb,mrbproc,"call",1, self);
 }
}

Application::Application(const char *fpath)
: _animationInterval(1.0f/60.0f*1000.0f),
	scriptFile(fpath)
{
    CC_ASSERT(! sm_pSharedApplication);
    sm_pSharedApplication = this;
    mrb =mrb_open();
    mrb_mruby_cocos2dx_gem_init(mrb);
    mrb_data_type *dtype =getMrbType(typeid(*this).name());  //getMrbNameMap()[typeid(*this).name()];
		struct RClass* tc=getCocos2dClass(mrb,dtype->struct_name);
		self=mrb_obj_value(Data_Wrap_Struct(mrb, tc, dtype, NULL));
    DATA_PTR(self)=(void *)this;
    
}
mrb_value * Application::getMrbObj(void * ptr){
	  std::map<void *,mrb_value>::iterator iter=
	     mrbObjMap.find(ptr);
	  if(iter!=mrbObjMap.end()){
	  		return &((*iter).second);
	  }
	  else{
	  		return NULL;
	  }
	  //return &(mrbObjMap[ptr]);
}

void Application::setMrbObj(void * ptr,mrb_value v){
	//enumMap.insert(map<int, CString> :: value_type(2, "Two"))
	std::map<void *,mrb_value>::iterator iter=
	     mrbObjMap.find(ptr);
	  if(iter==mrbObjMap.end()){
			mrbObjMap.insert(std::map<void *,mrb_value>::value_type(ptr,v)); 
		}
}

void Application::removeMrbObj(void * ptr){
std::map<void *,mrb_value>::iterator it=mrbObjMap.find(ptr);
if(it !=mrbObjMap.end()){
	mrbObjMap.erase(it);
	}
}

 mrb_data_type * Application::getMrbType(std::string clsName){
   std::map<std::string,mrb_data_type *>::iterator iter=
	     mrbNameMap.find(clsName);
	  if(iter!=mrbNameMap.end()){
	  	 return (*iter).second;
	  }
	  return NULL;
}
void Application::setMrbType(std::string clsName,mrb_data_type * dtype){
	  std::map<std::string,mrb_data_type *>::iterator iter=
	     mrbNameMap.find(clsName);
	   if(iter==mrbNameMap.end()){
	   	  mrbNameMap.insert(std::map<std::string,mrb_data_type *>::value_type(clsName,dtype)); 
	   }
}
/*
std::map<void *,mrb_value> & Application::getMrbObjMap(){
	return mrbObjMap;
}

std::map<std::string,mrb_data_type *> & Application::getMrbNameMap(){
	return mrbNameMap;
}*/
Application::~Application()
{
    CC_ASSERT(this == sm_pSharedApplication);
    sm_pSharedApplication = NULL;
    mrb_close(mrb);
}

int Application::run()
{
    // Initialize instance and cocos2d.
    if (! applicationDidFinishLaunching())
    {
        return 0;
    }

    long lastTime = 0L;
    long curTime = 0L;

    auto director = Director::getInstance();
    auto glview = director->getOpenGLView();

    // Retain glview to avoid glview being released in the while loop
    glview->retain();

    while (!glview->windowShouldClose())
    {
        lastTime = getCurrentMillSecond();

        director->mainLoop();
        glview->pollEvents();

        curTime = getCurrentMillSecond();
        if (curTime - lastTime < _animationInterval)
        {
            usleep((_animationInterval - curTime + lastTime)*1000);
        }
    }
    /* Only work on Desktop
    *  Director::mainLoop is really one frame logic
    *  when we want to close the window, we should call Director::end();
    *  then call Director::mainLoop to do release of internal resources
    */
    if (glview->isOpenGLReady())
    {
        director->end();
        director->mainLoop();
        director = nullptr;
    }
    glview->release();
    return -1;
}

void Application::setAnimationInterval(double interval)
{
    //TODO do something else
    _animationInterval = interval*1000.0f;
}

void Application::setResourceRootPath(const std::string& rootResDir)
{
    _resourceRootPath = rootResDir;
    if (_resourceRootPath[_resourceRootPath.length() - 1] != '/')
    {
        _resourceRootPath += '/';
    }
    FileUtils* pFileUtils = FileUtils::getInstance();
    std::vector<std::string> searchPaths = pFileUtils->getSearchPaths();
    searchPaths.insert(searchPaths.begin(), _resourceRootPath);
    pFileUtils->setSearchPaths(searchPaths);
}

const std::string& Application::getResourceRootPath(void)
{
    return _resourceRootPath;
}

Application::Platform Application::getTargetPlatform()
{
    return Platform::OS_LINUX;
}

//////////////////////////////////////////////////////////////////////////
// static member function
//////////////////////////////////////////////////////////////////////////
mrb_state * Application::getMrbState(){
    CC_ASSERT(mrb);
    return mrb;
}
Application* Application::getInstance()
{
    CC_ASSERT(sm_pSharedApplication);
    return sm_pSharedApplication;
}

// @deprecated Use getInstance() instead
Application* Application::sharedApplication()
{
    return Application::getInstance();
}

const char * Application::getCurrentLanguageCode()
{
    static char code[3]={0};
    char *pLanguageName = getenv("LANG");
    if (!pLanguageName)
        return "en";
    strtok(pLanguageName, "_");
    if (!pLanguageName)
        return "en";
    strncpy(code,pLanguageName,2);
    code[2]='\0';
    return code;
}

LanguageType Application::getCurrentLanguage()
{
	char *pLanguageName = getenv("LANG");
	LanguageType ret = LanguageType::ENGLISH;
	if (!pLanguageName)
	{
		return LanguageType::ENGLISH;
	}
	strtok(pLanguageName, "_");
	if (!pLanguageName)
	{
		return LanguageType::ENGLISH;
	}
	
	if (0 == strcmp("zh", pLanguageName))
	{
		ret = LanguageType::CHINESE;
	}
	else if (0 == strcmp("en", pLanguageName))
	{
		ret = LanguageType::ENGLISH;
	}
	else if (0 == strcmp("fr", pLanguageName))
	{
		ret = LanguageType::FRENCH;
	}
	else if (0 == strcmp("it", pLanguageName))
	{
		ret = LanguageType::ITALIAN;
	}
	else if (0 == strcmp("de", pLanguageName))
	{
		ret = LanguageType::GERMAN;
	}
	else if (0 == strcmp("es", pLanguageName))
	{
		ret = LanguageType::SPANISH;
	}
	else if (0 == strcmp("nl", pLanguageName))
	{
		ret = LanguageType::DUTCH;
	}
	else if (0 == strcmp("ru", pLanguageName))
	{
		ret = LanguageType::RUSSIAN;
	}
	else if (0 == strcmp("ko", pLanguageName))
	{
		ret = LanguageType::KOREAN;
	}
	else if (0 == strcmp("ja", pLanguageName))
	{
		ret = LanguageType::JAPANESE;
	}
	else if (0 == strcmp("hu", pLanguageName))
	{
		ret = LanguageType::HUNGARIAN;
	}
    else if (0 == strcmp("pt", pLanguageName))
    {
        ret = LanguageType::PORTUGUESE;
    }
    else if (0 == strcmp("ar", pLanguageName))
    {
        ret = LanguageType::ARABIC;
    }
    else if (0 == strcmp("nb", pLanguageName))
    {
        ret = LanguageType::NORWEGIAN;
    }
    else if (0 == strcmp("pl", pLanguageName))
    {
        ret = LanguageType::POLISH;
    }
    
    return ret;
}

NS_CC_END

#endif // CC_TARGET_PLATFORM == CC_PLATFORM_LINUX

