Extension { #name : #String }

{ #category : #'*Sysmel-Metamodel' }
String >> sysmelEscapeForMangling [
	(self beginsWith: '__anon') ifTrue: [
		^ '_a' , (self allButFirst: '__anon' size) sysmelEscapeForMangling
	].

	^ ByteString streamContents: [ :out |
		self do: [ :c |
			c = $_ ifTrue: [ out nextPutAll: '__' ] ifFalse: [
				(c isLetter or: [ c isDigit ])
					ifTrue: [ out nextPut: c ]
					ifFalse: [ out nextPut: $_; nextPutAll: (c asInteger printStringBase: 16 length: 2 padded: true)]
			]
		]
	]
]
