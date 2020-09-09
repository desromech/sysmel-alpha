Extension { #name : #UndeclaredVariable }

{ #category : #'*SysmelMoebiusCodeGenerator-Slovim' }
UndeclaredVariable >> createNonInlineLiteralObjectForMbndObjectModel: objectModel [
	^ objectModel createVariable: self class: objectModel undeclaredVariableClass
]
