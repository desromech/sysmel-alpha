Extension { #name : #WBTBuildEnvironment }

{ #category : #'*SysmelMoebiusMetamodel-Core' }
WBTBuildEnvironment >> getOrLoadSysmelModulePackage: sysmelModulePackageName [
	^ packages at: sysmelModulePackageName ifAbsent: [ self loadSysmelModulePackageNamed: sysmelModulePackageName ]
]

{ #category : #'*SysmelMoebiusMetamodel-Core' }
WBTBuildEnvironment >> loadSysmelModulePackageNamed: sysmelModulePackageName [
	^ self addPackageNamed: sysmelModulePackageName with: [ :packageScript |
		packageScript addMatchingNamedSysmelModule
	]
]

{ #category : #'*SysmelMoebiusMetamodel-Core' }
WBTBuildEnvironment >> setSysmelSettingsWith: aBlock [
	self hostPlatform setSysmelSettingsWith: aBlock.

]

{ #category : #'*SysmelMoebiusMetamodel-Core' }
WBTBuildEnvironment >> validBuildSysmelCacheDirectory [
	^ self validBuildCacheDirectory / 'sysmel'
]
