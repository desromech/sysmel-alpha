Extension { #name : #Association }

{ #category : #'*SysmelMoebiusCodeGenerator-Slovim' }
Association >> createNonInlineLiteralObjectForMbndObjectModel: objectModel [
	^ objectModel createAssociation: self class: objectModel associationClass
]
