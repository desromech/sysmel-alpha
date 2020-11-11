Extension { #name : #WBTScriptEnvironment }

{ #category : #'*SysmelMoebiusMetamodel-Core' }
WBTScriptEnvironment >> addMatchingNamedSysmelModule [
	^ self objectLibrary: package name with: [ :objectLib |
		package propertyAt: #sysmelModuleTarget put: (objectLib module sysmelModuleTarget
			isNamedSysmelModule: true;
			yourself)
	]
]
