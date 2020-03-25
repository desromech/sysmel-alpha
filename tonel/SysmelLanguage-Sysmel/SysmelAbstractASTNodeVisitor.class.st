Class {
	#name : #SysmelAbstractASTNodeVisitor,
	#superclass : #SmaCCParseNodeVisitor,
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitAbstract: anAbstract [
	^ self visitSmaCCParseNode: anAbstract
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitBinaryExpression: aBinaryExpression [
	^ self visitExpression: aBinaryExpression
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitBlockClosureArgument: aBlockClosureArgument [
	^ self visitAbstract: aBlockClosureArgument
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitBlockClosureSignature: aBlockClosureSignature [
	^ self visitAbstract: aBlockClosureSignature
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitBlockExpression: aBlockExpression [
	^ self visitExpression: aBlockExpression
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitCallExpression: aCallExpression [
	^ self visitExpression: aCallExpression
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitCallExpressionArguments: aCallExpressionArguments [
	^ self visitAbstract: aCallExpressionArguments
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitCommaExpression: aCommaExpression [
	^ self visitExpression: aCommaExpression
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitDictionaryElement: aDictionaryElement [
	^ self visitExpression: aDictionaryElement
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitDictionaryExpression: aDictionaryExpression [
	^ self visitExpression: aDictionaryExpression
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitDictionaryKey: aDictionaryKey [
	^ self visitExpression: aDictionaryKey
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitDictionaryKeywordKey: aDictionaryKeywordKey [
	^ self visitExpression: aDictionaryKeywordKey
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitExpression: anExpression [
	^ self visitAbstract: anExpression
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitExpressionList: anExpressionList [
	^ self visitAbstract: anExpressionList
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitFile: aFile [
	^ self visitAbstract: aFile
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitIdentifierReference: anIdentifierReference [
	^ self visitExpression: anIdentifierReference
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitKeywordMessage: aKeywordMessage [
	^ self visitExpression: aKeywordMessage
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitLiteral: aLiteral [
	^ self visitExpression: aLiteral
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitLiteralArray: aLiteralArray [
	^ self visitExpression: aLiteralArray
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitLiteralCharacter: aLiteralCharacter [
	^ self visitLiteral: aLiteralCharacter
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitLiteralFloat: aLiteralFloat [
	^ self visitLiteral: aLiteralFloat
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitLiteralInteger: aLiteralInteger [
	^ self visitLiteral: aLiteralInteger
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitLiteralString: aLiteralString [
	^ self visitLiteral: aLiteralString
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitLiteralSymbol: aLiteralSymbol [
	^ self visitLiteral: aLiteralSymbol
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitMessageChain: aMessageChain [
	^ self visitExpression: aMessageChain
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitParenthesesExpression: aParenthesesExpression [
	^ self visitExpression: aParenthesesExpression
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitPragma: aPragma [
	^ self visitAbstract: aPragma
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitQuasiQuoteExpression: aQuasiQuoteExpression [
	^ self visitExpression: aQuasiQuoteExpression
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitQuasiUnquoteExpression: aQuasiUnquoteExpression [
	^ self visitExpression: aQuasiUnquoteExpression
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitQuoteExpression: aQuoteExpression [
	^ self visitExpression: aQuoteExpression
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitSpliceExpression: aSpliceExpression [
	^ self visitExpression: aSpliceExpression
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitSubscriptExpression: aSubscriptExpression [
	^ self visitExpression: aSubscriptExpression
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitUnaryMessage: anUnaryMessage [
	^ self visitExpression: anUnaryMessage
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitUnaryPrefixExpression: anUnaryPrefixExpression [
	^ self visitExpression: anUnaryPrefixExpression
]

{ #category : #generated }
SysmelAbstractASTNodeVisitor >> visitUnquoteUnaryMessage: anUnquoteUnaryMessage [
	^ self visitExpression: anUnquoteUnaryMessage
]
