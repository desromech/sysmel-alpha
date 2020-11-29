Class {
	#name : #MbndSysmelUWPSampleBuildScripts,
	#superclass : #MbndSysmelSampleBuildScripts,
	#category : #'SysmelMoebiusMetamodel-Core-Samples'
}

{ #category : #'native samples' }
MbndSysmelUWPSampleBuildScripts class >> buildNativeHelloWorld [
	<example>
	self newNativeBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			packageScript bundleWithSource: 'samples/cpu/hello.sysmel'
		]
]

{ #category : #'native samples' }
MbndSysmelUWPSampleBuildScripts class >> buildNativeRuntimeLibrariesTests [
	<example>
	self newNativeBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			packageScript bundleWithSource: 'tests/RuntimeLibrariesTests.sysmel'
		]
]

{ #category : #'native samples' }
MbndSysmelUWPSampleBuildScripts class >> buildSampleNativeGame [
	<example>
	self newNativeBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			packageScript guiBundleWithSource: 'samples/cpu/sampleNativeGame.sysmel'
		]

]

{ #category : #'native samples' }
MbndSysmelUWPSampleBuildScripts class >> buildSampleNativeNorphic [
	<example>
	self newNativeBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			packageScript guiBundleWithSource: 'samples/cpu/sampleNativeNorphic.sysmel'
		]

]

{ #category : #'native samples' }
MbndSysmelUWPSampleBuildScripts class >> buildSampleNativeRendering2D [
	<example>
	self newNativeBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			packageScript guiBundleWithSource: 'samples/cpu/sampleNativeRendering2D.sysmel'
		]

]

{ #category : #'native samples' }
MbndSysmelUWPSampleBuildScripts class >> buildSampleNativeRendering3D [
	<example>
	self newNativeBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			packageScript guiBundleWithSource: 'samples/cpu/sampleNativeRendering3D.sysmel'
		]

]

{ #category : #'native samples' }
MbndSysmelUWPSampleBuildScripts class >> newNativeBuildEnvironment [
	^ WBTBuildEnvironment forUWPLLDX64
		setReleaseWithDebugInfoBuildMode;
		buildDirectory: 'build-sysmel-uwp-native';
		setSysmelSettingsWith: [ :settings | settings noRTTI ];
		yourself
]

{ #category : #'see class side' }
MbndSysmelUWPSampleBuildScripts >> seeClassSide [
]
