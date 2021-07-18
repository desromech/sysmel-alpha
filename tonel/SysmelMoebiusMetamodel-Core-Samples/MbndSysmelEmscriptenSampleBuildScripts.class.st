Class {
	#name : #MbndSysmelEmscriptenSampleBuildScripts,
	#superclass : #MbndSysmelSampleBuildScripts,
	#category : #'SysmelMoebiusMetamodel-Core-Samples'
}

{ #category : #'native samples' }
MbndSysmelEmscriptenSampleBuildScripts class >> buildHelloWorld [
	<example>
	^ super buildHelloWorld
]

{ #category : #'native samples' }
MbndSysmelEmscriptenSampleBuildScripts class >> buildRuntimeLibrariesTests [
	<example>
	^ super buildRuntimeLibrariesTests
]

{ #category : #'native samples' }
MbndSysmelEmscriptenSampleBuildScripts class >> buildSampleNorphic [
	<example>
	^ super buildSampleNorphic
]

{ #category : #'native samples' }
MbndSysmelEmscriptenSampleBuildScripts class >> buildSamplePlatformer [
	<example>
	^ super buildSamplePlatformer
]

{ #category : #'native samples' }
MbndSysmelEmscriptenSampleBuildScripts class >> buildSampleRendering2D [
	<example>
	^ super buildSampleRendering2D
]

{ #category : #'native samples' }
MbndSysmelEmscriptenSampleBuildScripts class >> buildSampleRendering3D [
	<example>
	^ super buildSampleRendering3D
]

{ #category : #'native samples' }
MbndSysmelEmscriptenSampleBuildScripts class >> newNoRTTIBuildEnvironment [
	^ WBTBuildEnvironment forEmscripten
		setReleaseWithDebugInfoBuildMode;
		buildDirectory: 'build-sysmel-emscripten';
		setSysmelSettingsWith: [ :settings | settings noRTTI ];
		yourself
]

{ #category : #'see class side' }
MbndSysmelEmscriptenSampleBuildScripts >> seeClassSide [
]
