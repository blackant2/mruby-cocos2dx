##encoding:utf-8
require 'fileutils'


COCOS_ROOT="/home/ker/cocos2dx"
CC="c++"
AR="ar"
LIB_NAME="extension"


LOCAL_SRC_FILES =%w(
assets-manager/AssetsManager.cpp
GUI/CCControlExtension/CCControl.cpp
GUI/CCControlExtension/CCControlButton.cpp
GUI/CCControlExtension/CCControlColourPicker.cpp
GUI/CCControlExtension/CCControlHuePicker.cpp
GUI/CCControlExtension/CCControlPotentiometer.cpp
GUI/CCControlExtension/CCControlSaturationBrightnessPicker.cpp
GUI/CCControlExtension/CCControlSlider.cpp
GUI/CCControlExtension/CCControlStepper.cpp
GUI/CCControlExtension/CCControlSwitch.cpp
GUI/CCControlExtension/CCControlUtils.cpp
GUI/CCControlExtension/CCInvocation.cpp
GUI/CCControlExtension/CCScale9Sprite.cpp
GUI/CCEditBox/CCEditBox.cpp
GUI/CCEditBox/CCEditBoxImplAndroid.cpp
GUI/CCEditBox/CCEditBoxImplNone.cpp
GUI/CCEditBox/CCEditBoxImplWin.cpp
GUI/CCScrollView/CCScrollView.cpp
GUI/CCScrollView/CCTableView.cpp
GUI/CCScrollView/CCTableViewCell.cpp
physics-nodes/CCPhysicsDebugNode.cpp
physics-nodes/CCPhysicsSprite.cpp
)


