Extension { #name : #WBTPackage }

{ #category : #'*SysmelMoebiusMetamodel-Core' }
WBTPackage >> sysmelModuleTarget [
	^ self propertyAt: #sysmelModuleTarget
]

{ #category : #'*SysmelMoebiusMetamodel-Core' }
WBTPackage >> validBuildSysmelCacheDirectory [
	^ self buildEnvironment validBuildSysmelCacheDirectory
]
