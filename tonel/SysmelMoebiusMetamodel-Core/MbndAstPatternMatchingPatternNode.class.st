Class {
	#name : #MbndAstPatternMatchingPatternNode,
	#superclass : #MbndAstNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #'as yet unclassified' }
MbndAstPatternMatchingPatternNode >> collectBindings [
	^ Array streamContents: [ :out |
		self collectBindingsInto: out
	]
]

{ #category : #'as yet unclassified' }
MbndAstPatternMatchingPatternNode >> collectBindingsInto: out [
	"Nothing required by default"
]

{ #category : #testing }
MbndAstPatternMatchingPatternNode >> isDefaultPattern [
	^ false
]

{ #category : #testing }
MbndAstPatternMatchingPatternNode >> isPatternMatchingPatternNode [
	^ true
]
