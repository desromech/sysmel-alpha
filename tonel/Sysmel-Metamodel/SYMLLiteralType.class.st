Class {
	#name : #SYMLLiteralType,
	#superclass : #SYMLType,
	#instVars : [
		'name'
	],
	#category : #Sysmel-Metamodel-Types
}

{ #category : #'meta evaluation' }
SYMLLiteralType >> concreteTypeForNode: aNode [
	self subclassResponsibility
]

{ #category : #'meta evaluation' }
SYMLLiteralType >> generateSSAValue: value withBuilder: aBuilder [
	^ value
]

{ #category : #testing }
SYMLLiteralType >> isLiteralType [
	^ true
]

{ #category : #accessing }
SYMLLiteralType >> name [
	self subclassResponsibility
]

{ #category : #accessing }
SYMLLiteralType >> printOn: aStream [
	aStream nextPutAll: self name
]
