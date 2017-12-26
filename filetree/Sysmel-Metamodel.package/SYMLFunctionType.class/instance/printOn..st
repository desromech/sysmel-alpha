printing
printOn: aStream
	aStream nextPut: $(.
	arguments doWithIndex: [ :arg :index |
		index > 1 ifTrue: [ aStream nextPutAll: ', ' ].
		aStream print: arg. 
	].

	aStream nextPutAll: ') -> '.
	aStream print: returnType.