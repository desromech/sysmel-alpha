Class {
	#name : #MbndAstVariantUnboxingAssignmentReferenceNode,
	#superclass : #MbndAstVariantUnboxingNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstVariantUnboxingAssignmentReferenceNode >> accept: visitor [
	^ visitor visitVariantUnboxingAssignmentReferenceNode: self
]

{ #category : #visiting }
MbndAstVariantUnboxingAssignmentReferenceNode >> isVariantUnboxingAssignmentReferenceNode [
	^ true
]

{ #category : #visiting }
MbndAstVariantUnboxingAssignmentReferenceNode >> isVariantUnboxingNode [
	^ false
]
