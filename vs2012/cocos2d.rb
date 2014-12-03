#encoding:utf-8
require 'fileutils'
COCOS_ROOT="F:\\adt\\cocos2d"
CC="cl"
AR="lib"
LIB_NAME="cocos2d"

LOCAL_SRC_FILES = %w(
3d\CCAnimate3D.cpp
3d\CCAnimation3D.cpp
3d\CCBundle3D.cpp
3d\CCBundleReader.cpp
3d\CCMesh.cpp
3d\CCMeshSkin.cpp
3d\CCObjLoader.cpp
3d\CCSprite3D.cpp
3d\CCSprite3DMaterial.cpp
base\atitc.cpp
base\base64.cpp
base\CCAutoreleasePool.cpp
base\ccCArray.cpp
base\CCConfiguration.cpp
base\CCConsole.cpp
base\CCData.cpp
base\CCDataVisitor.cpp
base\CCDirector.cpp
base\CCEvent.cpp
base\CCEventAcceleration.cpp
base\CCEventCustom.cpp
base\CCEventDispatcher.cpp
base\CCEventFocus.cpp
base\CCEventKeyboard.cpp
base\CCEventListener.cpp
base\CCEventListenerAcceleration.cpp
base\CCEventListenerCustom.cpp
base\CCEventListenerFocus.cpp
base\CCEventListenerKeyboard.cpp
base\CCEventListenerMouse.cpp
base\CCEventListenerTouch.cpp
base\CCEventMouse.cpp
base\CCEventTouch.cpp
base\ccFPSImages.c
base\CCIMEDispatcher.cpp
base\CCNS.cpp
base\CCProfiling.cpp
base\CCRef.cpp
base\CCScheduler.cpp
base\CCScriptSupport.cpp
base\CCTouch.cpp
base\ccTypes.cpp
base\CCUserDefault.cpp
base\ccUTF8.cpp
base\ccUtils.cpp
base\CCValue.cpp
base\etc1.cpp
base\ObjectFactory.cpp
base\s3tc.cpp
base\TGAlib.cpp
base\ZipUtils.cpp
cocos2d.cpp
deprecated\CCArray.cpp
deprecated\CCDeprecated.cpp
deprecated\CCDictionary.cpp
deprecated\CCNotificationCenter.cpp
deprecated\CCSet.cpp
deprecated\CCString.cpp
math\CCAffineTransform.cpp
math\CCGeometry.cpp
math\CCVertex.cpp
math\Mat4.cpp
math\MathUtil.cpp
math\Quaternion.cpp
math\TransformUtils.cpp
math\Vec2.cpp
math\Vec3.cpp
math\Vec4.cpp
physics\CCPhysicsBody.cpp
physics\CCPhysicsContact.cpp
physics\CCPhysicsJoint.cpp
physics\CCPhysicsShape.cpp
physics\CCPhysicsWorld.cpp
physics\chipmunk\CCPhysicsBodyInfo_chipmunk.cpp
physics\chipmunk\CCPhysicsContactInfo_chipmunk.cpp
physics\chipmunk\CCPhysicsJointInfo_chipmunk.cpp
physics\chipmunk\CCPhysicsShapeInfo_chipmunk.cpp
physics\chipmunk\CCPhysicsWorldInfo_chipmunk.cpp
renderer\CCBatchCommand.cpp
renderer\CCCustomCommand.cpp
renderer\CCGLProgram.cpp
renderer\CCGLProgramCache.cpp
renderer\CCGLProgramState.cpp
renderer\CCGLProgramStateCache.cpp
renderer\ccGLStateCache.cpp
renderer\CCGroupCommand.cpp
renderer\CCMeshCommand.cpp
renderer\CCQuadCommand.cpp
renderer\CCRenderCommand.cpp
renderer\CCRenderer.cpp
renderer\ccShaders.cpp
renderer\CCTexture2D.cpp
renderer\CCTextureAtlas.cpp
renderer\CCTextureCache.cpp
2d\CCAction.cpp
2d\CCActionCamera.cpp
2d\CCActionCatmullRom.cpp
2d\CCActionEase.cpp
2d\CCActionGrid.cpp
2d\CCActionGrid3D.cpp
2d\CCActionInstant.cpp
2d\CCActionInterval.cpp
2d\CCActionManager.cpp
2d\CCActionPageTurn3D.cpp
2d\CCActionProgressTimer.cpp
2d\CCActionTiledGrid.cpp
2d\CCActionTween.cpp
2d\CCAnimation.cpp
2d\CCAnimationCache.cpp
2d\CCAtlasNode.cpp
2d\CCClippingNode.cpp
2d\CCComponent.cpp
2d\CCComponentContainer.cpp
2d\CCDrawingPrimitives.cpp
2d\CCDrawNode.cpp
2d\CCFastTMXLayer.cpp
2d\CCFastTMXTiledMap.cpp
2d\CCFont.cpp
2d\CCFontAtlas.cpp
2d\CCFontAtlasCache.cpp
2d\CCFontCharMap.cpp
2d\CCFontFNT.cpp
2d\CCFontFreeType.cpp
2d\CCGLBufferedNode.cpp
2d\CCGrabber.cpp
2d\CCGrid.cpp
2d\CCLabel.cpp
2d\CCLabelAtlas.cpp
2d\CCLabelBMFont.cpp
2d\CCLabelTextFormatter.cpp
2d\CCLabelTTF.cpp
2d\CCLayer.cpp
2d\CCMenu.cpp
2d\CCMenuItem.cpp
2d\CCMotionStreak.cpp
2d\CCNode.cpp
2d\CCNodeGrid.cpp
2d\CCParallaxNode.cpp
2d\CCParticleBatchNode.cpp
2d\CCParticleExamples.cpp
2d\CCParticleSystem.cpp
2d\CCParticleSystemQuad.cpp
2d\CCProgressTimer.cpp
2d\CCRenderTexture.cpp
2d\CCScene.cpp
2d\CCSprite.cpp
2d\CCSpriteBatchNode.cpp
2d\CCSpriteFrame.cpp
2d\CCSpriteFrameCache.cpp
2d\CCTextFieldTTF.cpp
2d\CCTileMapAtlas.cpp
2d\CCTMXLayer.cpp
2d\CCTMXObjectGroup.cpp
2d\CCTMXTiledMap.cpp
2d\CCTMXXMLParser.cpp
2d\CCTransition.cpp
2d\CCTransitionPageTurn.cpp
2d\CCTransitionProgress.cpp
2d\CCTweenFunction.cpp
)


