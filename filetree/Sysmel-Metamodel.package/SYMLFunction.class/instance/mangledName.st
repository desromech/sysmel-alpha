semantic analysis
mangledName
	self isExternC ifTrue: [ ^ name ].
	^ ByteString streamContents: [ :out |
		out
			nextPutAll: self parentMangledName;
			print: name size;
			nextPutAll: name.
	]