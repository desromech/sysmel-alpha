Class {
	#name : #MbndSysmelSampleBuildScripts,
	#superclass : #Object,
	#category : #'SysmelMoebiusMetamodel-Core-Samples'
}

{ #category : #'gc samples' }
MbndSysmelSampleBuildScripts class >> buildGCHelloWorld [
	<example>
	self newGCBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			packageScript programWithSource: 'samples/cpu/gc-hello.sysmel'
		]
]

{ #category : #'native samples' }
MbndSysmelSampleBuildScripts class >> buildNativeHelloWorld [
	<example>
	self newNativeBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			packageScript programWithSource: 'samples/cpu/hello.sysmel'
		]
]

{ #category : #'native samples' }
MbndSysmelSampleBuildScripts class >> buildNativeRuntimeLibrariesTests [
	<example>
	self newNativeBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			packageScript programWithSource: 'tests/RuntimeLibrariesTests.sysmel'
		]
]

{ #category : #'native samples' }
MbndSysmelSampleBuildScripts class >> buildSampleNativeBitmapRendering [
	<example>
	self newNativeBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			packageScript programWithSource: 'samples/cpu/sampleNativeBitmapRendering.sysmel'
		]
]

{ #category : #'native samples' }
MbndSysmelSampleBuildScripts class >> buildSampleNativeGame [
	<example>
	self newNativeBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			packageScript guiProgramWithSource: 'samples/cpu/sampleNativeGame.sysmel'
		]
]

{ #category : #'native samples' }
MbndSysmelSampleBuildScripts class >> buildSampleNativeNorphic [
	<example>
	self newNativeBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			packageScript guiProgramWithSource: 'samples/cpu/sampleNativeNorphic.sysmel'
		]
]

{ #category : #'native samples' }
MbndSysmelSampleBuildScripts class >> buildSampleNativeRendering2D [
	<example>
	self newNativeBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			packageScript guiProgramWithSource: 'samples/cpu/sampleNativeRendering2D.sysmel'
		]
]

{ #category : #'native samples' }
MbndSysmelSampleBuildScripts class >> buildSampleNativeRendering3D [
	<example>
	self newNativeBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			packageScript guiProgramWithSource: 'samples/cpu/sampleNativeRendering3D.sysmel'
		]
]

{ #category : #'gc samples' }
MbndSysmelSampleBuildScripts class >> buildSampleNorphicIDE [
	<example>
	self newGCBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			packageScript programWithSource: 'samples/cpu/sampleNorphicIDE.sysmel'
		]
]

{ #category : #'gc samples' }
MbndSysmelSampleBuildScripts class >> buildSmalltalkParser [
	<example>
	self newGCBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			packageScript programWithSource: 'samples/cpu/smalltalkParser.sysmel'
		]
]

{ #category : #'gc samples' }
MbndSysmelSampleBuildScripts class >> newGCBuildEnvironment [
	^ WBTBuildEnvironment forCurrentPlatformWithClang
		setReleaseWithDebugInfoBuildMode;
		buildDirectory: 'build-sysmel-gc';
		setSysmelSettingsWith: [ :settings | ];
		yourself
]

{ #category : #'native samples' }
MbndSysmelSampleBuildScripts class >> newNativeBuildEnvironment [
	^ WBTBuildEnvironment forCurrentPlatformWithLLD
		setReleaseWithDebugInfoBuildMode;
		buildDirectory: 'build-sysmel-native';
		setSysmelSettingsWith: [ :settings | settings noRTTI ];
		yourself
]

{ #category : #'see class side' }
MbndSysmelSampleBuildScripts >> seeClassSide [
]
