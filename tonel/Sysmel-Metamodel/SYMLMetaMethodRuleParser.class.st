Class {
	#name : #SYMLMetaMethodRuleParser,
	#superclass : #SYMLObject,
	#classVars : [
		'ParserForSelectors'
	],
	#category : #Sysmel-Metamodel-MetaBuilders
}

{ #category : #initialization }
SYMLMetaMethodRuleParser class >> initialize [
	ParserForSelectors := Dictionary new.
	self allSubclassesDo: [ :sc |
		ParserForSelectors at: sc selector put: sc
	]
]

{ #category : #'as yet unclassified' }
SYMLMetaMethodRuleParser class >> parserForSelector: aSelector [
	^ ParserForSelectors at: aSelector
]

{ #category : #accessing }
SYMLMetaMethodRuleParser class >> selector [
	^ self subclassResponsibility
]
