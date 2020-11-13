Extension { #name : #WBTPlatform }

{ #category : #'*SysmelMoebiusMetamodel-Core' }
WBTPlatform >> setSysmelSettingsWith: aBlock [
	aBlock value: self sysmelSettings.

]

{ #category : #'*SysmelMoebiusMetamodel-Core' }
WBTPlatform >> sysmelSettings [
	^ self propertyAt: #sysmelSettings ifAbsentPut: [ MbndCompilationEnvironmentSettings new
		setupForWBTPlatform: self;
		yourself
	]
]
