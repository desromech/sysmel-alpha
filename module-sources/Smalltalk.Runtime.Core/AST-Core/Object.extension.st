Extension { #name : #Object }

{ #category : #'*ast-core' }
Object >> asLiteralNode [
	^RBLiteralNode value: self
]
