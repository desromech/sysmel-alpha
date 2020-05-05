Class {
	#name : #MbndAstAbstractFunctionPrototypeNode,
	#superclass : #MbndAstNode,
	#traits : 'TMbndFlagContainer',
	#classTraits : 'TMbndFlagContainer classTrait',
	#instVars : [
		'arguments',
		'returnType',
		'functionType',
		'concreteMethod',
		'ownerProgramEntity',
		'specialSemantics'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #accessing }
MbndAstAbstractFunctionPrototypeNode >> arguments [
	^ arguments
]

{ #category : #accessing }
MbndAstAbstractFunctionPrototypeNode >> arguments: anObject [
	arguments := anObject
]

{ #category : #'as yet unclassified' }
MbndAstAbstractFunctionPrototypeNode >> computeReceiverTypeForEntity: entity [
	(self hasFlag: #static) ifTrue: [ 
		^ entity compilationTarget voidType
	].
 
	(self hasFlag: #const) ifTrue: [
		^ entity implicitMethodConstReceiverType
	].
	^ entity implicitMethodReceiverType
]

{ #category : #accessing }
MbndAstAbstractFunctionPrototypeNode >> concreteMethod [
	^ concreteMethod
]

{ #category : #accessing }
MbndAstAbstractFunctionPrototypeNode >> concreteMethod: anObject [
	concreteMethod := anObject
]

{ #category : #serialization }
MbndAstAbstractFunctionPrototypeNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#flags . flags.
		#arguments . arguments encodeGraphForMessagePackWith: graphEncoder.
		#returnType . returnType encodeGraphForMessagePackWith: graphEncoder.
		#functionType . functionType encodeGraphForMessagePackWith: graphEncoder.
		#concreteMethod . concreteMethod encodeGraphForMessagePackWith: graphEncoder.
		#ownerProgramEntity . ownerProgramEntity encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #accessing }
MbndAstAbstractFunctionPrototypeNode >> functionType [
	^ functionType
]

{ #category : #accessing }
MbndAstAbstractFunctionPrototypeNode >> functionType: anObject [
	functionType := anObject
]

{ #category : #initialization }
MbndAstAbstractFunctionPrototypeNode >> initialize [
	super initialize.
	arguments := #().
	flags := #().
]

{ #category : #testing }
MbndAstAbstractFunctionPrototypeNode >> isCVariadic [
	^ false
]

{ #category : #serialization }
MbndAstAbstractFunctionPrototypeNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	flags := encodedFields at: #flags.
	arguments := encodedFields at: #arguments.
	returnType := encodedFields at: #returnType.
	functionType := encodedFields at: #functionType.
	concreteMethod := encodedFields at: #concreteMethod.
	ownerProgramEntity := encodedFields at: #ownerProgramEntity.
]

{ #category : #accessing }
MbndAstAbstractFunctionPrototypeNode >> ownerProgramEntity [
	^ ownerProgramEntity
]

{ #category : #accessing }
MbndAstAbstractFunctionPrototypeNode >> ownerProgramEntity: anObject [
	ownerProgramEntity := anObject
]

{ #category : #accessing }
MbndAstAbstractFunctionPrototypeNode >> returnType [
	^ returnType
]

{ #category : #accessing }
MbndAstAbstractFunctionPrototypeNode >> returnType: aTypeExpression [
	returnType := aTypeExpression
]

{ #category : #accessing }
MbndAstAbstractFunctionPrototypeNode >> specialSemantics [
	^ specialSemantics
]

{ #category : #accessing }
MbndAstAbstractFunctionPrototypeNode >> specialSemantics: anObject [
	specialSemantics := anObject
]
