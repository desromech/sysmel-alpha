Class {
	#name : #MbndAstStaticClassPointerCastNode,
	#superclass : #MbndAstPointerCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstStaticClassPointerCastNode >> accept: aVisitor [
	^ aVisitor visitStaticClassPointerCastNode: self
]

{ #category : #testing }
MbndAstStaticClassPointerCastNode >> isStaticClassPointerCastNode [
	^ true
]
