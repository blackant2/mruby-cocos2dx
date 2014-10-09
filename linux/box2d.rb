##encoding:utf-8

require 'fileutils'
COCOS_ROOT="/home/ker/cocos2dx"
CC="c++"
AR="ar"
LIB_NAME="box2d"


LOCAL_SRC_FILES = %w(
Collision/b2BroadPhase.cpp
Collision/b2CollideCircle.cpp
Collision/b2CollideEdge.cpp
Collision/b2CollidePolygon.cpp
Collision/b2Collision.cpp
Collision/b2Distance.cpp
Collision/b2DynamicTree.cpp
Collision/b2TimeOfImpact.cpp
Collision/Shapes/b2ChainShape.cpp
Collision/Shapes/b2CircleShape.cpp
Collision/Shapes/b2EdgeShape.cpp
Collision/Shapes/b2PolygonShape.cpp
Common/b2BlockAllocator.cpp
Common/b2Draw.cpp
Common/b2Math.cpp
Common/b2Settings.cpp
Common/b2StackAllocator.cpp
Common/b2Timer.cpp
Dynamics/b2Body.cpp
Dynamics/b2ContactManager.cpp
Dynamics/b2Fixture.cpp
Dynamics/b2Island.cpp
Dynamics/b2World.cpp
Dynamics/b2WorldCallbacks.cpp
Dynamics/Contacts/b2ChainAndCircleContact.cpp
Dynamics/Contacts/b2ChainAndPolygonContact.cpp
Dynamics/Contacts/b2CircleContact.cpp
Dynamics/Contacts/b2Contact.cpp
Dynamics/Contacts/b2ContactSolver.cpp
Dynamics/Contacts/b2EdgeAndCircleContact.cpp
Dynamics/Contacts/b2EdgeAndPolygonContact.cpp
Dynamics/Contacts/b2PolygonAndCircleContact.cpp
Dynamics/Contacts/b2PolygonContact.cpp
Dynamics/Joints/b2DistanceJoint.cpp
Dynamics/Joints/b2FrictionJoint.cpp
Dynamics/Joints/b2GearJoint.cpp
Dynamics/Joints/b2Joint.cpp
Dynamics/Joints/b2MotorJoint.cpp
Dynamics/Joints/b2MouseJoint.cpp
Dynamics/Joints/b2PrismaticJoint.cpp
Dynamics/Joints/b2PulleyJoint.cpp
Dynamics/Joints/b2RevoluteJoint.cpp
Dynamics/Joints/b2RopeJoint.cpp
Dynamics/Joints/b2WeldJoint.cpp
Dynamics/Joints/b2WheelJoint.cpp
Rope/b2Rope.cpp)



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
		sh<<" -I#{COCOS_ROOT}/external/Box2D/..   "
		sh<<" -o objs/#{LIB_NAME}/#{f}.o "
		sh<<" -c #{COCOS_ROOT}/external/Box2D/#{f}"
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