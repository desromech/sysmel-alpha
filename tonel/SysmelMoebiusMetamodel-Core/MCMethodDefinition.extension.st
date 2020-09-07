Extension { #name : #MCMethodDefinition }

{ #category : #'*SysmelMoebiusMetamodel-Core' }
MCMethodDefinition >> buildMbndASTNodeWith: builder [
	| methodAst classNode sourceWithContext |
	sourceWithContext := MbndCollectionWithContext new
		collection: source;
		name: '[' , className  , (classIsMeta ifTrue: [ ' class' ] ifFalse: [ '' ]) , ' >> ' , selector printString , ']';
		yourself.
	
	methodAst := (builder module parseLanguage: #pharoMethod source: sourceWithContext) ast.
	classNode := builder identifier: className.
	classIsMeta ifTrue: [
		classNode := builder unexpandedSend: (builder literalSymbol: #meta) to: classNode withArguments: #().
	].
	^ builder programEntity: classNode extension: methodAst
]
