Extension { #name : #Float }

{ #category : #'*Sysmel-Metamodel' }
Float >> asSysmelValueInEnvironment: anEnvironment [
	^ self sysmelValueWithType: anEnvironment compilationTarget literalFloatType inEnvironment: anEnvironment
]
