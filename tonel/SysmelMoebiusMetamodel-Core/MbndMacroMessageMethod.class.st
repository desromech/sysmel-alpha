Class {
	#name : #MbndMacroMessageMethod,
	#superclass : #MbndAbstractMacro,
	#instVars : [
		'parent',
		'concreteMethod'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Macro'
}

{ #category : #serialization }
MbndMacroMessageMethod class >> messagePackTypeName [
	^ #MacroMessageMethod
]

{ #category : #visiting }
MbndMacroMessageMethod >> accept: aVisitor [
	^ aVisitor visitMacroMessageMethod: self
]

{ #category : #accessing }
MbndMacroMessageMethod >> children [
	^ {concreteMethod}
]

{ #category : #accessing }
MbndMacroMessageMethod >> concreteMethod [
	^ concreteMethod
]

{ #category : #accessing }
MbndMacroMessageMethod >> concreteMethod: aConcreteMethod [
	self assert: aConcreteMethod parent isNil.
	self assert: concreteMethod isNil.
	
	concreteMethod := aConcreteMethod.
	concreteMethod parent: self.
	
]

{ #category : #serialization }
MbndMacroMessageMethod >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#concreteMethod . concreteMethod encodeGraphForMessagePackWith: graphEncoder
	}
]

{ #category : #'semantic analysis' }
MbndMacroMessageMethod >> enqueueDelayedSemanticAnalysis [
	super enqueueDelayedSemanticAnalysis.
	concreteMethod enqueueDelayedSemanticAnalysis
]

{ #category : #'as yet unclassified' }
MbndMacroMessageMethod >> expandMessageNode: node with: analyzer [
	| evaluator builder compilerObjectType nodeType result receiverType |
	evaluator := MbndAstEvaluator new module: analyzer module.
	builder := MbndAstBuilder forModule: analyzer module.
	builder gensymContext: { node . thisContext }.
	compilerObjectType := self compilationTarget compilerObjectType.
	nodeType := self compilationTarget astNodeType.
	receiverType := node receiver ifNil: [ self compilationTarget voidType ] ifNotNil: [ node receiver type ].
	concreteMethod receiverType isVoidType ifTrue: [ 
		receiverType := self compilationTarget voidType.
	].

	result := concreteMethod evaluateWithReceiver:
			(receiverType isVoidType ifTrue: [nil] ifFalse: [MbndValue value: node receiver type: nodeType])
		arguments: ({
			MbndValue value: receiverType type: receiverType type.
			MbndValue value: builder type: compilerObjectType.
			MbndValue value: analyzer type: compilerObjectType.
		} , (node arguments collect: [ :arg | MbndValue value: arg type: nodeType]))
		withEvaluator: evaluator at: node.
	self assert: result type isASTNodeType.
	^ analyzer visitNode: result value
]

{ #category : #testing }
MbndMacroMessageMethod >> isMacroMessageMethod [
	^ true
]

{ #category : #serialization }
MbndMacroMessageMethod >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	concreteMethod := encodedFields at: #concreteMethod.
]

{ #category : #accessing }
MbndMacroMessageMethod >> module [
	^ concreteMethod module
]

{ #category : #accessing }
MbndMacroMessageMethod >> name [
	^ self selector
]

{ #category : #accessing }
MbndMacroMessageMethod >> parent [
	^ parent
]

{ #category : #accessing }
MbndMacroMessageMethod >> parent: anObject [
	parent := anObject
]

{ #category : #enumerating }
MbndMacroMessageMethod >> postMaterializeSetupParent: newParent withModule: newModule [
	self parent: newParent.
	self childrenDo: [ :child |
		child postMaterializeSetupParent: self withModule: newModule
	].
]

{ #category : #printing }
MbndMacroMessageMethod >> printOn: aStream [
	aStream nextPutAll: 'macroMessageMethod '; nextPutAll: self selector asString
]

{ #category : #accessing }
MbndMacroMessageMethod >> selector [
	^ concreteMethod name
]
