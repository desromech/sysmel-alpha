Class {
	#name : #MbndSysmelEmscriptenSampleBuildScripts,
	#superclass : #MbndSysmelSampleBuildScripts,
	#category : #'SysmelMoebiusMetamodel-Core-Samples'
}

{ #category : #'native samples' }
MbndSysmelEmscriptenSampleBuildScripts class >> buildNativeHelloWorld [
	<example>
	^ super buildNativeHelloWorld
]

{ #category : #'native samples' }
MbndSysmelEmscriptenSampleBuildScripts class >> buildNativeRuntimeLibrariesTests [
	<example>
	^ super buildNativeRuntimeLibrariesTests
]

{ #category : #'native samples' }
MbndSysmelEmscriptenSampleBuildScripts class >> buildSampleNativeGame [
	<example>
	^ super buildSampleNativeGame
]

{ #category : #'native samples' }
MbndSysmelEmscriptenSampleBuildScripts class >> buildSampleNativeNorphic [
	<example>
	^ super buildSampleNativeNorphic
]

{ #category : #'native samples' }
MbndSysmelEmscriptenSampleBuildScripts class >> buildSampleNativeRendering2D [
	<example>
	^ super buildSampleNativeRendering2D
]

{ #category : #'native samples' }
MbndSysmelEmscriptenSampleBuildScripts class >> buildSampleNativeRendering3D [
	<example>
	^ super buildSampleNativeRendering3D
]

{ #category : #'native samples' }
MbndSysmelEmscriptenSampleBuildScripts class >> newNativeBuildEnvironment [
	^ WBTBuildEnvironment forEmscripten
		setReleaseWithDebugInfoBuildMode;
		buildDirectory: 'build-sysmel-emscripten';
		setSysmelSettingsWith: [ :settings | settings noRTTI ];
		yourself
]

{ #category : #'see class side' }
MbndSysmelEmscriptenSampleBuildScripts >> seeClassSide [
]
