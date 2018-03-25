Class {
	#name : #SYMLPointerType,
	#superclass : #SYMLType,
	#instVars : [
		'pointed'
	],
	#category : #Sysmel-Metamodel-Types
}

{ #category : #coercion }
SYMLPointerType >> arithmeticCoerceWith: other [
	(ArithmeticCoercionTable coerce: self with: other) ifNotNil: [ :result | ^ result ].
	^ super arithmeticCoerceWith: other
]

{ #category : #'as yet unclassified' }
SYMLPointerType >> buildSSAType [
	^ target lowLevelTarget pointerTo: pointed ssaType
]

{ #category : #'meta evaluation' }
SYMLPointerType >> cleanType [
	^ pointed cleanType pointer
]

{ #category : #'meta evaluation' }
SYMLPointerType >> concreteTypeForNode: aNode [
	^ (pointed concreteTypeForNode: aNode) pointer
]

{ #category : #testing }
SYMLPointerType >> isPointerType [
	^ true
]

{ #category : #accessing }
SYMLPointerType >> pointed [
	^ pointed
]

{ #category : #accessing }
SYMLPointerType >> pointed: anObject [
	pointed := anObject
]

{ #category : #printing }
SYMLPointerType >> printOn: aStream [
	aStream print: pointed; nextPutAll: ' pointer'
]
