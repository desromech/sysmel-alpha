Extension { #name : #Boolean }

{ #category : #'*Sysmel-Metamodel' }
Boolean >> asSysmelValueInEnvironment: anEnvironment [
	^ self sysmelValueWithType: anEnvironment compilationTarget booleanType inEnvironment: anEnvironment
]
