##encoding:utf-8
require 'fileutils'


COCOS_ROOT="/home/ker/cocos2dx"
CC="c++"
AR="ar"
LIB_NAME="ui"

LOCAL_SRC_FILES = %w(
CCProtectedNode.cpp
CocosGUI.cpp
UIButton.cpp
UICheckBox.cpp
UIHBox.cpp
UIHelper.cpp
UIImageView.cpp
UILayout.cpp
UILayoutParameter.cpp
UILayoutManager.cpp
UIListView.cpp
UILoadingBar.cpp
UIPageView.cpp
UIRelativeBox.cpp
UIRichText.cpp
UIScrollView.cpp
UISlider.cpp
UITextAtlas.cpp
UITextBMFont.cpp
UIText.cpp
UITextField.cpp
UIVBox.cpp
UIWidget.cpp
UIDeprecated.cpp
)
FileUtils.mkdir_p("objs/#{LIB_NAME}") unless Dir.exists?("objs/#{LIB_NAME}")
LOCAL_SRC_FILES.each do |f|
	if f.include?('/')
	  i=f.rindex('/')
	  FileUtils.mkdir_p "objs/#{LIB_NAME}/#{f[0,i]}" unless Dir.exists? "objs/#{LIB_NAME}/#{f[0,i]}"
  end
   sh="#{CC}  -DCC_ENABLE_CHIPMUNK_INTEGRATION=1"
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
		sh<<" -I#{COCOS_ROOT}/cocos/../external/ConvertUTF  "
	   sh<<" -o objs/#{LIB_NAME}/#{f}.o  "
	sh<<" -c #{COCOS_ROOT}/cocos/ui/#{f}"
   	puts sh
		system sh
end  

FileUtils.mkdir_p("lib") unless Dir.exists?("lib")
sh="#{AR}  crs  lib/lib#{LIB_NAME}.a"
LOCAL_SRC_FILES.each do |f|
	  sh<<"  ./objs/#{LIB_NAME}/#{f}.o"
