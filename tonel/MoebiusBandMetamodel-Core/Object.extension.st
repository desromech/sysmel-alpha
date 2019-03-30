Extension { #name : #Object }

{ #category : #'*MoebiusBandMetamodel-Core' }
Object >> isMbndAstNode [
	^ false
]

{ #category : #'*MoebiusBandMetamodel-Core' }
Object >> mbndLiteralTypeWithTarget: compilationTarget [
	self subclassResponsibility
]

{ #category : #'*MoebiusBandMetamodel-Core' }
Object >> unwrapMbndValue [
	^ self
]
