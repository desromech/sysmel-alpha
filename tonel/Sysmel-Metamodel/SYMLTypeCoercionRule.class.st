Class {
	#name : #SYMLTypeCoercionRule,
	#superclass : #SYMLObject,
	#instVars : [
		'leftType',
		'rightType'
	],
	#category : #'Sysmel-Metamodel-Type'
}

{ #category : #'as yet unclassified' }
SYMLTypeCoercionRule >> coerce: left node: leftNode with: right node: rightNode [
	((left isSysmelKindOf: leftType) and: [ right isSysmelKindOf: rightType ]) ifTrue: [ 
		^ self doCoercionOf: left node: leftNode with: right node: rightNode
	].

	^ nil
]

{ #category : #'as yet unclassified' }
SYMLTypeCoercionRule >> coerce: left with: right [
	^ self coerce: left node: nil with: right node: nil
]

{ #category : #'as yet unclassified' }
SYMLTypeCoercionRule >> doCoercionOf: left node: leftNode with: right node: rightNode [
	self subclassResponsibility
]

{ #category : #accessing }
SYMLTypeCoercionRule >> leftType [
	^ leftType
]

{ #category : #accessing }
SYMLTypeCoercionRule >> leftType: anObject [
	leftType := anObject
]

{ #category : #converting }
SYMLTypeCoercionRule >> reversed [
	^ self copy
		leftType: rightType;
		rightType: leftType;
		yourself
]

{ #category : #accessing }
SYMLTypeCoercionRule >> rightType [
	^ rightType
]

{ #category : #accessing }
SYMLTypeCoercionRule >> rightType: anObject [
	rightType := anObject
]
