Class {
	#name : #SYMLCommentToken,
	#superclass : #PP2Token,
	#instVars : [
		'trimLeft',
		'trimRight'
	],
	#category : #'Sysmel-Parser-Parser'
}

{ #category : #accessing }
SYMLCommentToken >> initialize [
	super initialize.
	trimLeft := 0.
	trimRight := 0
]

{ #category : #accessing }
SYMLCommentToken >> trimLeft [
	^ trimLeft
]

{ #category : #accessing }
SYMLCommentToken >> trimLeft: anObject [
	trimLeft := anObject
]

{ #category : #accessing }
SYMLCommentToken >> trimLeft: leftAmount right: rightAmount [
	trimLeft := leftAmount.
	trimRight := rightAmount.
]

{ #category : #accessing }
SYMLCommentToken >> trimRight [
	^ trimRight
]

{ #category : #accessing }
SYMLCommentToken >> trimRight: anObject [
	trimRight := anObject
]
