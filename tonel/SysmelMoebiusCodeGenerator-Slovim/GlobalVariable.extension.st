Extension { #name : #GlobalVariable }

{ #category : #'*SysmelMoebiusCodeGenerator-Slovim' }
GlobalVariable >> createNonInlineLiteralObjectForMbndObjectModel: objectModel [
	^ objectModel createAssociation: self class: objectModel globalVariableClass
]
