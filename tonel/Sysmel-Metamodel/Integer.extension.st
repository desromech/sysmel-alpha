Extension { #name : #Integer }

{ #category : #'*Sysmel-Metamodel' }
Integer >> asSysmelValueInEnvironment: anEnvironment [
	^ self sysmelValueWithType: anEnvironment compilationTarget literalIntegerType inEnvironment: anEnvironment
]

{ #category : #'*Sysmel-Metamodel' }
Integer >> sysmelMangledValue [
	^ 'i' , self printString
]
