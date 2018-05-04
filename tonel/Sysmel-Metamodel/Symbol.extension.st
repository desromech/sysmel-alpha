Extension { #name : #Symbol }

{ #category : #'*Sysmel-Metamodel' }
Symbol >> asSysmelValueInEnvironment: anEnvironment [
	^ self sysmelValueWithType: anEnvironment compilationTarget literalSymbolType inEnvironment: anEnvironment
]
