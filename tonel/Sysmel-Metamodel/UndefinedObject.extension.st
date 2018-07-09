Extension { #name : #UndefinedObject }

{ #category : #'*Sysmel-Metamodel' }
UndefinedObject >> asSysmelSourcePosition [
	^ self
]

{ #category : #'*Sysmel-Metamodel' }
UndefinedObject >> asSysmelValueInEnvironment: anEnvironment [
	^ self sysmelValueWithType: anEnvironment compilationTarget undefinedType inEnvironment: anEnvironment
]
