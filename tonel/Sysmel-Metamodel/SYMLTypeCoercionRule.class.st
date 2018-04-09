Class {
	#name : #SYMLTypeCoercionRule,
	#superclass : #SYMLObject,
	#instVars : [
		'leftType',
		'rightType'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #'as yet unclassified' }
SYMLTypeCoercionRule >> coerce: left with: right [
	((left isSysmelKindOf: leftType) and: [ right isSysmelKindOf: rightType ]) ifTrue: [ 
		^ self doCoercionOf: left with: right
	].

	^ nil
]

{ #category : #'as yet unclassified' }
SYMLTypeCoercionRule >> doCoercionOf: left with: right [
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
