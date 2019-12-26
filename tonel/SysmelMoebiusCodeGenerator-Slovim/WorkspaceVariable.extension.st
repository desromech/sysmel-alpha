Extension { #name : #WorkspaceVariable }

{ #category : #'*SysmelMoebiusCodeGenerator-Slovim' }
WorkspaceVariable >> createNonInlineLiteralObjectForMbndObjectModel: objectModel [
	^ objectModel createAssociation: self class: objectModel workspaceVariableClass
]
