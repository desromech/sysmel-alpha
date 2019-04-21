Class {
	#name : #MbndMetaBuilder,
	#superclass : #Object,
	#traits : 'TMbndObjectWithFlags',
	#classTraits : 'TMbndObjectWithFlags classTrait',
	#instVars : [
		'position',
		'metaBuilderAnalyzer',
		'metaBuilderScope',
		'currentAnalyzer'
	],
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndMetaBuilder class >> globalBindingName [
	^ nil
]

{ #category : #'as yet unclassified' }
MbndMetaBuilder class >> metaBuilderFactory [
	^ MbndMetaBuilderFactory new metaBuilderClass: self
]

{ #category : #'semantic analysis' }
MbndMetaBuilder >> analyzeUnexpandedMessageSendNode: node with: analyzer [
	| selector result |
	node selector isLiteralSymbolValueNode ifTrue: [ 
		selector := node selector value.
		
		(self class lookupSelector: selector) ifNotNil: [ :method |
			currentAnalyzer := analyzer.
			result := self perform: selector withArguments: node arguments.
			^ result == self
				ifTrue: [ node receiver ]
				ifFalse: [ result ]
		]
	].

	"Faild to find a specific method for handling this message. Concretize myself, and then analyze the result."
	^ self concretizeUnexpandedMessageSendNode: node thenAnalyzerWith: analyzer
]

{ #category : #'semantic analysis' }
MbndMetaBuilder >> concretizeNode: node withAnalyzer: analyzer [
	"By default, in the end replace myself with void."
	^ analyzer astBuilder literalVoid
]

{ #category : #'semantic analysis' }
MbndMetaBuilder >> concretizeUnexpandedMessageSendNode: node thenAnalyzerWith: analyzer [
	^ analyzer visitNode: (node copy
		receiver: (self concretizeNode: node receiver withAnalyzer: analyzer);
		yourself)
]

{ #category : #initialization }
MbndMetaBuilder >> initialize [
	super initialize.
	flags := #().
]

{ #category : #accessing }
MbndMetaBuilder >> metaBuilderAnalyzer [
	^ metaBuilderAnalyzer
]

{ #category : #accessing }
MbndMetaBuilder >> metaBuilderAnalyzer: anObject [
	metaBuilderAnalyzer := anObject.
	currentAnalyzer := metaBuilderAnalyzer.
]

{ #category : #accessing }
MbndMetaBuilder >> metaBuilderScope [
	^ metaBuilderScope
]

{ #category : #accessing }
MbndMetaBuilder >> metaBuilderScope: anObject [
	metaBuilderScope := anObject
]

{ #category : #accessing }
MbndMetaBuilder >> position [
	^ position
]

{ #category : #accessing }
MbndMetaBuilder >> position: anObject [
	position := anObject
]
