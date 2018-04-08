Extension { #name : #Fraction }

{ #category : #'*Sysmel-Metamodel' }
Fraction >> asSysmelValueInEnvironment: anEnvironment [
	^ self sysmelValueWithType: anEnvironment compilationTarget literalFractionType inEnvironment: anEnvironment
]
