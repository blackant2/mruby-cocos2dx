##encoding:utf-8

require 'fileutils'
NDK_ROOT="/home/ker/ndk"
COCOS_ROOT="/home/ker/cocos2dx"
CC="#{NDK_ROOT}/toolchains/llvm-3.4/prebuilt/linux-x86_64/bin/clang++"
AR="#{NDK_ROOT}/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86_64/bin/arm-linux-androideabi-ar"
LIB_NAME="cocos2d"

LOCAL_SRC_FILES = %w(
cocos2d.cpp 
2d/CCAction.cpp 
2d/CCActionCamera.cpp 
2d/CCActionCatmullRom.cpp 
2d/CCActionEase.cpp 
2d/CCActionGrid.cpp 
2d/CCActionGrid3D.cpp 
2d/CCActionInstant.cpp 
2d/CCActionInterval.cpp 
2d/CCActionManager.cpp 
2d/CCActionPageTurn3D.cpp 
2d/CCActionProgressTimer.cpp 
2d/CCActionTiledGrid.cpp 
2d/CCActionTween.cpp 
2d/CCAnimation.cpp 
2d/CCAnimationCache.cpp 
2d/CCAtlasNode.cpp 
2d/CCClippingNode.cpp 
2d/CCComponent.cpp 
2d/CCComponentContainer.cpp 
2d/CCDrawNode.cpp 
2d/CCDrawingPrimitives.cpp 
2d/CCFont.cpp 
2d/CCFontAtlas.cpp 
2d/CCFontAtlasCache.cpp 
2d/CCFontCharMap.cpp 
2d/CCFontFNT.cpp 
2d/CCFontFreeType.cpp 
2d/CCGLBufferedNode.cpp 
2d/CCGrabber.cpp 
2d/CCGrid.cpp 
2d/CCLabel.cpp 
2d/CCLabelAtlas.cpp 
2d/CCLabelBMFont.cpp 
2d/CCLabelTTF.cpp 
2d/CCLabelTextFormatter.cpp 
2d/CCLayer.cpp 
2d/CCMenu.cpp 
2d/CCMenuItem.cpp 
2d/CCMotionStreak.cpp 
2d/CCNode.cpp 
2d/CCNodeGrid.cpp 
2d/CCParallaxNode.cpp 
2d/CCParticleBatchNode.cpp 
2d/CCParticleExamples.cpp 
2d/CCParticleSystem.cpp 
2d/CCParticleSystemQuad.cpp 
2d/CCProgressTimer.cpp 
2d/CCRenderTexture.cpp 
2d/CCScene.cpp 
2d/CCSprite.cpp 
2d/CCSpriteBatchNode.cpp 
2d/CCSpriteFrame.cpp 
2d/CCSpriteFrameCache.cpp 
2d/CCTMXLayer.cpp 
2d/CCFastTMXLayer.cpp 
2d/CCTMXObjectGroup.cpp 
2d/CCTMXTiledMap.cpp 
2d/CCFastTMXTiledMap.cpp 
2d/CCTMXXMLParser.cpp 
2d/CCTextFieldTTF.cpp 
2d/CCTileMapAtlas.cpp 
2d/CCTransition.cpp 
2d/CCTransitionPageTurn.cpp 
2d/CCTransitionProgress.cpp 
2d/CCTweenFunction.cpp 
3d/CCAnimate3D.cpp 
3d/CCAnimation3D.cpp 
3d/CCBundle3D.cpp 
3d/CCBundleReader.cpp 
3d/CCMesh.cpp 
3d/CCMeshSkin.cpp 
3d/CCSprite3DMaterial.cpp 
3d/CCObjLoader.cpp 
3d/CCSprite3D.cpp 
platform/CCGLViewProtocol.cpp 
platform/CCFileUtils.cpp 
platform/CCSAXParser.cpp 
platform/CCThread.cpp 
platform/CCImage.cpp 
math/CCAffineTransform.cpp 
math/CCGeometry.cpp 
math/CCVertex.cpp 
math/Mat4.cpp 
math/MathUtil.cpp 
math/Quaternion.cpp 
math/TransformUtils.cpp 
math/Vec2.cpp 
math/Vec3.cpp 
math/Vec4.cpp 
base/CCAutoreleasePool.cpp 
base/CCConfiguration.cpp 
base/CCConsole.cpp 
base/CCData.cpp 
base/CCDataVisitor.cpp 
base/CCDirector.cpp 
base/CCEvent.cpp 
base/CCEventAcceleration.cpp 
base/CCEventCustom.cpp 
base/CCEventDispatcher.cpp 
base/CCEventFocus.cpp 
base/CCEventKeyboard.cpp 
base/CCEventController.cpp 
base/CCEventListener.cpp 
base/CCEventListenerController.cpp 
base/CCEventListenerAcceleration.cpp 
base/CCEventListenerCustom.cpp 
base/CCEventListenerFocus.cpp 
base/CCEventListenerKeyboard.cpp 
base/CCEventListenerMouse.cpp 
base/CCEventListenerTouch.cpp 
base/CCEventMouse.cpp 
base/CCEventTouch.cpp 
base/CCIMEDispatcher.cpp 
base/CCNS.cpp 
base/CCProfiling.cpp 
base/CCRef.cpp 
base/CCScheduler.cpp 
base/CCScriptSupport.cpp 
base/CCTouch.cpp 
base/CCUserDefault.cpp 
base/CCUserDefaultAndroid.cpp 
base/CCValue.cpp 
base/TGAlib.cpp 
base/ZipUtils.cpp 
base/atitc.cpp 
base/base64.cpp 
base/ccCArray.cpp 
base/ccFPSImages.c 
base/ccTypes.cpp 
base/ccUTF8.cpp 
base/ccUtils.cpp 
base/etc1.cpp 
base/s3tc.cpp 
base/CCController.cpp 
base/CCController-android.cpp 
base/ObjectFactory.cpp 
renderer/CCBatchCommand.cpp 
renderer/CCCustomCommand.cpp 
renderer/CCGLProgram.cpp 
renderer/CCGLProgramCache.cpp 
renderer/CCGLProgramState.cpp 
renderer/CCGLProgramStateCache.cpp 
renderer/CCGroupCommand.cpp 
renderer/CCQuadCommand.cpp 
renderer/CCMeshCommand.cpp 
renderer/CCRenderCommand.cpp 
renderer/CCRenderer.cpp 
renderer/CCTexture2D.cpp 
renderer/CCTextureAtlas.cpp 
renderer/CCTextureCache.cpp 
renderer/ccGLStateCache.cpp 
renderer/ccShaders.cpp 
deprecated/CCArray.cpp 
deprecated/CCSet.cpp 
deprecated/CCString.cpp 
deprecated/CCDictionary.cpp 
deprecated/CCDeprecated.cpp 
deprecated/CCNotificationCenter.cpp 
physics/CCPhysicsBody.cpp 
physics/CCPhysicsContact.cpp 
physics/CCPhysicsJoint.cpp 
physics/CCPhysicsShape.cpp 
physics/CCPhysicsWorld.cpp 
physics/chipmunk/CCPhysicsBodyInfo_chipmunk.cpp 
physics/chipmunk/CCPhysicsContactInfo_chipmunk.cpp 
physics/chipmunk/CCPhysicsJointInfo_chipmunk.cpp 
physics/chipmunk/CCPhysicsShapeInfo_chipmunk.cpp 
physics/chipmunk/CCPhysicsWorldInfo_chipmunk.cpp
storage/local-storage/LocalStorage.cpp
storage/local-storage/LocalStorageAndroid.cpp)

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
		sh<<" -c  #{COCOS_ROOT}/cocos/#{f}"
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