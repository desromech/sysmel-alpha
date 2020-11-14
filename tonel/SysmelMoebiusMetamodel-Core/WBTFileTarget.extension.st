Extension { #name : #WBTFileTarget }

{ #category : #'*SysmelMoebiusMetamodel-Core' }
WBTFileTarget >> isSysmelObjectFileTarget [
	^ self isObjectFile and: [ dependencies isNotEmpty and: [ dependencies first isSysmelModuleTarget ] ]
]
