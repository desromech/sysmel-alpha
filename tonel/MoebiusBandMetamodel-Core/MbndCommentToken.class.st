Class {
	#name : #MbndCommentToken,
	#superclass : #PP2Token,
	#instVars : [
		'trimLeft',
		'trimRight'
	],
	#category : #'MoebiusBandMetamodel-Core-Parsing'
}

{ #category : #accessing }
MbndCommentToken >> initialize [
	super initialize.
	trimLeft := 0.
	trimRight := 0
]

{ #category : #accessing }
MbndCommentToken >> trimLeft [
	^ trimLeft
]

{ #category : #accessing }
MbndCommentToken >> trimLeft: anObject [
	trimLeft := anObject
]

{ #category : #accessing }
MbndCommentToken >> trimLeft: leftAmount right: rightAmount [
	trimLeft := leftAmount.
	trimRight := rightAmount.
]

{ #category : #accessing }
MbndCommentToken >> trimRight [
	^ trimRight
]

{ #category : #accessing }
MbndCommentToken >> trimRight: anObject [
	trimRight := anObject
]
