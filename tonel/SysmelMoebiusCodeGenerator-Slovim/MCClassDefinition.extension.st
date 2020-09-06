Extension { #name : #MCClassDefinition }

{ #category : #'*SysmelMoebiusCodeGenerator-Slovim' }
MCClassDefinition >> buildMbndASTNodeWith: builder [
	^ builder defineGCClassNamed: name superclass: (builder identifier: superclassName) body: (builder sequence: (
		self instanceVariables collect: [ :each |
			builder defineField: each name withValueType: nil withInitialValue: nil
		]
	))
]
