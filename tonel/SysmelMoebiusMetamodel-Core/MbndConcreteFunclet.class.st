Class {
	#name : #MbndConcreteFunclet,
	#superclass : #MbndAbstractConcreteMethod,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #accessing }
MbndConcreteFunclet >> argumentNodes [
	^ #()
]

{ #category : #accessing }
MbndConcreteFunclet >> contentNode [
	^ definitionNode
]

{ #category : #accessing }
MbndConcreteFunclet >> contentNode: aNode [
	self
		declarationPosition: aNode;
		definitionNode: aNode
]

{ #category : #accessing }
MbndConcreteFunclet >> definitionBody [
	^ definitionNode
]

{ #category : #testing }
MbndConcreteFunclet >> isFunclet [
	^ true
]

{ #category : #initialization }
MbndConcreteFunclet >> setArguments: newArguments returnType: returnType [
	| functionType |
	functionType := (self compilationTarget functionTypeWithArguments: (newArguments collect: #type) returnType: returnType).
	self
		receiverType: self compilationTarget voidType;
		type: functionType;
		boundType: functionType.
]
