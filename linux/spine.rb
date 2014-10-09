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


