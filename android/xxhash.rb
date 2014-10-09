##encoding:utf-8

require 'fileutils'
NDK_ROOT="/home/ker/ndk"
COCOS_ROOT="/home/ker/cocos2dx"
CC="#{NDK_ROOT}/toolchains/llvm-3.4/prebuilt/linux-x86_64/bin/clang++"
AR="#{NDK_ROOT}/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86_64/bin/arm-linux-androideabi-ar"
LIB_NAME="xxhash"

LOCAL_SRC_FILES = %w(
xxhash.c
)

FileUtils.mkdir_p("objs/#{LIB_NAME}") unless Dir.exists?("objs/#{LIB_NAME}")
LOCAL_SRC_FILES.each do |f|
	if f.include?('/')
	  i=f.rindex('/')
	  FileUtils.mkdir_p "objs/#{LIB_NAME}/#{f[0,i]}" unless Dir.exists? "objs/#{LIB_NAME}/#{f[0,i]}"
  end
  sh="#{CC}  -MMD -MP -MF objs/#{LIB_NAME}/#{f}.o.d "
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
		sh<<" -fno-exceptions"
		sh<<" -fno-rtti"
		sh<<" -mthumb"
		sh<<" -Os"
		sh<<" -g"
		sh<<" -DNDEBUG"
		sh<<" -fomit-frame-pointer"
		sh<<" -fno-strict-aliasing"
		sh<<" -I#{COCOS_ROOT}/cocos/."
		sh<<" -I#{COCOS_ROOT}/cocos/./."
		sh<<" -I#{COCOS_ROOT}/cocos/./platform/android"
		sh<<" -I#{COCOS_ROOT}/cocos/./../external"
		sh<<" -I#{COCOS_ROOT}/cocos/./../external/tinyxml2"
		sh<<" -I#{COCOS_ROOT}/cocos/./../external/unzip"
		sh<<" -I#{COCOS_ROOT}/cocos/./../external/chipmunk/include/chipmunk"
		sh<<" -I#{COCOS_ROOT}/cocos/./../external/edtaa3func"
		sh<<" -I#{COCOS_ROOT}/cocos/./../external/xxhash"
		sh<<" -I#{COCOS_ROOT}/cocos/./../external/ConvertUTF"
		sh<<" -I#{COCOS_ROOT}/cocos/./../external/nslog"
		sh<<" -I#{NDK_ROOT}/sources/cxx-stl/llvm-libc++/libcxx/include"
		sh<<" -I#{NDK_ROOT}/sources/cxx-stl/llvm-libc++/../gabi++/include"
		sh<<" -I#{NDK_ROOT}/sources/cxx-stl/llvm-libc++/../../android/support/include"
		sh<<" -I#{COCOS_ROOT}/external/freetype2/prebuilt/android/../../include/android"
		sh<<" -I#{COCOS_ROOT}/external/freetype2/prebuilt/android/../../include/android/freetype2"
		sh<<" -I#{COCOS_ROOT}/external/chipmunk/include/chipmunk"
		sh<<" -I#{COCOS_ROOT}/cocos/platform/android"
		sh<<" -I#{COCOS_ROOT}/external/png/prebuilt/android/../../include/android"
		sh<<" -I#{COCOS_ROOT}/external/jpeg/prebuilt/android/../../include/android"
		sh<<" -I#{COCOS_ROOT}/external/tiff/prebuilt/android/../../include/android"
		sh<<" -I#{COCOS_ROOT}/external/webp/prebuilt/android/../../include/android"
		sh<<" -I#{NDK_ROOT}/sources/android/cpufeatures"
		sh<<" -I#{COCOS_ROOT}/cocos/."
		sh<<" -DANDROID"
		sh<<" -DUSE_FILE32API"
		sh<<" -Wa,--noexecstack"
		sh<<" -Wformat"
		sh<<" -Werror=format-security"
		sh<<" -std=c++11"
		sh<<" -Wno-deprecated-declarations"
		sh<<" -Wno-extern-c-compat  "
		sh<<" -frtti"
		sh<<" -DCC_ENABLE_CHIPMUNK_INTEGRATION=1"
		sh<<" -std=c++11"
		sh<<" -fsigned-char"
		sh<<" -DNDEBUG "
		sh<<" -I#{NDK_ROOT}/platforms/android-14/arch-arm/usr/include"
		sh<<" -c  #{COCOS_ROOT}/external/xxhash/#{f}"
		sh<<" -o  objs/#{LIB_NAME}/#{f}.o "
		puts sh
		system sh

end



FileUtils.mkdir_p("lib") unless Dir.exists?("lib")
sh="#{AR} crsD lib/lib#{LIB_NAME}.a"
LOCAL_SRC_FILES.each do |f|
	  sh<<"  ./objs/#{LIB_NAME}/#{f}.o"
end
puts sh
system sh
