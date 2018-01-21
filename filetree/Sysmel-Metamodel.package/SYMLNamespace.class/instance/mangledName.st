semantic analysis
mangledName
	(parent isNil and: [ name = #__global ]) ifTrue: [ ^ self parentMangledName ].
	^ self parentMangledName , name size asString , name
