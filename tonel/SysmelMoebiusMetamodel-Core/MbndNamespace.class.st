Class {
	#name : #MbndNamespace,
	#superclass : #MbndAbstractNamespace,
	#traits : 'TMbndNamespaceLikeSymbolContainer',
	#classTraits : 'TMbndNamespaceLikeSymbolContainer classTrait',
	#instVars : [
		'parent',
		'children',
		'name',
		'module'
	],
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #serialization }
MbndNamespace class >> messagePackTypeName [
	^ #Namespace
]

{ #category : #accessing }
MbndNamespace >> addChild: aChild [
	self assert: aChild parent isNil.
	aChild parent: self.
	self children add: aChild.
]

{ #category : #'semantic analysis' }
MbndNamespace >> analyzeReferenceNode: referenceNode with: analyzer [
	^ self asLiteralValueNode
]

{ #category : #'semantic analysis' }
MbndNamespace >> asLiteralValueNode [
	^ MbndAstLiteralValueNode new
		value: self;
		type: self type;
		yourself
]

{ #category : #accessing }
MbndNamespace >> children [
	^ children ifNil: [ children := OrderedCollection new ]
]

{ #category : #serialization }
MbndNamespace >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#name . name.
		#macroMethodDict . graphEncoder encodeSymbolTable: macroMethodDict.
		#methodDict . graphEncoder encodeSymbolTable: methodDict.
		#overloadedMethodDict . graphEncoder encodeSymbolTable: overloadedMethodDict.
		#localSymbolTable . graphEncoder encodeSymbolTable: localSymbolTable.
		#children.  graphEncoder encodeProgramEntityList: children
	}
]

{ #category : #serialization }
MbndNamespace >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	name := encodedFields at: #name ifAbsent: [nil].
	macroMethodDict := Dictionary newFromPairs: (encodedFields at: #macroMethodDict).
	methodDict := Dictionary newFromPairs: (encodedFields at: #methodDict).
	overloadedMethodDict := Dictionary newFromPairs: (encodedFields at: #overloadedMethodDict).
	localSymbolTable := Dictionary newFromPairs: (encodedFields at: #localSymbolTable).
	children := (encodedFields at: #children ifAbsent: [#()]) asOrderedCollection.
]

{ #category : #accessing }
MbndNamespace >> module [
	^ module
]

{ #category : #accessing }
MbndNamespace >> module: anObject [
	module := anObject
]

{ #category : #accessing }
MbndNamespace >> name [
	^ name
]

{ #category : #accessing }
MbndNamespace >> name: anObject [
	name := anObject
]

{ #category : #accessing }
MbndNamespace >> parent [
	^ parent
]

{ #category : #accessing }
MbndNamespace >> parent: anObject [
	parent := anObject
]

{ #category : #printing }
MbndNamespace >> printOn: aStream [
	aStream nextPutAll: 'namespace '; nextPutAll: self qualifiedName asPrettySymbolName
]

{ #category : #printing }
MbndNamespace >> qualifiedNameForParent [
	parent ifNil: [ ^ '' ].
	^ super qualifiedNameForParent
]

{ #category : #'semantic analysis' }
MbndNamespace >> type [
	^ self compilationTarget namespaceType
]
