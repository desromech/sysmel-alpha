Class {
	#name : #MbndAstPatternMatchingBindingPatternNode,
	#superclass : #MbndAstPatternMatchingPatternNode,
	#instVars : [
		'name',
		'value',
		'binding'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstPatternMatchingBindingPatternNode >> accept: visitor [
	^ visitor visitPatternMatchingBindingPatternNode: self
]

{ #category : #accessing }
MbndAstPatternMatchingBindingPatternNode >> binding [
	^ binding
]

{ #category : #accessing }
MbndAstPatternMatchingBindingPatternNode >> binding: anObject [
	binding := anObject
]

{ #category : #'as yet unclassified' }
MbndAstPatternMatchingBindingPatternNode >> collectBindingsInto: out [
	out nextPut: self.
	value ifNotNil: [ value collectBindingsInto: out ]
]

{ #category : #testing }
MbndAstPatternMatchingBindingPatternNode >> isDefaultPattern [
	^ value isNil
]

{ #category : #testing }
MbndAstPatternMatchingBindingPatternNode >> isPatternMatchingBindingPatternNode [
	^ true
]

{ #category : #accessing }
MbndAstPatternMatchingBindingPatternNode >> name [
	^ name
]

{ #category : #accessing }
MbndAstPatternMatchingBindingPatternNode >> name: anObject [
	name := anObject
]

{ #category : #accessing }
MbndAstPatternMatchingBindingPatternNode >> value [
	^ value
]

{ #category : #accessing }
MbndAstPatternMatchingBindingPatternNode >> value: anObject [
	value := anObject
]
