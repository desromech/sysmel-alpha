Trait {
	#name : #TSYMLInterpretedCompilationObject,
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #parsing }
TSYMLInterpretedCompilationObject >> parse: actionsDictionary [
	^ self parse: actionsDictionary at: SYMLSourcePosition empty
]

{ #category : #parsing }
TSYMLInterpretedCompilationObject >> parse: actionsDictionary at: aPosition [
	| actions key value selector |
	actions := actionsDictionary unwrapSysmelValue.
	actions isDictionary ifFalse: [ 
		self error: 'Expected a literal dictionary.' at: aPosition
	].

	actions keysAndValuesDo: [ :keyValue : valueValue |
		key := keyValue unwrapSysmelValue.
		value := valueValue unwrapSysmelValue.
		
		key isSysmelLocalSymbol ifTrue: [ 
			key := key value.
		].
		
		key isSymbol ifFalse: [ 
			self error: 'Expected a symbol instead of key {1}.' format: { keyValue printString } at: aPosition
		].
	
		selector := (key , ':') asSymbol.
		value isLiteral ifFalse: [ value := value asSysmelCompileTimeFunction ].
		self perform: selector with: value
	]
]
