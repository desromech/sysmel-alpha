Class {
	#name : #SYMLToken,
	#superclass : #PPToken,
	#instVars : [
		'previousComments'
	],
	#category : #'Sysmel-Parser-Parser'
}

{ #category : #accessing }
SYMLToken >> previousComments [
	^ previousComments
]

{ #category : #accessing }
SYMLToken >> previousComments: anObject [
	previousComments := anObject
]
