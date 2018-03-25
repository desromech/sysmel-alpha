Class {
	#name : #SYMLTypeCoercionTable,
	#superclass : #SYMLObject,
	#instVars : [
		'dictionary',
		'ruleClass'
	],
	#category : #Sysmel-Metamodel-Types
}

{ #category : #adding }
SYMLTypeCoercionTable >> addLeftType: leftClass rightType: rightClass action: aBlock [
	dictionary at: {leftClass . rightClass} put: aBlock
]

{ #category : #'as yet unclassified' }
SYMLTypeCoercionTable >> coerce: left with: right [
	dictionary at: { left class . right class } ifPresent: [ :rule |
		^ rule value: left value: left value: right
	].
	^ nil

]

{ #category : #accessing }
SYMLTypeCoercionTable >> dictionary [
	^ dictionary
]

{ #category : #initialization }
SYMLTypeCoercionTable >> initialize [
	super initialize.
	dictionary := Dictionary new.
	
]

{ #category : #accessing }
SYMLTypeCoercionTable >> ruleClass [
	^ ruleClass
]

{ #category : #accessing }
SYMLTypeCoercionTable >> ruleClass: anObject [
	ruleClass := anObject
]
