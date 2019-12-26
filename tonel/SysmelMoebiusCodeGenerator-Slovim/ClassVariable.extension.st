Extension { #name : #ClassVariable }

{ #category : #'*SysmelMoebiusCodeGenerator-Slovim' }
ClassVariable >> createNonInlineLiteralObjectForMbndObjectModel: objectModel [
	^ objectModel createAssociation: self class: objectModel classVariableClass
]
