Extension { #name : #AdditionalBinding }

{ #category : #'*SysmelMoebiusCodeGenerator-Slovim' }
AdditionalBinding >> createNonInlineLiteralObjectForMbndObjectModel: objectModel [
	^ objectModel createAssociation: self class: objectModel additionalBindingClass
]
