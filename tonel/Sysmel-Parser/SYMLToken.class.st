Class {
	#name : #SYMLToken,
	#superclass : #PP2Token,
	#instVars : [
		'previousComments'
	],
	#category : #'Sysmel-Parser-Parser'
}

{ #category : #'accessing-values' }
SYMLToken >> inputValue [
	^ self value
]

{ #category : #accessing }
SYMLToken >> previousComments [
	^ previousComments
]

{ #category : #accessing }
SYMLToken >> previousComments: anObject [
	previousComments := anObject
]
