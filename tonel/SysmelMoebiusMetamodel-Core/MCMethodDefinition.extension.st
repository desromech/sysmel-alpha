Extension { #name : #MCMethodDefinition }

{ #category : #'*SysmelMoebiusMetamodel-Core' }
MCMethodDefinition >> buildMbndASTNodeWith: builder [
	| methodAst classNode |
	methodAst := (builder module parseLanguage: #pharoMethod source: source) ast.
	classNode := builder identifier: className.
	classIsMeta ifTrue: [ 
		self halt.
	].
	^ builder programEntity: classNode extension: methodAst
]
