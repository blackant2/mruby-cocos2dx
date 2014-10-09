##encoding:utf-8
require 'fileutils'

NDK_ROOT="/home/ker/ndk"
COCOS_ROOT="/home/ker/cocos2dx"
CC="#{NDK_ROOT}/toolchains/llvm-3.4/prebuilt/linux-x86_64/bin/clang++"
AR="#{NDK_ROOT}/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86_64/bin/arm-linux-androideabi-ar"
LIB_NAME="extensions"

LOCAL_SRC_FILES = %w(
assets-manager/AssetsManager
GUI/CCControlExtension/CCControl
GUI/CCControlExtension/CCControlButton
GUI/CCControlExtension/CCControlColourPicker
GUI/CCControlExtension/CCControlHuePicker
GUI/CCControlExtension/CCControlPotentiometer
GUI/CCControlExtension/CCControlSaturationBrightnessPicker
GUI/CCControlExtension/CCControlSlider
GUI/CCControlExtension/CCControlStepper
GUI/CCControlExtension/CCControlSwitch
GUI/CCControlExtension/CCControlUtils
GUI/CCControlExtension/CCInvocation
GUI/CCControlExtension/CCScale9Sprite
GUI/CCEditBox/CCEditBox
GUI/CCEditBox/CCEditBoxImplAndroid
GUI/CCEditBox/CCEditBoxImplNone
GUI/CCEditBox/CCEditBoxImplWin
GUI/CCScrollView/CCScrollView
GUI/CCScrollView/CCTableView
GUI/CCScrollView/CCTableViewCell
physics-nodes/CCPhysicsDebugNode
physics-nodes/CCPhysicsSprite)

FileUtils.mkdir_p("objs/#{LIB_NAME}") unless Dir.exists?("objs/#{LIB_NAME}")
LOCAL_SRC_FILES.each do |f|
	if f.include?('/')
	  i=f.rindex('/')
	  FileUtils.mkdir_p "objs/#{LIB_NAME}/#{f[0,i]}" unless Dir.exists? "objs/#{LIB_NAME}/#{f[0,i]}"
  end
	  		 sh="#{CC} -MMD -MP -MF objs/#{LIB_NAME}/#{f}.o.d"
	  		 sh<<" -gcc-toolchain #{NDK_ROOT}/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86_64"
	  		 sh<<" -fpic -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes" 
	  		 sh<<" -target armv5te-none-linux-androideabi -march=armv5te -mtune=xscale -msoft-float" 
	  		 sh<<" -fno-exceptions -fno-rtti -mthumb -Os -g -DNDEBUG -fomit-frame-pointer -fno-strict-aliasing "
	  		 sh<<" -I#{COCOS_ROOT}/extensions/.." 
	  		 sh<<" -I#{NDK_ROOT}/sources/cxx-stl/llvm-libc++/libcxx/include "
	  		 sh<<" -I#{NDK_ROOT}/sources/cxx-stl/llvm-libc++/../gabi++/include"
	  		 sh<<" -I#{NDK_ROOT}/sources/cxx-stl/llvm-libc++/../../android/support/include" 
	  		 sh<<" -I#{COCOS_ROOT}/cocos/." 
	  		 sh<<" -I#{COCOS_ROOT}/cocos/./." 
	  		 sh<<" -I#{COCOS_ROOT}/cocos/./platform/android" 
	  		 sh<<" -I#{COCOS_ROOT}/cocos/./../external/tinyxml2" 
	  		 sh<<" -I#{COCOS_ROOT}/cocos/./../external/unzip"
	  		 sh<<" -I#{COCOS_ROOT}/cocos/./../external/chipmunk/include/chipmunk" 
	  		 sh<<" -I#{COCOS_ROOT}/cocos/./../external/xxhash" 
	  		 sh<<" -I#{COCOS_ROOT}/cocos/./../external/nslog "
	  		 sh<<" -I#{COCOS_ROOT}/cocos/audio/android/../include "
	  		 sh<<" -I#{COCOS_ROOT}/external/curl/prebuilt/android/../../include/android "
	  		 sh<<" -I#{COCOS_ROOT}/external/Box2D/.. "
	  		 sh<<" -I#{COCOS_ROOT}/external/websockets/prebuilt/android/../../include/android "
	  		 sh<<" -I#{COCOS_ROOT}/external/freetype2/prebuilt/android/../../include/android "
	  		 sh<<" -I#{COCOS_ROOT}/external/freetype2/prebuilt/android/../../include/android/freetype2" 
	  		 sh<<" -I#{COCOS_ROOT}/external/chipmunk/include/chipmunk" 
	  		 sh<<" -I#{COCOS_ROOT}/cocos/platform/android" 
	  		 sh<<" -I#{COCOS_ROOT}/external/png/prebuilt/android/../../include/android" 
	  		 sh<<" -I#{COCOS_ROOT}/external/jpeg/prebuilt/android/../../include/android "
	  		 sh<<" -I#{COCOS_ROOT}/external/tiff/prebuilt/android/../../include/android "
	  		 sh<<" -I#{COCOS_ROOT}/external/webp/prebuilt/android/../../include/android "
	  		 sh<<" -I#{NDK_ROOT}/sources/android/cpufeatures "
	  		 sh<<" -I#{COCOS_ROOT}/extensions "
	  		 sh<<" -DANDROID -DUSE_FILE32API -Wa,--noexecstack -Wformat -Werror=format-security -std=c++11 "
	  		 sh<<" -Wno-deprecated-declarations -Wno-extern-c-compat -D__STDC_LIMIT_MACROS=1 "
	  		 sh<<" -fexceptions   -frtti -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 "
	  		 sh<<" -std=c++11 -fsigned-char" 
	  		 sh<<" -DNDEBUG" 
	  		 sh<<" -I#{NDK_ROOT}/platforms/android-14/arch-arm/usr/include" 
	  		 sh<<" -c  #{COCOS_ROOT}/extensions/#{f}.cpp"
	  		 sh<<" -o  objs/#{LIB_NAME}/#{f}.o"
	  		 puts sh
	  	 #  system sh
end	

FileUtils.mkdir_p("lib") unless Dir.exists?("lib")

sh="#{AR} crsD lib/lib#{LIB_NAME}.a"

LOCAL_SRC_FILES.each do |f|
	  sh<<" ./objs/#{LIB_NAME}/#{f}.o"
end
puts sh
system sh
