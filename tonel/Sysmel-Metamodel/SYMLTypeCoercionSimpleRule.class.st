Class {
	#name : #SYMLTypeCoercionSimpleRule,
	#superclass : #SYMLTypeCoercionRule,
	#instVars : [
		'resultType'
	],
	#category : #'Sysmel-Metamodel-Type'
}

{ #category : #'as yet unclassified' }
SYMLTypeCoercionSimpleRule >> doCoercionOf: left with: right [
	^ resultType
]

{ #category : #accessing }
SYMLTypeCoercionSimpleRule >> resultType [
	^ resultType
]

{ #category : #accessing }
SYMLTypeCoercionSimpleRule >> resultType: anObject [
	resultType := anObject
]
