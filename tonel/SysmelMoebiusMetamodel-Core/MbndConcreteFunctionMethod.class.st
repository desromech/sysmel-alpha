Class {
	#name : #MbndConcreteFunctionMethod,
	#superclass : #MbndAbstractConcreteMethod,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #visiting }
MbndConcreteFunctionMethod >> accept: aVisitor [
	^ aVisitor visitConcreteFunctionMethod: self
]

{ #category : #testing }
MbndConcreteFunctionMethod >> isFunctionMethod [
	^ true
]
