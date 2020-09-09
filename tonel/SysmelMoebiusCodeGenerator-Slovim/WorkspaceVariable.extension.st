Extension { #name : #WorkspaceVariable }

{ #category : #'*SysmelMoebiusCodeGenerator-Slovim' }
WorkspaceVariable >> createNonInlineLiteralObjectForMbndObjectModel: objectModel [
	^ objectModel createVariable: self class: objectModel workspaceVariableClass
]
