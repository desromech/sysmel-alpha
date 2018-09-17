Extension { #name : #Symbol }

{ #category : #'*Sysmel-Metamodel' }
Symbol >> asSysmelValueInEnvironment: anEnvironment [
	^ self sysmelValueWithType: anEnvironment compilationTarget literalSymbolType inEnvironment: anEnvironment
]

{ #category : #'*Sysmel-Metamodel' }
Symbol >> createNonInlineLiteralConstantForSysmelObjectModel: objectModel withCodeGenerator: aCodeGenerator [
	^ objectModel createObjectBytes: self asUTF8Bytes class: objectModel symbolClass
]