FileUtils.mkdir_p("objs/#{LIB_NAME}") unless Dir.exists?("objs/#{LIB_NAME}")
LOCAL_SRC_FILES.each do |f|
	if f.include?('/')
	  i=f.rindex('/')
	  FileUtils.mkdir_p "objs/#{LIB_NAME}/#{f[0,i]}" unless Dir.exists? "objs/#{LIB_NAME}/#{f[0,i]}"
  end
   sh="#{CC} -DCC_ENABLE_CHIPMUNK_INTEGRATION=1"
		sh<<" -DLINUX"
		sh<<" -std=c++11"
		sh<<" -g"
		sh<<" -Wall"
		sh<<" -DCOCOS2D_DEBUG=1"
		sh<<" -fPIC"
		sh<<" -I#{COCOS_ROOT}"
		sh<<" -I#{COCOS_ROOT}/cocos"
		sh<<" -I#{COCOS_ROOT}/cocos/platform/desktop"
		sh<<" -I#{COCOS_ROOT}/cocos/platform/linux"
		sh<<" -I#{COCOS_ROOT}/cocos/audio/include"
		sh<<" -I#{COCOS_ROOT}/cocos/editor-support"
		sh<<" -I#{COCOS_ROOT}/cocos/scripting/lua-bindings/auto"
		sh<<" -I#{COCOS_ROOT}/cocos/scripting/lua-bindings/manual"
		sh<<" -I#{COCOS_ROOT}/extensions"
		sh<<" -I#{COCOS_ROOT}/external"
		sh<<" -I#{COCOS_ROOT}/external/tinyxml2"
		sh<<" -I#{COCOS_ROOT}/external/unzip"
		sh<<" -I#{COCOS_ROOT}/external/edtaa3func"
		sh<<" -I#{COCOS_ROOT}/external/chipmunk/include/chipmunk"
		sh<<" -I#{COCOS_ROOT}/external/jpeg/include/linux"
		sh<<" -I#{COCOS_ROOT}/external/png/include/linux"
		sh<<" -I#{COCOS_ROOT}/external/tiff/include/linux"
		sh<<" -I#{COCOS_ROOT}/external/webp/include/linux"
		sh<<" -I#{COCOS_ROOT}/external/glfw3/include/linux"
		sh<<" -I#{COCOS_ROOT}/external/freetype2/include/linux"
		sh<<" -I#{COCOS_ROOT}/external/websockets/include/linux"
		sh<<" -I#{COCOS_ROOT}/external/xxhash"
		sh<<" -I#{COCOS_ROOT}/external/xxtea"
		sh<<" -I/usr/include/GLFW"
		sh<<" -I/usr/local/include/GLFW"
		sh<<" -I#{COCOS_ROOT}/external/linux-specific/fmod/include/64-bit"
		sh<<" -o objs/#{LIB_NAME}/#{f}.o"
		sh<<" -c  #{COCOS_ROOT}/extensions/#{f}"
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
=begin
STR=<<STRING
Scanning dependencies of target extensions
make[2]:正在离开目录 `#{COCOS_ROOT}/ubuntu'
make -f extensions/CMakeFiles/extensions.dir/build.make extensions/CMakeFiles/extensions.dir/build
make[2]: 正在进入目录 `/home/ker/cocos2dx/ubuntu'
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 43%] Building CXX object extensions/CMakeFiles/extensions.dir/assets-manager/AssetsManager.cpp.o
cd /home/ker/cocos2dx/ubuntu/extensions && /usr/bin/c++  
-DCC_ENABLE_CHIPMUNK_INTEGRATION=1
-DLINUX
-std=c++11
-g
-Wall
-DCOCOS2D_DEBUG=1
-fPIC
-I/home/ker/cocos2dx
-I/home/ker/cocos2dx/cocos
-I/home/ker/cocos2dx/cocos/platform/desktop
-I/home/ker/cocos2dx/cocos/platform/linux
-I/home/ker/cocos2dx/cocos/audio/include
-I/home/ker/cocos2dx/cocos/editor-support
-I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto
-I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual
-I/home/ker/cocos2dx/extensions
-I/home/ker/cocos2dx/external
-I/home/ker/cocos2dx/external/tinyxml2
-I/home/ker/cocos2dx/external/unzip
-I/home/ker/cocos2dx/external/edtaa3func
-I/home/ker/cocos2dx/external/chipmunk/include/chipmunk
-I/home/ker/cocos2dx/external/jpeg/include/linux
-I/home/ker/cocos2dx/external/png/include/linux
-I/home/ker/cocos2dx/external/tiff/include/linux
-I/home/ker/cocos2dx/external/webp/include/linux
-I/home/ker/cocos2dx/external/glfw3/include/linux
-I/home/ker/cocos2dx/external/freetype2/include/linux
-I/home/ker/cocos2dx/external/websockets/include/linux
-I/home/ker/cocos2dx/external/xxhash
-I/home/ker/cocos2dx/external/xxtea
-I/usr/include/GLFW
-I/usr/local/include/GLFW
-I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit
-o CMakeFiles/extensions.dir/assets-manager/AssetsManager.cpp.o
-c assets-manager/AssetsManager.cpp
/usr/bin/cmake
-E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 82
[ 44%] Building CXX object extensions/CMakeFiles/extensions.dir/GUI/CCControlExtension/CCControl.cpp.o
cd /home/ker/cocos2dx/ubuntu/extensions && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I..    -o CMakeFiles/extensions.dir/GUI/CCControlExtension/CCControl.cpp.o -c GUI/CCControlExtension/CCControl.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 44%] Building CXX object extensions/CMakeFiles/extensions.dir/GUI/CCControlExtension/CCControlButton.cpp.o
cd /home/ker/cocos2dx/ubuntu/extensions && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I..    -o CMakeFiles/extensions.dir/GUI/CCControlExtension/CCControlButton.cpp.o -c GUI/CCControlExtension/CCControlButton.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 44%] Building CXX object extensions/CMakeFiles/extensions.dir/GUI/CCControlExtension/CCControlColourPicker.cpp.o
cd /home/ker/cocos2dx/ubuntu/extensions && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I..    -o CMakeFiles/extensions.dir/GUI/CCControlExtension/CCControlColourPicker.cpp.o -c GUI/CCControlExtension/CCControlColourPicker.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 44%] Building CXX object extensions/CMakeFiles/extensions.dir/GUI/CCControlExtension/CCControlHuePicker.cpp.o
cd /home/ker/cocos2dx/ubuntu/extensions && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I..    -o CMakeFiles/extensions.dir/GUI/CCControlExtension/CCControlHuePicker.cpp.o -c GUI/CCControlExtension/CCControlHuePicker.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 44%] Building CXX object extensions/CMakeFiles/extensions.dir/GUI/CCControlExtension/CCControlPotentiometer.cpp.o
cd /home/ker/cocos2dx/ubuntu/extensions && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I..    -o CMakeFiles/extensions.dir/GUI/CCControlExtension/CCControlPotentiometer.cpp.o -c GUI/CCControlExtension/CCControlPotentiometer.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 44%] Building CXX object extensions/CMakeFiles/extensions.dir/GUI/CCControlExtension/CCControlSaturationBrightnessPicker.cpp.o
cd /home/ker/cocos2dx/ubuntu/extensions && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I..    -o CMakeFiles/extensions.dir/GUI/CCControlExtension/CCControlSaturationBrightnessPicker.cpp.o -c GUI/CCControlExtension/CCControlSaturationBrightnessPicker.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 83
[ 45%] Building CXX object extensions/CMakeFiles/extensions.dir/GUI/CCControlExtension/CCControlSlider.cpp.o
cd /home/ker/cocos2dx/ubuntu/extensions && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I..    -o CMakeFiles/extensions.dir/GUI/CCControlExtension/CCControlSlider.cpp.o -c GUI/CCControlExtension/CCControlSlider.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 45%] Building CXX object extensions/CMakeFiles/extensions.dir/GUI/CCControlExtension/CCControlStepper.cpp.o
cd /home/ker/cocos2dx/ubuntu/extensions && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I..    -o CMakeFiles/extensions.dir/GUI/CCControlExtension/CCControlStepper.cpp.o -c GUI/CCControlExtension/CCControlStepper.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 45%] Building CXX object extensions/CMakeFiles/extensions.dir/GUI/CCControlExtension/CCControlSwitch.cpp.o
cd /home/ker/cocos2dx/ubuntu/extensions && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I..    -o CMakeFiles/extensions.dir/GUI/CCControlExtension/CCControlSwitch.cpp.o -c GUI/CCControlExtension/CCControlSwitch.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 45%] Building CXX object extensions/CMakeFiles/extensions.dir/GUI/CCControlExtension/CCControlUtils.cpp.o
cd /home/ker/cocos2dx/ubuntu/extensions && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I..    -o CMakeFiles/extensions.dir/GUI/CCControlExtension/CCControlUtils.cpp.o -c GUI/CCControlExtension/CCControlUtils.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 45%] Building CXX object extensions/CMakeFiles/extensions.dir/GUI/CCControlExtension/CCInvocation.cpp.o
cd /home/ker/cocos2dx/ubuntu/extensions && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I..    -o CMakeFiles/extensions.dir/GUI/CCControlExtension/CCInvocation.cpp.o -c GUI/CCControlExtension/CCInvocation.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 45%] Building CXX object extensions/CMakeFiles/extensions.dir/GUI/CCControlExtension/CCScale9Sprite.cpp.o
cd /home/ker/cocos2dx/ubuntu/extensions && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I..    -o CMakeFiles/extensions.dir/GUI/CCControlExtension/CCScale9Sprite.cpp.o -c GUI/CCControlExtension/CCScale9Sprite.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 45%] Building CXX object extensions/CMakeFiles/extensions.dir/GUI/CCEditBox/CCEditBox.cpp.o
cd /home/ker/cocos2dx/ubuntu/extensions && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I..    -o CMakeFiles/extensions.dir/GUI/CCEditBox/CCEditBox.cpp.o -c GUI/CCEditBox/CCEditBox.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 84
[ 46%] Building CXX object extensions/CMakeFiles/extensions.dir/GUI/CCEditBox/CCEditBoxImplAndroid.cpp.o
cd /home/ker/cocos2dx/ubuntu/extensions && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I..    -o CMakeFiles/extensions.dir/GUI/CCEditBox/CCEditBoxImplAndroid.cpp.o -c GUI/CCEditBox/CCEditBoxImplAndroid.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 46%] Building CXX object extensions/CMakeFiles/extensions.dir/GUI/CCEditBox/CCEditBoxImplNone.cpp.o
cd /home/ker/cocos2dx/ubuntu/extensions && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I..    -o CMakeFiles/extensions.dir/GUI/CCEditBox/CCEditBoxImplNone.cpp.o -c GUI/CCEditBox/CCEditBoxImplNone.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 46%] Building CXX object extensions/CMakeFiles/extensions.dir/GUI/CCEditBox/CCEditBoxImplWin.cpp.o
cd /home/ker/cocos2dx/ubuntu/extensions && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I..    -o CMakeFiles/extensions.dir/GUI/CCEditBox/CCEditBoxImplWin.cpp.o -c GUI/CCEditBox/CCEditBoxImplWin.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 46%] Building CXX object extensions/CMakeFiles/extensions.dir/GUI/CCScrollView/CCScrollView.cpp.o
cd /home/ker/cocos2dx/ubuntu/extensions && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I..    -o CMakeFiles/extensions.dir/GUI/CCScrollView/CCScrollView.cpp.o -c GUI/CCScrollView/CCScrollView.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 46%] Building CXX object extensions/CMakeFiles/extensions.dir/GUI/CCScrollView/CCTableView.cpp.o
cd /home/ker/cocos2dx/ubuntu/extensions && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I..    -o CMakeFiles/extensions.dir/GUI/CCScrollView/CCTableView.cpp.o -c GUI/CCScrollView/CCTableView.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 46%] Building CXX object extensions/CMakeFiles/extensions.dir/GUI/CCScrollView/CCTableViewCell.cpp.o
cd /home/ker/cocos2dx/ubuntu/extensions && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I..    -o CMakeFiles/extensions.dir/GUI/CCScrollView/CCTableViewCell.cpp.o -c GUI/CCScrollView/CCTableViewCell.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 85
[ 47%] Building CXX object extensions/CMakeFiles/extensions.dir/physics-nodes/CCPhysicsDebugNode.cpp.o
cd /home/ker/cocos2dx/ubuntu/extensions && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I..    -o CMakeFiles/extensions.dir/physics-nodes/CCPhysicsDebugNode.cpp.o -c physics-nodes/CCPhysicsDebugNode.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 47%] Building CXX object extensions/CMakeFiles/extensions.dir/physics-nodes/CCPhysicsSprite.cpp.o
cd /home/ker/cocos2dx/ubuntu/extensions && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I..    -o CMakeFiles/extensions.dir/physics-nodes/CCPhysicsSprite.cpp.o -c physics-nodes/CCPhysicsSprite.cpp
Linking CXX static library ../lib/libextensions.a
cd /home/ker/cocos2dx/ubuntu/extensions && /usr/bin/cmake -P CMakeFiles/extensions.dir/cmake_clean_target.cmake
cd /home/ker/cocos2dx/ubuntu/extensions && /usr/bin/cmake -E cmake_link_script CMakeFiles/extensions.dir/link.txt --verbose=1
/usr/bin/ar cr ../lib/libextensions.a  CMakeFiles/extensions.dir/assets-manager/AssetsManager.cpp.o CMakeFiles/extensions.dir/GUI/CCControlExtension/CCControl.cpp.o CMakeFiles/extensions.dir/GUI/CCControlExtension/CCControlButton.cpp.o CMakeFiles/extensions.dir/GUI/CCControlExtension/CCControlColourPicker.cpp.o CMakeFiles/extensions.dir/GUI/CCControlExtension/CCControlHuePicker.cpp.o CMakeFiles/extensions.dir/GUI/CCControlExtension/CCControlPotentiometer.cpp.o CMakeFiles/extensions.dir/GUI/CCControlExtension/CCControlSaturationBrightnessPicker.cpp.o CMakeFiles/extensions.dir/GUI/CCControlExtension/CCControlSlider.cpp.o CMakeFiles/extensions.dir/GUI/CCControlExtension/CCControlStepper.cpp.o CMakeFiles/extensions.dir/GUI/CCControlExtension/CCControlSwitch.cpp.o CMakeFiles/extensions.dir/GUI/CCControlExtension/CCControlUtils.cpp.o CMakeFiles/extensions.dir/GUI/CCControlExtension/CCInvocation.cpp.o CMakeFiles/extensions.dir/GUI/CCControlExtension/CCScale9Sprite.cpp.o CMakeFiles/extensions.dir/GUI/CCEditBox/CCEditBox.cpp.o CMakeFiles/extensions.dir/GUI/CCEditBox/CCEditBoxImplAndroid.cpp.o CMakeFiles/extensions.dir/GUI/CCEditBox/CCEditBoxImplNone.cpp.o CMakeFiles/extensions.dir/GUI/CCEditBox/CCEditBoxImplWin.cpp.o CMakeFiles/extensions.dir/GUI/CCScrollView/CCScrollView.cpp.o CMakeFiles/extensions.dir/GUI/CCScrollView/CCTableView.cpp.o CMakeFiles/extensions.dir/GUI/CCScrollView/CCTableViewCell.cpp.o CMakeFiles/extensions.dir/physics-nodes/CCPhysicsDebugNode.cpp.o CMakeFiles/extensions.dir/physics-nodes/CCPhysicsSprite.cpp.o
/usr/bin/ranlib ../lib/libextensions.a
make[2]:正在离开目录 `/home/ker/cocos2dx/ubuntu'
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles  82 83 84 85
[ 47%] Built target extensions
make -f cocos/editor-support/spine/CMakeFiles/spine.dir/build.make cocos/editor-support/spine/CMakeFiles/spine.dir/depend
make[2]: 正在进入目录 `/home/ker/cocos2dx/ubuntu'
cd /home/ker/cocos2dx/ubuntu && /usr/bin/cmake -E cmake_depends "Unix Makefiles" /home/ker/cocos2dx /home/ker/cocos2dx/cocos/editor-support/spine /home/ker/cocos2dx/ubuntu /home/ker/cocos2dx/ubuntu/cocos/editor-support/spine /home/ker/cocos2dx/ubuntu/cocos/editor-support/spine/CMakeFiles/spine.dir/DependInfo.cmake --color=
STRING
STR.each_line do |l|
	if m=/\-c (.*)$/.match(l)
	   puts m [1]
	end
end
=end