end
puts sh
system sh
=begin
STR=<<STRING
[ 37%] Building CXX object cocos/CMakeFiles/cocos2d.dir/ui/CCProtectedNode.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1
-DLINUX
-std=c++11
-g
-Wall
-DCOCOS2D_DEBUG=1
-fPIC
-I#{COCOS_ROOT}
-I#{COCOS_ROOT}/cocos
-I#{COCOS_ROOT}/cocos/platform/desktop
-I#{COCOS_ROOT}/cocos/platform/linux
-I#{COCOS_ROOT}/cocos/audio/include
-I#{COCOS_ROOT}/cocos/editor-support
-I#{COCOS_ROOT}/cocos/scripting/lua-bindings/auto
-I#{COCOS_ROOT}/cocos/scripting/lua-bindings/manual
-I#{COCOS_ROOT}/extensions
-I#{COCOS_ROOT}/external
-I#{COCOS_ROOT}/external/tinyxml2
-I#{COCOS_ROOT}/external/unzip
-I#{COCOS_ROOT}/external/edtaa3func
-I#{COCOS_ROOT}/external/chipmunk/include/chipmunk
-I#{COCOS_ROOT}/external/jpeg/include/linux
-I#{COCOS_ROOT}/external/png/include/linux
-I#{COCOS_ROOT}/external/tiff/include/linux
-I#{COCOS_ROOT}/external/webp/include/linux
-I#{COCOS_ROOT}/external/glfw3/include/linux
-I#{COCOS_ROOT}/external/freetype2/include/linux
-I#{COCOS_ROOT}/external/websockets/include/linux
-I#{COCOS_ROOT}/external/xxhash
-I#{COCOS_ROOT}/external/xxtea
-I/usr/include/GLFW
-I/usr/local/include/GLFW
-I#{COCOS_ROOT}/external/linux-specific/fmod/include/64-bit
-I#{COCOS_ROOT}/cocos/../external/ConvertUTF   
-o CMakeFiles/cocos2d.dir/ui/CCProtectedNode.cpp.o
-c #{COCOS_ROOT}/cocos/ui/CCProtectedNode.cpp
/usr/bin/cmake
-E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 38
[ 38%] Building CXX object cocos/CMakeFiles/cocos2d.dir/ui/CocosGUI.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/../external/ConvertUTF    -o CMakeFiles/cocos2d.dir/ui/CocosGUI.cpp.o -c /home/ker/cocos2dx/cocos/ui/CocosGUI.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 38%] Building CXX object cocos/CMakeFiles/cocos2d.dir/ui/UIButton.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/../external/ConvertUTF    -o CMakeFiles/cocos2d.dir/ui/UIButton.cpp.o -c /home/ker/cocos2dx/cocos/ui/UIButton.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 38%] Building CXX object cocos/CMakeFiles/cocos2d.dir/ui/UICheckBox.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/../external/ConvertUTF    -o CMakeFiles/cocos2d.dir/ui/UICheckBox.cpp.o -c /home/ker/cocos2dx/cocos/ui/UICheckBox.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 38%] Building CXX object cocos/CMakeFiles/cocos2d.dir/ui/UIHBox.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/../external/ConvertUTF    -o CMakeFiles/cocos2d.dir/ui/UIHBox.cpp.o -c /home/ker/cocos2dx/cocos/ui/UIHBox.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 38%] Building CXX object cocos/CMakeFiles/cocos2d.dir/ui/UIHelper.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/../external/ConvertUTF    -o CMakeFiles/cocos2d.dir/ui/UIHelper.cpp.o -c /home/ker/cocos2dx/cocos/ui/UIHelper.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 38%] Building CXX object cocos/CMakeFiles/cocos2d.dir/ui/UIImageView.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/../external/ConvertUTF    -o CMakeFiles/cocos2d.dir/ui/UIImageView.cpp.o -c /home/ker/cocos2dx/cocos/ui/UIImageView.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 39
[ 39%] Building CXX object cocos/CMakeFiles/cocos2d.dir/ui/UILayout.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/../external/ConvertUTF    -o CMakeFiles/cocos2d.dir/ui/UILayout.cpp.o -c /home/ker/cocos2dx/cocos/ui/UILayout.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 39%] Building CXX object cocos/CMakeFiles/cocos2d.dir/ui/UILayoutParameter.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/../external/ConvertUTF    -o CMakeFiles/cocos2d.dir/ui/UILayoutParameter.cpp.o -c /home/ker/cocos2dx/cocos/ui/UILayoutParameter.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 39%] Building CXX object cocos/CMakeFiles/cocos2d.dir/ui/UILayoutManager.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/../external/ConvertUTF    -o CMakeFiles/cocos2d.dir/ui/UILayoutManager.cpp.o -c /home/ker/cocos2dx/cocos/ui/UILayoutManager.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 39%] Building CXX object cocos/CMakeFiles/cocos2d.dir/ui/UIListView.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/../external/ConvertUTF    -o CMakeFiles/cocos2d.dir/ui/UIListView.cpp.o -c /home/ker/cocos2dx/cocos/ui/UIListView.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 39%] Building CXX object cocos/CMakeFiles/cocos2d.dir/ui/UILoadingBar.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/../external/ConvertUTF    -o CMakeFiles/cocos2d.dir/ui/UILoadingBar.cpp.o -c /home/ker/cocos2dx/cocos/ui/UILoadingBar.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 39%] Building CXX object cocos/CMakeFiles/cocos2d.dir/ui/UIPageView.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/../external/ConvertUTF    -o CMakeFiles/cocos2d.dir/ui/UIPageView.cpp.o -c /home/ker/cocos2dx/cocos/ui/UIPageView.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 39%] Building CXX object cocos/CMakeFiles/cocos2d.dir/ui/UIRelativeBox.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/../external/ConvertUTF    -o CMakeFiles/cocos2d.dir/ui/UIRelativeBox.cpp.o -c /home/ker/cocos2dx/cocos/ui/UIRelativeBox.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 40
[ 40%] Building CXX object cocos/CMakeFiles/cocos2d.dir/ui/UIRichText.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/../external/ConvertUTF    -o CMakeFiles/cocos2d.dir/ui/UIRichText.cpp.o -c /home/ker/cocos2dx/cocos/ui/UIRichText.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 40%] Building CXX object cocos/CMakeFiles/cocos2d.dir/ui/UIScrollView.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/../external/ConvertUTF    -o CMakeFiles/cocos2d.dir/ui/UIScrollView.cpp.o -c /home/ker/cocos2dx/cocos/ui/UIScrollView.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 40%] Building CXX object cocos/CMakeFiles/cocos2d.dir/ui/UISlider.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/../external/ConvertUTF    -o CMakeFiles/cocos2d.dir/ui/UISlider.cpp.o -c /home/ker/cocos2dx/cocos/ui/UISlider.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 40%] Building CXX object cocos/CMakeFiles/cocos2d.dir/ui/UITextAtlas.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/../external/ConvertUTF    -o CMakeFiles/cocos2d.dir/ui/UITextAtlas.cpp.o -c /home/ker/cocos2dx/cocos/ui/UITextAtlas.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 40%] Building CXX object cocos/CMakeFiles/cocos2d.dir/ui/UITextBMFont.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/../external/ConvertUTF    -o CMakeFiles/cocos2d.dir/ui/UITextBMFont.cpp.o -c /home/ker/cocos2dx/cocos/ui/UITextBMFont.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 40%] Building CXX object cocos/CMakeFiles/cocos2d.dir/ui/UIText.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/../external/ConvertUTF    -o CMakeFiles/cocos2d.dir/ui/UIText.cpp.o -c /home/ker/cocos2dx/cocos/ui/UIText.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 41
[ 41%] Building CXX object cocos/CMakeFiles/cocos2d.dir/ui/UITextField.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/../external/ConvertUTF    -o CMakeFiles/cocos2d.dir/ui/UITextField.cpp.o -c /home/ker/cocos2dx/cocos/ui/UITextField.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 41%] Building CXX object cocos/CMakeFiles/cocos2d.dir/ui/UIVBox.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/../external/ConvertUTF    -o CMakeFiles/cocos2d.dir/ui/UIVBox.cpp.o -c /home/ker/cocos2dx/cocos/ui/UIVBox.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 41%] Building CXX object cocos/CMakeFiles/cocos2d.dir/ui/UIWidget.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/../external/ConvertUTF    -o CMakeFiles/cocos2d.dir/ui/UIWidget.cpp.o -c /home/ker/cocos2dx/cocos/ui/UIWidget.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 41%] Building CXX object cocos/CMakeFiles/cocos2d.dir/ui/UIDeprecated.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/../external/ConvertUTF    -o CMakeFiles/cocos2d.dir/ui/UIDeprecated.cpp.o -c /home/ker/cocos2dx/cocos/ui/UIDeprecated.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeF
STRING

STR.each_line do |l|
	if m=/\-c (.*)$/.match(l)
	   puts m [1]
	end
end
=end