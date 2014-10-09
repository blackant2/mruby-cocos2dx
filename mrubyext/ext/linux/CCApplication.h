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

#ifndef CCAPLICATION_H_
#define CCAPLICATION_H_

#include "base/CCPlatformConfig.h"
#if CC_TARGET_PLATFORM == CC_PLATFORM_LINUX

#include "platform/CCCommon.h"
#include "platform/CCApplicationProtocol.h"
#include <string>
#include "mruby.h"
#include "mruby/data.h"


NS_CC_BEGIN
class Rect;

class Application : public ApplicationProtocol
{
public:
    /**
     * @js ctor
     */
	Application(  const char *fpath);
    /**
     * @js NA
     * @lua NA
     */
	virtual ~Application();

	/**
	 @brief	Callback by Director for limit FPS.
	 @param interval    The time, which expressed in second in second, between current frame and next.
	 */
	void setAnimationInterval(double interval);

	/**
	 @brief	Run the message loop.
	 */
	int run();

	/**
	 @brief	Get current applicaiton instance.
	 @return Current application instance pointer.
	 */
	static Application* getInstance();
	
    /** @deprecated Use getInstance() instead */
    CC_DEPRECATED_ATTRIBUTE static Application* sharedApplication();
    
	/* override functions */
	virtual LanguageType getCurrentLanguage();

	/**
    @brief Get current language iso 639-1 code
    @return Current language iso 639-1 code
    */
    virtual const char * getCurrentLanguageCode();


	/**
     *  Sets the Resource root path.
     *  @deprecated Please use FileUtils::getInstance()->setSearchPaths() instead.
     */
    CC_DEPRECATED_ATTRIBUTE void setResourceRootPath(const std::string& rootResDir);
    
	/** 
     *  Gets the Resource root path.
     *  @deprecated Please use FileUtils::getInstance()->getSearchPaths() instead. 
     */
    CC_DEPRECATED_ATTRIBUTE const std::string& getResourceRootPath(void);
    
    /**
     @brief Get target platform
     */
    virtual Platform getTargetPlatform();
protected:
    long       _animationInterval;  //micro second
    std::string _resourceRootPath;
    
	static Application * sm_pSharedApplication;
	static mrb_state * mrb;
	static std::map<std::string,mrb_data_type *> mrbNameMap;
	static std::map<void *,mrb_value> mrbObjMap;
	std::string scriptFile;
	mrb_value  self;
	public:
	virtual bool applicationDidFinishLaunching();
  virtual	void applicationDidEnterBackground();
  virtual void applicationWillEnterForeground();
  virtual mrb_value&  getMrbValue();
  static mrb_state * getMrbState();
  //static std::map<void *,mrb_value>& getMrbObjMap() ;
  static mrb_value * getMrbObj(void *);
  static void setMrbObj(void *,mrb_value);
  static void removeMrbObj(void *);
  static mrb_data_type * getMrbType(std::string);
  static void setMrbType(std::string,mrb_data_type *);
  
	//static std::map<std::string,mrb_data_type *> & getMrbNameMap() ;
};

NS_CC_END

#endif // CC_TARGET_PLATFORM == CC_PLATFORM_LINUX

#endif /* CCAPLICATION_H_ */
