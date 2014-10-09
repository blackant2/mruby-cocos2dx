##encoding:utf-8
require 'fileutils'

NDK_ROOT="/home/ker/ndk"
COCOS_ROOT="/home/ker/cocos2dx"
CC="#{NDK_ROOT}/toolchains/llvm-3.4/prebuilt/linux-x86_64/bin/clang++"
AR="#{NDK_ROOT}/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86_64/bin/arm-linux-androideabi-ar"
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
	  		 sh="#{CC}  -MMD -MP -MF objs/#{LIB_NAME}/#{f}.o.d"
	  		 sh<<" -gcc-toolchain #{NDK_ROOT}/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86_64"
	  		 sh<<" -fpic -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes -target armv5te-none-linux-androideabi"
	  		 sh<<" -march=armv5te -mtune=xscale -msoft-float -fno-exceptions -fno-rtti -mthumb -Os -g -DNDEBUG -fomit-frame-pointer"
	  		 sh<<" -fno-strict-aliasing"
	  		 sh<<" -I#{COCOS_ROOT}/external/"
	  		 sh<<" -I#{NDK_ROOT}/sources/cxx-stl/llvm-libc++/libcxx/include"
	  		 sh<<" -I#{NDK_ROOT}/sources/cxx-stl/llvm-libc++/../gabi++/include"
	  		 sh<<" -I#{NDK_ROOT}/sources/cxx-stl/llvm-libc++/../../android/support/include"
	  		 sh<<" -I#{COCOS_ROOT}/external/Box2D"
	  		 sh<<" -DANDROID  -Wa,--noexecstack -Wformat -Werror=format-security -std=c++11"
	  		 sh<<" -frtti -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -fsigned-char -DNDEBUG"
	  		 sh<<"  -I#{NDK_ROOT}/platforms/android-14/arch-arm/usr/include"
	  		 sh<<" -c  #{COCOS_ROOT}/external/Box2D/#{f}"
	  		 sh<<" -o ./objs/#{LIB_NAME}/#{f}.o"
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

