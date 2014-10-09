##encoding:utf-8

require 'fileutils'
NDK_ROOT="/home/ker/ndk"
COCOS_ROOT="/home/ker/cocos2dx"
CC="#{NDK_ROOT}/toolchains/llvm-3.4/prebuilt/linux-x86_64/bin/clang"
AR="#{NDK_ROOT}/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86_64/bin/arm-linux-androideabi-ar"
LIB_NAME="chipmunk"

LOCAL_SRC_FILES = %w(
src/chipmunk.c
src/cpArbiter.c
src/cpArray.c
src/cpBB.c
src/cpBBTree.c
src/cpBody.c
src/cpCollision.c
src/cpHashSet.c
src/cpPolyShape.c
src/cpShape.c
src/cpSpace.c
src/cpSpaceComponent.c
src/cpSpaceHash.c
src/cpSpaceQuery.c
src/cpSpaceStep.c
src/cpSpatialIndex.c
src/cpSweep1D.c
src/cpVect.c
src/constraints/cpConstraint.c
src/constraints/cpDampedRotarySpring.c
src/constraints/cpDampedSpring.c
src/constraints/cpGearJoint.c
src/constraints/cpGrooveJoint.c
src/constraints/cpPinJoint.c
src/constraints/cpPivotJoint.c
src/constraints/cpRatchetJoint.c
src/constraints/cpRotaryLimitJoint.c
src/constraints/cpSimpleMotor.c
src/constraints/cpSlideJoint.c)

FileUtils.mkdir_p("objs/#{LIB_NAME}") unless Dir.exists?("objs/#{LIB_NAME}")
LOCAL_SRC_FILES.each do |f|
	if f.include?('/')
	  i=f.rindex('/')
	  FileUtils.mkdir_p "objs/#{LIB_NAME}/#{f[0,i]}" unless Dir.exists? "objs/#{LIB_NAME}/#{f[0,i]}"
  end
  sh="#{CC} -MMD -MP -MF ./objs/#{LIB_NAME}/#{f}.o.d "
 sh<<" -gcc-toolchain #{NDK_ROOT}/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86_64"
 sh<<" -fpic -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes -target armv5te-none-linux-androideabi -march=armv5te -mtune=xscale -msoft-float -mthumb -Os -g -DNDEBUG -fomit-frame-pointer -fno-strict-aliasing"
 sh<<" -I#{COCOS_ROOT}/external/chipmunk/include/chipmunk"
 sh<<" -I#{COCOS_ROOT}/external/chipmunk"
 sh<<" -DANDROID -std=c99 -Wa,--noexecstack -Wformat -Werror=format-security"
 sh<<" -I#{NDK_ROOT}/platforms/android-14/arch-arm/usr/include"
 sh<<" -c #{COCOS_ROOT}/external/chipmunk/#{f}"
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
