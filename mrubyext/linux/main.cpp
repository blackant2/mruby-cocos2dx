#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string>

#include <mruby.h>
#include <mruby/compile.h>
#include <mruby/string.h>

#include "mruby_cocos2dx.h"
USING_NS_CC;

int main(int argc, char **argv)
{
	 cocos2d::Application app("main.rb");
	cocos2d::Application::getInstance()->run();
/* mrb_state * mrb=mrb_open();
 mrb_libmruby_cocos2dx_gem_init(mrb);
 
 cocos2d::Application app(mrb);
 
  const char *fpath="main.rb";
  FILE * file = fopen(fpath, "r");
    log("mrb_load_file");
  mrb_load_file(mrb,file);
    log("xxxx close");
  fclose(file);
  mrb_close(mrb);
  log("xxxx");
  */
  return 0;
  
}

