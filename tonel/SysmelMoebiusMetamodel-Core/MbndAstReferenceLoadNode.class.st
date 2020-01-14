Class {
	#name : #MbndAstReferenceLoadNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'reference',
		'createsImplicitTemporary',
		'storageCreationNode'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstReferenceLoadNode >> accept: aVisitor [
	^ aVisitor visitReferenceLoadNode: self
]

{ #category : #accessing }
MbndAstReferenceLoadNode >> createsImplicitTemporary [
	^ createsImplicitTemporary
]

{ #category : #accessing }
MbndAstReferenceLoadNode >> createsImplicitTemporary: anObject [
	createsImplicitTemporary := anObject
]

{ #category : #initialization }
MbndAstReferenceLoadNode >> initialize [
	super initialize.
	createsImplicitTemporary := false.
]

{ #category : #testing }
MbndAstReferenceLoadNode >> isReferenceLoadNode [
	^ true
]

{ #category : #'as yet unclassified' }
MbndAstReferenceLoadNode >> markStorageCreationNodeForCopyEllision: aStorageCreationNode [
	self type isTypePassedByReference ifFalse: [
		self assert: createsImplicitTemporary not.
		^ self
	].

	createsImplicitTemporary ifFalse: [
		^ reference markStorageCreationNodeForCopyEllision: aStorageCreationNode
	].

	storageCreationNode := aStorageCreationNode
]

{ #category : #accessing }
MbndAstReferenceLoadNode >> pragmaAt: pragmaName ifAbsent: absentBlock ifPresent: presentBlock [
	^ reference pragmaAt: pragmaName ifAbsent: absentBlock ifPresent: presentBlock
]

{ #category : #accessing }
MbndAstReferenceLoadNode >> reference [
	^ reference
]

{ #category : #accessing }
MbndAstReferenceLoadNode >> reference: anObject [
	reference := anObject
]

{ #category : #accessing }
MbndAstReferenceLoadNode >> storageCreationNode [
	^ storageCreationNode
]

{ #category : #accessing }
MbndAstReferenceLoadNode >> storageCreationNode: anObject [
	storageCreationNode := anObject
]
