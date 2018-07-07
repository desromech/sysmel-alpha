Class {
	#name : #SYMLMetaclassInstance,
	#superclass : #SYMLAbstractMetaType,
	#instVars : [
		'superclass',
		'type'
	],
	#category : #'Sysmel-Metamodel-Type'
}

{ #category : #accessing }
SYMLMetaclassInstance >> superclass [
	<compileTime>
	^ superclass
]

{ #category : #accessing }
SYMLMetaclassInstance >> superclass: anObject [
	<compileTime>
	superclass := anObject
]

{ #category : #accessing }
SYMLMetaclassInstance >> supertype [
	^ superclass
]

{ #category : #accessing }
SYMLMetaclassInstance >> type [
	^ type
]

{ #category : #accessing }
SYMLMetaclassInstance >> type: anObject [
	type := anObject
]
