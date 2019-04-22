Class {
	#name : #SysmelCommentToken,
	#superclass : #PP2Token,
	#instVars : [
		'trimLeft',
		'trimRight'
	],
	#category : #'SysmelLanguage-Sysmel-Parser'
}

{ #category : #accessing }
SysmelCommentToken >> initialize [
	super initialize.
	trimLeft := 0.
	trimRight := 0
]

{ #category : #accessing }
SysmelCommentToken >> trimLeft [
	^ trimLeft
]

{ #category : #accessing }
SysmelCommentToken >> trimLeft: anObject [
	trimLeft := anObject
]

{ #category : #accessing }
SysmelCommentToken >> trimLeft: leftAmount right: rightAmount [
	trimLeft := leftAmount.
	trimRight := rightAmount.
]

{ #category : #accessing }
SysmelCommentToken >> trimRight [
	^ trimRight
]

{ #category : #accessing }
SysmelCommentToken >> trimRight: anObject [
	trimRight := anObject
]
