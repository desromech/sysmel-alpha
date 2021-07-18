Class {
	#name : #MbndSysmelUWPSampleBuildScripts,
	#superclass : #MbndSysmelSampleBuildScripts,
	#category : #'SysmelMoebiusMetamodel-Core-Samples'
}

{ #category : #'native samples' }
MbndSysmelUWPSampleBuildScripts class >> buildHelloWorld [
	<example>
	self newNoRTTIBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			packageScript bundleWithSource: 'samples/cpu/hello.sysmel'
		]
]

{ #category : #'native samples' }
MbndSysmelUWPSampleBuildScripts class >> buildRuntimeLibrariesTests [
	<example>
	self newNoRTTIBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			packageScript bundleWithSource: 'tests/RuntimeLibrariesTests.sysmel'
		]
]

{ #category : #'native samples' }
MbndSysmelUWPSampleBuildScripts class >> buildSampleNorphic [
	<example>
	self newNoRTTIBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			packageScript guiBundleWithSource: 'samples/cpu/sampleNorphic.sysmel'
		]

]

{ #category : #'native samples' }
MbndSysmelUWPSampleBuildScripts class >> buildSamplePlatformer [
	<example>
	self newNoRTTIBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			packageScript guiBundleWithSource: 'samples/cpu/samplePlatformer.sysmel'
		]

]

{ #category : #'native samples' }
MbndSysmelUWPSampleBuildScripts class >> buildSampleRendering2D [
	<example>
	self newNoRTTIBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			packageScript guiBundleWithSource: 'samples/cpu/sampleRendering2D.sysmel'
		]

]

{ #category : #'native samples' }
MbndSysmelUWPSampleBuildScripts class >> buildSampleRendering3D [
	<example>
	self newNoRTTIBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			packageScript guiBundleWithSource: 'samples/cpu/sampleRendering3D.sysmel'
		]

]

{ #category : #'native samples' }
MbndSysmelUWPSampleBuildScripts class >> newNoRTTIBuildEnvironment [
	^ WBTBuildEnvironment forUWPLLDX64
		setReleaseWithDebugInfoBuildMode;
		buildDirectory: 'build-sysmel-uwp-native';
		setSysmelSettingsWith: [ :settings | settings noRTTI ];
		yourself
]

{ #category : #'see class side' }
MbndSysmelUWPSampleBuildScripts >> seeClassSide [
]
