Class {
	#name : #MbndSysmelSampleBuildScripts,
	#superclass : #Object,
	#category : #'SysmelMoebiusMetamodel-Core-Samples'
}

{ #category : #samples }
MbndSysmelSampleBuildScripts class >> buildHelloWorld [
	<example>
	self newNoRTTIBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			packageScript programWithSource: 'samples/cpu/hello.sysmel'
		]
]

{ #category : #samples }
MbndSysmelSampleBuildScripts class >> buildRuntimeLibrariesTests [
	<example>
	self newNoRTTIBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			packageScript programWithSource: 'tests/RuntimeLibrariesTests.sysmel'
		]
]

{ #category : #samples }
MbndSysmelSampleBuildScripts class >> buildSampleBitmapRendering [
	<example>
	self newNoRTTIBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			packageScript programWithSource: 'samples/cpu/sampleBitmapRendering.sysmel'
		]
]

{ #category : #samples }
MbndSysmelSampleBuildScripts class >> buildSampleNorphic [
	<example>
	self newNoRTTIBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			packageScript guiProgramWithSource: 'samples/cpu/sampleNorphic.sysmel'
		]
]

{ #category : #samples }
MbndSysmelSampleBuildScripts class >> buildSamplePlatformer [
	<example>
	self newNoRTTIBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			packageScript guiProgramWithSource: 'samples/cpu/samplePlatformer.sysmel'
		]
]

{ #category : #samples }
MbndSysmelSampleBuildScripts class >> buildSampleReflection [
	<example>
	self newNoRTTIBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			packageScript guiProgramWithSource: 'samples/cpu/sampleReflection.sysmel'
		]
]

{ #category : #samples }
MbndSysmelSampleBuildScripts class >> buildSampleRendering2D [
	<example>
	self newNoRTTIBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			packageScript guiProgramWithSource: 'samples/cpu/sampleRendering2D.sysmel'
		]
]

{ #category : #samples }
MbndSysmelSampleBuildScripts class >> buildSampleRendering3D [
	<example>
	self newNoRTTIBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			packageScript guiProgramWithSource: 'samples/cpu/sampleRendering3D.sysmel'
		]
]

{ #category : #samples }
MbndSysmelSampleBuildScripts class >> newNoRTTIBuildEnvironment [
	^ WBTBuildEnvironment forCurrentPlatformWithLLD
		setReleaseWithDebugInfoBuildMode;
		buildDirectory: 'build-sysmel-nortti';
		setSysmelSettingsWith: [ :settings | settings noRTTI ];
		yourself
]

{ #category : #samples }
MbndSysmelSampleBuildScripts class >> sysmelParserTool [
	<example>
	self newNoRTTIBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			packageScript programWithSource: 'tools/sysmelParser.sysmel'
		].
]

{ #category : #samples }
MbndSysmelSampleBuildScripts class >> sysmelSmalltalkParserTool [
	<example>
	self newNoRTTIBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			packageScript programWithSource: 'tools/sysmelSmalltalkParser.sysmel'
		].
]

{ #category : #samples }
MbndSysmelSampleBuildScripts class >> textureTool [
	<example>
	| prog |
	self newNoRTTIBuildEnvironment
		buildMainPackageInFolder: MbndCoreAssets location with: [ :packageScript |
			prog := packageScript programWithSource: 'tools/sysmelTextureTool.sysmel'
		].
	^ prog asFileReference asAbsolute canonicalize
]

{ #category : #'see class side' }
MbndSysmelSampleBuildScripts >> seeClassSide [
]