sh=<<CMD
cl
/c
/I"C:\\Program Files (x86)\\Microsoft SDKs\\Windows\\v7.1A\\include"
/I#{COCOS_ROOT}\\external\\sqlite3\\include
/I#{COCOS_ROOT}\\external\\unzip
/I#{COCOS_ROOT}\\external\\edtaa3func
/I#{COCOS_ROOT}\\external\\tinyxml2
/I#{COCOS_ROOT}\\external\\png\\include\\win32
/I#{COCOS_ROOT}\\external\\jpeg\\include\\win32
/I#{COCOS_ROOT}\\external\\tiff\\include\\win32
/I#{COCOS_ROOT}\\external\\webp\\include\\win32
/I#{COCOS_ROOT}\\external\\freetype2\\include\\win32
/I"#{COCOS_ROOT}\\external\\win32-specific\\icon\\include"
/I"#{COCOS_ROOT}\\external\\win32-specific\\zlib\\include"
/I#{COCOS_ROOT}\\external\\chipmunk\\include\\chipmunk
/I#{COCOS_ROOT}\\external\\xxhash
/I#{COCOS_ROOT}\\external\\ConvertUTF
/I#{COCOS_ROOT}\\external
/I#{COCOS_ROOT}\\cocos
/I#{COCOS_ROOT}\\cocos\\platform\\win32
/I#{COCOS_ROOT}\\cocos\\platform\\desktop
/I#{COCOS_ROOT}\\external\\glfw3\\include\\win32
/I"#{COCOS_ROOT}\\external\\win32-specific\\gles\\include\\OGLES"
/W3
/WX-
/MP
/O1
/Oy-
/D WIN32
/D NDEBUG
/D _WINDOWS
/D _LIB
/D COCOS2DXWIN32_EXPORTS
/D GL_GLEXT_PROTOTYPES
/D _CRT_SECURE_NO_WARNINGS
/D _SCL_SECURE_NO_WARNINGS
/D _VARIADIC_MAX=10
/D _USING_V110_SDK71_
/D _UNICODE
/D UNICODE
/Gm-
/EHsc
/MD
/GS
/fp:precise
/Zc:wchar_t
/Zc:forScope
/Gd
/TP
/wd4267
/wd4251
/wd4244
/analyze-
/errorReport:prompt
CMD
sh.gsub!("\n"," ")

FileUtils.mkdir_p("objs\\#{LIB_NAME}") unless Dir.exists?("objs\\#{LIB_NAME}")
LOCAL_SRC_FILES.each do |f| 
	cmd=sh
	if f.include?('\\')
	  i=f.rindex('\\')
	  FileUtils.mkdir_p "objs\\#{LIB_NAME}\\#{f[0,i]}" unless Dir.exists? "objs\\#{LIB_NAME}\\#{f[0,i]}"
	  cmd+="/Fo\".\\objs\\#{LIB_NAME}\\#{f[0,i]}\\\\\" "
  	else
  	  cmd+="/Fo\".\\objs\\#{LIB_NAME}\\\\\" "
  	end
  	next if File.exists? "objs\\#{LIB_NAME}\\#{f.gsub(/\.c(pp)?$/,'.obj')}"
	cmd+=" #{COCOS_ROOT}\\cocos\\"+f
	puts cmd
	system cmd 
end

FileUtils.mkdir_p("lib") unless Dir.exists?("lib")
sh="#{AR} "
LOCAL_SRC_FILES.each do |f| 
	sh<<"  .\\objs\\#{LIB_NAME}\\#{f.sub(/\.c(pp)?$/,'.obj')}"
end
sh<<" /OUT:lib/#{LIB_NAME}.lib"
puts sh
system sh
