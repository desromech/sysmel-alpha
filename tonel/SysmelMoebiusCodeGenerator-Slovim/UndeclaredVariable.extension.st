Extension { #name : #UndeclaredVariable }

{ #category : #'*SysmelMoebiusCodeGenerator-Slovim' }
UndeclaredVariable >> createNonInlineLiteralObjectForMbndObjectModel: objectModel [
	^ objectModel createAssociation: self class: objectModel undeclaredVariableClass
]
