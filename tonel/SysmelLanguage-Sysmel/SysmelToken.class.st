Class {
	#name : #SysmelToken,
	#superclass : #PP2Token,
	#instVars : [
		'previousComments'
	],
	#category : #'SysmelLanguage-Sysmel-Parser'
}

{ #category : #'accessing-values' }
SysmelToken >> inputValue [
	^ self value
]

{ #category : #accessing }
SysmelToken >> previousComments [
	^ previousComments
]

{ #category : #accessing }
SysmelToken >> previousComments: anObject [
	previousComments := anObject
]
