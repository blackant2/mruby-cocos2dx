##encoding:utf-8
require 'fileutils'


COCOS_ROOT="/home/ker/cocos2dx"
CC="c++"
AR="ar"
LIB_NAME="spine"

LOCAL_SRC_FILES = %w(
Animation.cpp
AnimationState.cpp
AnimationStateData.cpp
Atlas.cpp
AtlasAttachmentLoader.cpp
Attachment.cpp
AttachmentLoader.cpp
Bone.cpp
BoneData.cpp
BoundingBoxAttachment.cpp
Event.cpp
EventData.cpp
Json.cpp
RegionAttachment.cpp
Skeleton.cpp
SkeletonBounds.cpp
SkeletonData.cpp
SkeletonJson.cpp
Skin.cpp
Slot.cpp
SlotData.cpp
extension.cpp
spine-cocos2dx.cpp
CCSkeleton.cpp
CCSkeletonAnimation.cpp
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
		sh<<" -I#{COCOS_ROOT}/cocos/editor-support/spine/..   "
		sh<<" -o objs/#{LIB_NAME}/#{f}.o  "
		sh<<" -c #{COCOS_ROOT}/cocos/editor-support/spine/#{f}"
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
Scanning dependencies of target spine
make[2]:正在离开目录 `/home/ker/cocos2dx/ubuntu'
make -f cocos/editor-support/spine/CMakeFiles/spine.dir/build.make cocos/editor-support/spine/CMakeFiles/spine.dir/build
make[2]: 正在进入目录 `/home/ker/cocos2dx/ubuntu'
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 47%] Building CXX object cocos/editor-support/spine/CMakeFiles/spine.dir/Animation.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos/editor-support/spine && /usr/bin/c++  
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
-I/home/ker/cocos2dx/cocos/editor-support/spine/..   
-o CMakeFiles/spine.dir/Animation.cpp.o
-c /home/ker/cocos2dx/cocos/editor-support/spine/Animation.cpp
/usr/bin/cmake
-E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 47%] Building CXX object cocos/editor-support/spine/CMakeFiles/spine.dir/AnimationState.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos/editor-support/spine && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/editor-support/spine/..    -o CMakeFiles/spine.dir/AnimationState.cpp.o -c /home/ker/cocos2dx/cocos/editor-support/spine/AnimationState.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 95
[ 48%] Building CXX object cocos/editor-support/spine/CMakeFiles/spine.dir/AnimationStateData.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos/editor-support/spine && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/editor-support/spine/..    -o CMakeFiles/spine.dir/AnimationStateData.cpp.o -c /home/ker/cocos2dx/cocos/editor-support/spine/AnimationStateData.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 48%] Building CXX object cocos/editor-support/spine/CMakeFiles/spine.dir/Atlas.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos/editor-support/spine && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/editor-support/spine/..    -o CMakeFiles/spine.dir/Atlas.cpp.o -c /home/ker/cocos2dx/cocos/editor-support/spine/Atlas.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 48%] Building CXX object cocos/editor-support/spine/CMakeFiles/spine.dir/AtlasAttachmentLoader.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos/editor-support/spine && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/editor-support/spine/..    -o CMakeFiles/spine.dir/AtlasAttachmentLoader.cpp.o -c /home/ker/cocos2dx/cocos/editor-support/spine/AtlasAttachmentLoader.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 48%] Building CXX object cocos/editor-support/spine/CMakeFiles/spine.dir/Attachment.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos/editor-support/spine && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/editor-support/spine/..    -o CMakeFiles/spine.dir/Attachment.cpp.o -c /home/ker/cocos2dx/cocos/editor-support/spine/Attachment.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 48%] Building CXX object cocos/editor-support/spine/CMakeFiles/spine.dir/AttachmentLoader.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos/editor-support/spine && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/editor-support/spine/..    -o CMakeFiles/spine.dir/AttachmentLoader.cpp.o -c /home/ker/cocos2dx/cocos/editor-support/spine/AttachmentLoader.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 48%] Building CXX object cocos/editor-support/spine/CMakeFiles/spine.dir/Bone.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos/editor-support/spine && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/editor-support/spine/..    -o CMakeFiles/spine.dir/Bone.cpp.o -c /home/ker/cocos2dx/cocos/editor-support/spine/Bone.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 48%] Building CXX object cocos/editor-support/spine/CMakeFiles/spine.dir/BoneData.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos/editor-support/spine && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/editor-support/spine/..    -o CMakeFiles/spine.dir/BoneData.cpp.o -c /home/ker/cocos2dx/cocos/editor-support/spine/BoneData.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 96
[ 49%] Building CXX object cocos/editor-support/spine/CMakeFiles/spine.dir/BoundingBoxAttachment.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos/editor-support/spine && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/editor-support/spine/..    -o CMakeFiles/spine.dir/BoundingBoxAttachment.cpp.o -c /home/ker/cocos2dx/cocos/editor-support/spine/BoundingBoxAttachment.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 49%] Building CXX object cocos/editor-support/spine/CMakeFiles/spine.dir/Event.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos/editor-support/spine && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/editor-support/spine/..    -o CMakeFiles/spine.dir/Event.cpp.o -c /home/ker/cocos2dx/cocos/editor-support/spine/Event.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 49%] Building CXX object cocos/editor-support/spine/CMakeFiles/spine.dir/EventData.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos/editor-support/spine && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/editor-support/spine/..    -o CMakeFiles/spine.dir/EventData.cpp.o -c /home/ker/cocos2dx/cocos/editor-support/spine/EventData.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 49%] Building CXX object cocos/editor-support/spine/CMakeFiles/spine.dir/Json.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos/editor-support/spine && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/editor-support/spine/..    -o CMakeFiles/spine.dir/Json.cpp.o -c /home/ker/cocos2dx/cocos/editor-support/spine/Json.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 49%] Building CXX object cocos/editor-support/spine/CMakeFiles/spine.dir/RegionAttachment.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos/editor-support/spine && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/editor-support/spine/..    -o CMakeFiles/spine.dir/RegionAttachment.cpp.o -c /home/ker/cocos2dx/cocos/editor-support/spine/RegionAttachment.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 49%] Building CXX object cocos/editor-support/spine/CMakeFiles/spine.dir/Skeleton.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos/editor-support/spine && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/editor-support/spine/..    -o CMakeFiles/spine.dir/Skeleton.cpp.o -c /home/ker/cocos2dx/cocos/editor-support/spine/Skeleton.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 97
[ 50%] Building CXX object cocos/editor-support/spine/CMakeFiles/spine.dir/SkeletonBounds.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos/editor-support/spine && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/editor-support/spine/..    -o CMakeFiles/spine.dir/SkeletonBounds.cpp.o -c /home/ker/cocos2dx/cocos/editor-support/spine/SkeletonBounds.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 50%] Building CXX object cocos/editor-support/spine/CMakeFiles/spine.dir/SkeletonData.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos/editor-support/spine && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/editor-support/spine/..    -o CMakeFiles/spine.dir/SkeletonData.cpp.o -c /home/ker/cocos2dx/cocos/editor-support/spine/SkeletonData.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 50%] Building CXX object cocos/editor-support/spine/CMakeFiles/spine.dir/SkeletonJson.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos/editor-support/spine && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/editor-support/spine/..    -o CMakeFiles/spine.dir/SkeletonJson.cpp.o -c /home/ker/cocos2dx/cocos/editor-support/spine/SkeletonJson.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 50%] Building CXX object cocos/editor-support/spine/CMakeFiles/spine.dir/Skin.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos/editor-support/spine && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/editor-support/spine/..    -o CMakeFiles/spine.dir/Skin.cpp.o -c /home/ker/cocos2dx/cocos/editor-support/spine/Skin.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 50%] Building CXX object cocos/editor-support/spine/CMakeFiles/spine.dir/Slot.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos/editor-support/spine && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/editor-support/spine/..    -o CMakeFiles/spine.dir/Slot.cpp.o -c /home/ker/cocos2dx/cocos/editor-support/spine/Slot.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 50%] Building CXX object cocos/editor-support/spine/CMakeFiles/spine.dir/SlotData.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos/editor-support/spine && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/editor-support/spine/..    -o CMakeFiles/spine.dir/SlotData.cpp.o -c /home/ker/cocos2dx/cocos/editor-support/spine/SlotData.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 50%] Building CXX object cocos/editor-support/spine/CMakeFiles/spine.dir/extension.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos/editor-support/spine && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/editor-support/spine/..    -o CMakeFiles/spine.dir/extension.cpp.o -c /home/ker/cocos2dx/cocos/editor-support/spine/extension.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 98
[ 51%] Building CXX object cocos/editor-support/spine/CMakeFiles/spine.dir/spine-cocos2dx.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos/editor-support/spine && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/editor-support/spine/..    -o CMakeFiles/spine.dir/spine-cocos2dx.cpp.o -c /home/ker/cocos2dx/cocos/editor-support/spine/spine-cocos2dx.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 51%] Building CXX object cocos/editor-support/spine/CMakeFiles/spine.dir/CCSkeleton.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos/editor-support/spine && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/editor-support/spine/..    -o CMakeFiles/spine.dir/CCSkeleton.cpp.o -c /home/ker/cocos2dx/cocos/editor-support/spine/CCSkeleton.cpp
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles 
[ 51%] Building CXX object cocos/editor-support/spine/CMakeFiles/spine.dir/CCSkeletonAnimation.cpp.o
cd /home/ker/cocos2dx/ubuntu/cocos/editor-support/spine && /usr/bin/c++   -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DLINUX -std=c++11 -g -Wall -DCOCOS2D_DEBUG=1 -fPIC -I/home/ker/cocos2dx -I/home/ker/cocos2dx/cocos -I/home/ker/cocos2dx/cocos/platform/desktop -I/home/ker/cocos2dx/cocos/platform/linux -I/home/ker/cocos2dx/cocos/audio/include -I/home/ker/cocos2dx/cocos/editor-support -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/auto -I/home/ker/cocos2dx/cocos/scripting/lua-bindings/manual -I/home/ker/cocos2dx/extensions -I/home/ker/cocos2dx/external -I/home/ker/cocos2dx/external/tinyxml2 -I/home/ker/cocos2dx/external/unzip -I/home/ker/cocos2dx/external/edtaa3func -I/home/ker/cocos2dx/external/chipmunk/include/chipmunk -I/home/ker/cocos2dx/external/jpeg/include/linux -I/home/ker/cocos2dx/external/png/include/linux -I/home/ker/cocos2dx/external/tiff/include/linux -I/home/ker/cocos2dx/external/webp/include/linux -I/home/ker/cocos2dx/external/glfw3/include/linux -I/home/ker/cocos2dx/external/freetype2/include/linux -I/home/ker/cocos2dx/external/websockets/include/linux -I/home/ker/cocos2dx/external/xxhash -I/home/ker/cocos2dx/external/xxtea -I/usr/include/GLFW -I/usr/local/include/GLFW -I/home/ker/cocos2dx/external/linux-specific/fmod/include/64-bit -I/home/ker/cocos2dx/cocos/editor-support/spine/..    -o CMakeFiles/spine.dir/CCSkeletonAnimation.cpp.o -c /home/ker/cocos2dx/cocos/editor-support/spine/CCSkeletonAnimation.cpp
Linking CXX static library ../../../lib/libspine.a
cd /home/ker/cocos2dx/ubuntu/cocos/editor-support/spine && /usr/bin/cmake -P CMakeFiles/spine.dir/cmake_clean_target.cmake
cd /home/ker/cocos2dx/ubuntu/cocos/editor-support/spine && /usr/bin/cmake -E cmake_link_script CMakeFiles/spine.dir/link.txt --verbose=1
/usr/bin/ar cr ../../../lib/libspine.a  CMakeFiles/spine.dir/Animation.cpp.o CMakeFiles/spine.dir/AnimationState.cpp.o CMakeFiles/spine.dir/AnimationStateData.cpp.o CMakeFiles/spine.dir/Atlas.cpp.o CMakeFiles/spine.dir/AtlasAttachmentLoader.cpp.o CMakeFiles/spine.dir/Attachment.cpp.o CMakeFiles/spine.dir/AttachmentLoader.cpp.o CMakeFiles/spine.dir/Bone.cpp.o CMakeFiles/spine.dir/BoneData.cpp.o CMakeFiles/spine.dir/BoundingBoxAttachment.cpp.o CMakeFiles/spine.dir/Event.cpp.o CMakeFiles/spine.dir/EventData.cpp.o CMakeFiles/spine.dir/Json.cpp.o CMakeFiles/spine.dir/RegionAttachment.cpp.o CMakeFiles/spine.dir/Skeleton.cpp.o CMakeFiles/spine.dir/SkeletonBounds.cpp.o CMakeFiles/spine.dir/SkeletonData.cpp.o CMakeFiles/spine.dir/SkeletonJson.cpp.o CMakeFiles/spine.dir/Skin.cpp.o CMakeFiles/spine.dir/Slot.cpp.o CMakeFiles/spine.dir/SlotData.cpp.o CMakeFiles/spine.dir/extension.cpp.o CMakeFiles/spine.dir/spine-cocos2dx.cpp.o CMakeFiles/spine.dir/CCSkeleton.cpp.o CMakeFiles/spine.dir/CCSkeletonAnimation.cpp.o
/usr/bin/ranlib ../../../lib/libspine.a
make[2]:正在离开目录 `/home/ker/cocos2dx/ubuntu'
/usr/bin/cmake -E cmake_progress_report /home/ker/cocos2dx/ubuntu/CMakeFiles  95 96 97 98
[ 51%] Built target spine
STRING
STR.each_line do |l|
	if m=/\-c (.*)$/.match(l)
	   puts m [1]
	end
end
=end