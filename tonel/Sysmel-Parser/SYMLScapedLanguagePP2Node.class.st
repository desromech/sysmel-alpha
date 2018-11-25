Class {
	#name : #SYMLScapedLanguagePP2Node,
	#superclass : #PP2Node,
	#instVars : [
		'openCharacter',
		'closeCharacter'
	],
	#category : #'Sysmel-Parser-Parser'
}

{ #category : #visiting }
SYMLScapedLanguagePP2Node >> accept: aPP2ParserVisitor [
	^ aPP2ParserVisitor visitSysmelScapedLanguage: self
]

{ #category : #accessing }
SYMLScapedLanguagePP2Node >> closeCharacter [
	^ closeCharacter
]

{ #category : #accessing }
SYMLScapedLanguagePP2Node >> closeCharacter: anObject [
	closeCharacter := anObject
]

{ #category : #accessing }
SYMLScapedLanguagePP2Node >> firstCharSet [
	^ PP2CharSetPredicate on: [ :e | e = $$ ]
]

{ #category : #accessing }
SYMLScapedLanguagePP2Node >> openCharacter [
	^ openCharacter
]

{ #category : #accessing }
SYMLScapedLanguagePP2Node >> openCharacter: anObject [
	openCharacter := anObject
]

{ #category : #initialization }
SYMLScapedLanguagePP2Node >> resetStrategy [
	strategy := SYMLScapedLanguagePP2Strategy on: self

]
