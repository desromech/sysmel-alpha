Class {
	#name : #MbndAstSpecificCastNode,
	#superclass : #MbndAstAbstractCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #testing }
MbndAstSpecificCastNode >> isSpecificCastNode [
	^ true
]

{ #category : #testing }
MbndAstSpecificCastNode >> isSuperReference [
	^ expression isSuperReference
]

{ #category : #accessing }
MbndAstSpecificCastNode >> pragmaAt: pragmaName ifAbsent: absentBlock ifPresent: presentBlock [
	^ expression pragmaAt: pragmaName ifAbsent: absentBlock ifPresent: presentBlock
]
