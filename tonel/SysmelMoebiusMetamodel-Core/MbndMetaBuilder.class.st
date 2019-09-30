Class {
	#name : #MbndMetaBuilder,
	#superclass : #Object,
	#traits : 'TMbndObject + TMbndFlagContainer',
	#classTraits : 'TMbndObject classTrait + TMbndFlagContainer classTrait',
	#instVars : [
		'position',
		'metaBuilderAnalyzer',
		'metaBuilderScope',
		'currentAnalyzer',
		'ownerProgramEntity'
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

{ #category : #'meta builder finalization' }
MbndMetaBuilder >> abortMetaBuilding [
	^ MbndMetaBuilderAbortException new signal
]

{ #category : #'semantic analysis' }
MbndMetaBuilder >> analyzeUnexpandedMessageSendNode: node with: analyzer [
	| selector result |
	node selector isLiteralSymbolValueNode ifTrue: [ 
		selector := node selector value.
		
		(self class lookupSelector: selector) ifNotNil: [ :method |
			currentAnalyzer := analyzer.
			[ 
				result := self perform: selector withArguments: node arguments.
				^ result == self
					ifTrue: [ node receiver ]
					ifFalse: [ result ]
			] on: MbndMetaBuilderAbortException do: [ :e |
				"This reception means we are not accept more meta
				building invokations. Concretize the final node"
				^ self concretizeUnexpandedMessageSendNode: node thenAnalyzerWith: analyzer
			].
		]
	].

	"Faild to find a specific method for handling this message. Concretize myself, and then analyze the result."
	^ self concretizeUnexpandedMessageSendNode: node thenAnalyzerWith: analyzer
]

{ #category : #'semantic analysis' }
MbndMetaBuilder >> concretizeGenericNode: node withAnalyzer: analyzer [
	| specificExpansions |
	ownerProgramEntity ifNotNil: [ 
		(ownerProgramEntity isMbndType and: [ ownerProgramEntity isVariantUnionType ]) ifTrue: [
			specificExpansions := (ownerProgramEntity components asArray collect: [ :comp |
				self copy
					ownerProgramEntity: comp;
					concretizeNode: node withAnalyzer: analyzer
			]).
			^ MbndAstSequenceNode new
				position: node;
				elements: specificExpansions;
				type: specificExpansions last type;
				yourself
		].
	].

	^ self concretizeNode: node withAnalyzer: analyzer
]

{ #category : #'semantic analysis' }
MbndMetaBuilder >> concretizeNode: node withAnalyzer: analyzer [
	"By default, in the end replace myself with void."
	^ analyzer astBuilder literalVoid
]

{ #category : #'semantic analysis' }
MbndMetaBuilder >> concretizeUnexpandedMessageSendNode: node thenAnalyzerWith: analyzer [
	^ analyzer visitNode: (node copy
		receiver: (self concretizeGenericNode: node receiver withAnalyzer: analyzer);
		yourself)
]

{ #category : #'as yet unclassified' }
MbndMetaBuilder >> delegateToMetaBuilder: newMetaBuilder [
	^ self delegateToMetaBuilder: newMetaBuilder withOwnerProgramEntity: ownerProgramEntity
]

{ #category : #'as yet unclassified' }
MbndMetaBuilder >> delegateToMetaBuilder: newMetaBuilder withOwnerProgramEntity: newOwnerProgramEntity [
	^ MbndAstMetaBuilderInstanceNode new
		instance: (newMetaBuilder
			position: position;
			ownerProgramEntity: newOwnerProgramEntity;
			metaBuilderAnalyzer: metaBuilderAnalyzer;
			metaBuilderScope: metaBuilderScope;
			yourself);
		type: metaBuilderAnalyzer compilationTarget metaBuilderInstanceType;
		position: position;
		yourself
]

{ #category : #errors }
MbndMetaBuilder >> error: anErrorString at: aSourcePosition [
	<compileTime>
	^ MbndSemanticError new
		messageText: anErrorString;
		sourcePosition: aSourcePosition;
		signal
]

{ #category : #'meta builder finalization' }
MbndMetaBuilder >> finishMetaBuilding [
	^ MbndMetaBuilderAbortException new signal
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
MbndMetaBuilder >> ownerProgramEntity [
	^ ownerProgramEntity
]

{ #category : #accessing }
MbndMetaBuilder >> ownerProgramEntity: anObject [
	ownerProgramEntity := anObject
]

{ #category : #accessing }
MbndMetaBuilder >> position [
	^ position
]

{ #category : #accessing }
MbndMetaBuilder >> position: anObject [
	position := anObject
]

{ #category : #accessing }
MbndMetaBuilder >> validOwnerProgramEntity [
	^ ownerProgramEntity ifNil: [ ownerProgramEntity := metaBuilderScope lookupProgramEntityForNewDefinitions ]
]
