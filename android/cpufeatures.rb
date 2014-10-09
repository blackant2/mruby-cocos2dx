##encoding:utf-8
require 'fileutils'

NDK_ROOT="/home/ker/ndk"
COCOS_ROOT="/home/ker/cocos2dx"
CC="#{NDK_ROOT}/toolchains/llvm-3.4/prebuilt/linux-x86_64/bin/clang"
AR="#{NDK_ROOT}/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86_64/bin/arm-linux-androideabi-ar"
LIB_NAME="cpufeatures"

LOCAL_SRC_FILES =%w(cpu-features)
FileUtils.mkdir_p("objs/#{LIB_NAME}") unless Dir.exists?("objs/#{LIB_NAME}")
LOCAL_SRC_FILES.each do |f|
   	sh="#{CC} -MMD -MP -MF objs/#{LIB_NAME}/#{f}.o.d"
   	sh<<" -gcc-toolchain #{NDK_ROOT}/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86_64"
		sh<<" -fpic"
		sh<<" -ffunction-sections"
		sh<<" -funwind-tables"
		sh<<" -fstack-protector"
		sh<<" -no-canonical-prefixes"
		sh<<" -target armv5te-none-linux-androideabi"
		sh<<" -march=armv5te"
		sh<<" -mtune=xscale"
		sh<<" -msoft-float"
		sh<<" -mthumb"
		sh<<" -Os"
		sh<<" -g"
		sh<<" -DNDEBUG"
		sh<<" -fomit-frame-pointer"
		sh<<" -fno-strict-aliasing"
		sh<<" -I#{NDK_ROOT}/sources/android/cpufeatures"
		sh<<" -DANDROID "
		sh<<" -Wa,--noexecstack"
		sh<<" -Wformat"
		sh<<" -Werror=format-security   "
		sh<<" -I#{NDK_ROOT}/platforms/android-14/arch-arm/usr/include"
		sh<<" -c  #{NDK_ROOT}/sources/android/cpufeatures/#{f}.c"
		sh<<" -o objs/#{LIB_NAME}/#{f}.o"
		puts sh
		system sh
end

sh="#{AR} crsD lib/lib#{LIB_NAME}.a"
LOCAL_SRC_FILES.each do |f|
	  sh<<" ./objs/#{LIB_NAME}/#{f}.o"
end
puts sh
system sh
=begin
[armeabi] Compile thumb  : cpufeatures <= cpu-features.c
/home/ker/ndk/toolchains/llvm-3.4/prebuilt/linux-x86_64/bin/clang
-MMD -MP -MF ./obj/local/armeabi/objs/cpufeatures/cpu-features.o.d 
-gcc-toolchain #{NDK_ROOT}/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86_64
-fpic
-ffunction-sections
-funwind-tables
-fstack-protector
-no-canonical-prefixes
-target armv5te-none-linux-androideabi
-march=armv5te
-mtune=xscale
-msoft-float
-mthumb
-Os
-g
-DNDEBUG
-fomit-frame-pointer
-fno-strict-aliasing
-I#{NDK_ROOT}/sources/android/cpufeatures
-DANDROID 
-Wa,--noexecstack
-Wformat
-Werror=format-security   
-I#{NDK_ROOT}/platforms/android-14/arch-arm/usr/include
-c  #{NDK_ROOT}/sources/android/cpufeatures/cpu-features.c
-o ./obj/local/armeabi/objs/cpufeatures/cpu-features.o 
[armeabi] StaticLibrary  : libcpufeatures.a
rm
-f obj/local/armeabi/libcpufeatures.a
/home/ker/ndk/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86_64/bin/arm-linux-androideabi-ar
crsD ./obj/local/armeabi/libcpufeatures.a
./obj/local/armeabi/objs/cpufeatures/cpu-features.o

=end