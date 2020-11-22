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
			packageScript programWithSource: 'tests/RuntimeLibrariesTests.sysmel'
		]
]

{ #category : #'native samples' }
MbndSysmelUWPSampleBuildScripts class >> newNativeBuildEnvironment [
	^ WBTBuildEnvironment forUWPClangX64
		setReleaseWithDebugInfoBuildMode;
		buildDirectory: 'build-sysmel-uwp-native';
		setSysmelSettingsWith: [ :settings | settings noRTTI ];
		yourself
]

{ #category : #'see class side' }
MbndSysmelUWPSampleBuildScripts >> seeClassSide [
]
