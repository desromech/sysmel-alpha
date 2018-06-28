Class {
	#name : #SYMLVectorInstance,
	#superclass : #SYMLObjectInstance,
	#instVars : [
		'slots'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #converting }
SYMLVectorInstance >> generateSSAReferenceWith: builder [
	| slotType |
	slotType := type cachedNullary: #elementType.
	^ builder makeVector: type ssaType arguments: (slots collect: [:slot | slotType generateSSAValue: slot withBuilder: builder])
]

{ #category : #accessing }
SYMLVectorInstance >> slots [
	^ slots
]

{ #category : #accessing }
SYMLVectorInstance >> slots: anObject [
	slots := anObject
]
