##encoding:utf-8
require 'fileutils'

NDK_ROOT="/home/ker/ndk"
COCOS_ROOT="/home/ker/cocos2dx"
CC="#{NDK_ROOT}/toolchains/llvm-3.4/prebuilt/linux-x86_64/bin/clang++"
AR="#{NDK_ROOT}/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86_64/bin/arm-linux-androideabi-ar"
LIB_NAME="cocosbuilder"

LOCAL_SRC_FILES =%w(CCBAnimationManager.cpp
CCBFileLoader.cpp
CCBKeyframe.cpp
CCBReader.cpp
CCBSequence.cpp
CCBSequenceProperty.cpp
CCControlButtonLoader.cpp
CCControlLoader.cpp
CCLabelBMFontLoader.cpp
CCLabelTTFLoader.cpp
CCLayerColorLoader.cpp
CCLayerGradientLoader.cpp
CCLayerLoader.cpp
CCMenuItemImageLoader.cpp
CCMenuItemLoader.cpp
CCNode+CCBRelativePositioning.cpp
CCNodeLoader.cpp
CCNodeLoaderLibrary.cpp
CCParticleSystemQuadLoader.cpp
CCScale9SpriteLoader.cpp
CCScrollViewLoader.cpp
CCSpriteLoader.cpp)

FileUtils.mkdir_p("objs/#{LIB_NAME}") unless Dir.exists?("objs/#{LIB_NAME}")

LOCAL_SRC_FILES.each do |f|
   	sh="#{CC} -MMD -MP -MF objs/#{LIB_NAME}/#{f}.o.d"
		sh<<" -gcc-toolchain /home/ker/ndk/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86_64"
		sh<<" -fpic"
		sh<<" -ffunction-sections"
		sh<<" -funwind-tables"
		sh<<" -fstack-protector"
		sh<<" -no-canonical-prefixes"
		sh<<" -target armv5te-none-linux-androideabi"
		sh<<" -march=armv5te"
		sh<<" -mtune=xscale"
		sh<<" -msoft-float"
		sh<<" -fno-exceptions"
		sh<<" -fno-rtti"
		sh<<" -mthumb"
		sh<<" -Os"
		sh<<" -g"
		sh<<" -DNDEBUG"
		sh<<" -fomit-frame-pointer"
		sh<<" -fno-strict-aliasing"
		sh<<" -I#{COCOS_ROOT}/cocos/editor-support/cocosbuilder/../../2d"
		sh<<" -I#{COCOS_ROOT}/cocos/editor-support/cocosbuilder"
		sh<<" -I#{COCOS_ROOT}/cocos/editor-support/cocosbuilder/../../.."
		sh<<" -I#{NDK_ROOT}/sources/cxx-stl/llvm-libc++/libcxx/include"
		sh<<" -I#{NDK_ROOT}/sources/cxx-stl/llvm-libc++/../gabi++/include"
		sh<<" -I#{NDK_ROOT}/sources/cxx-stl/llvm-libc++/../../android/support/include"
		sh<<" -I#{COCOS_ROOT}/extensions/.."
		sh<<" -I#{COCOS_ROOT}/extensions/GUI/CCControlExtension"
		sh<<" -I#{COCOS_ROOT}/extensions/GUI/CCScrollView"
		sh<<" -I#{COCOS_ROOT}/cocos/."
		sh<<" -I#{COCOS_ROOT}/cocos/./."
		sh<<" -I#{COCOS_ROOT}/cocos/./platform/android"
		sh<<" -I#{COCOS_ROOT}/cocos/./../external/tinyxml2"
		sh<<" -I#{COCOS_ROOT}/cocos/./../external/unzip"
		sh<<" -I#{COCOS_ROOT}/cocos/./../external/chipmunk/include/chipmunk"
		sh<<" -I#{COCOS_ROOT}/cocos/./../external/xxhash"
		sh<<" -I#{COCOS_ROOT}/cocos/./../external/nslog"
		sh<<" -I#{COCOS_ROOT}/cocos/audio/android/../include"
		sh<<" -I#{COCOS_ROOT}/external/curl/prebuilt/android/../../include/android"
		sh<<" -I#{COCOS_ROOT}/external/Box2D/.."
		sh<<" -I#{COCOS_ROOT}/external/websockets/prebuilt/android/../../include/android"
		sh<<" -I#{COCOS_ROOT}/external/freetype2/prebuilt/android/../../include/android"
		sh<<" -I#{COCOS_ROOT}/external/freetype2/prebuilt/android/../../include/android/freetype2"
		sh<<" -I#{COCOS_ROOT}/external/chipmunk/include/chipmunk"
		sh<<" -I#{COCOS_ROOT}/cocos/platform/android"
		sh<<" -I#{COCOS_ROOT}/external/png/prebuilt/android/../../include/android"
		sh<<" -I#{COCOS_ROOT}/external/jpeg/prebuilt/android/../../include/android"
		sh<<" -I#{COCOS_ROOT}/external/tiff/prebuilt/android/../../include/android"
		sh<<" -I#{COCOS_ROOT}/external/webp/prebuilt/android/../../include/android"
		sh<<" -I#{NDK_ROOT}/sources/android/cpufeatures"
		sh<<" -I#{COCOS_ROOT}/cocos/editor-support/cocosbuilder"
		sh<<" -DANDROID"
		sh<<" -DUSE_FILE32API"
		sh<<" -Wa,--noexecstack"
		sh<<" -Wformat"
		sh<<" -Werror=format-security"
		sh<<" -std=c++11"
		sh<<" -Wno-deprecated-declarations"
		sh<<" -Wno-extern-c-compat"
		sh<<" -D__STDC_LIMIT_MACROS=1"
		sh<<" -fexceptions  "
		sh<<" -frtti"
		sh<<" -DCC_ENABLE_CHIPMUNK_INTEGRATION=1"
		sh<<" -std=c++11"
		sh<<" -fsigned-char"
		sh<<" -DNDEBUG "
		sh<<" -I#{NDK_ROOT}/platforms/android-14/arch-arm/usr/include"
		sh<<" -c  #{COCOS_ROOT}/cocos/editor-support/cocosbuilder/#{f}"
		sh<<" -o objs/#{LIB_NAME}/#{f}.o"
		puts sh
		system sh
end

FileUtils.mkdir_p("lib") unless Dir.exists?("lib")
sh="#{AR} crsD lib/lib#{LIB_NAME}.a"

LOCAL_SRC_FILES.each do |f|
	  sh<<" ./objs/#{LIB_NAME}/#{f}.o"
end
puts sh
system sh
