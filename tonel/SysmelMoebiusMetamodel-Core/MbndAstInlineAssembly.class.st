Class {
	#name : #MbndAstInlineAssembly,
	#superclass : #MbndAstNode,
	#traits : 'TMbndFlagContainer',
	#classTraits : 'TMbndFlagContainer classTrait',
	#instVars : [
		'assembly',
		'architecture',
		'dialect',
		'inputList',
		'outputList',
		'clobberList'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstInlineAssembly >> accept: visitor [
	^ visitor visitInlineAssembly: self
]

{ #category : #accessing }
MbndAstInlineAssembly >> architecture [
	^ architecture
]

{ #category : #accessing }
MbndAstInlineAssembly >> architecture: anObject [
	architecture := anObject
]

{ #category : #accessing }
MbndAstInlineAssembly >> assembly [
	^ assembly
]

{ #category : #accessing }
MbndAstInlineAssembly >> assembly: anObject [
	assembly := anObject
]

{ #category : #accessing }
MbndAstInlineAssembly >> clobberList [
	^ clobberList
]

{ #category : #accessing }
MbndAstInlineAssembly >> clobberList: anObject [
	clobberList := anObject
]

{ #category : #accessing }
MbndAstInlineAssembly >> dialect [
	^ dialect
]

{ #category : #accessing }
MbndAstInlineAssembly >> dialect: anObject [
	dialect := anObject
]

{ #category : #serialization }
MbndAstInlineAssembly >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#assembly . assembly encodeGraphForMessagePackWith: graphEncoder.
		#architecture . architecture encodeGraphForMessagePackWith: graphEncoder.
		#dialect . dialect encodeGraphForMessagePackWith: graphEncoder.
		#inputList . inputList encodeGraphForMessagePackWith: graphEncoder.
		#outputList . outputList encodeGraphForMessagePackWith: graphEncoder.
		#clobberList . clobberList encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #accessing }
MbndAstInlineAssembly >> inputList [
	^ inputList
]

{ #category : #accessing }
MbndAstInlineAssembly >> inputList: anObject [
	inputList := anObject
]

{ #category : #testing }
MbndAstInlineAssembly >> isInlineAssembly [
	^ true
]

{ #category : #testing }
MbndAstInlineAssembly >> isModuleLevelInlineAssembly [
	^ self hasFlag: #moduleLevel
]

{ #category : #'type composition' }
MbndAstInlineAssembly >> isVolatile [
	^ self hasFlag: #volatile
]

{ #category : #testing }
MbndAstInlineAssembly >> markAsModuleLevel [
	^ self addFlag: #moduleLevel
]

{ #category : #serialization }
MbndAstInlineAssembly >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	assembly := encodedFields at: #assembly.
	architecture := encodedFields at: #architecture.
	dialect := encodedFields at: #dialect.
	inputList := encodedFields at: #inputList.
	outputList := encodedFields at: #outputList.
	clobberList := encodedFields at: #clobberList.
]

{ #category : #accessing }
MbndAstInlineAssembly >> outputList [
	^ outputList
]

{ #category : #accessing }
MbndAstInlineAssembly >> outputList: anObject [
	outputList := anObject
]

{ #category : #'type composition' }
MbndAstInlineAssembly >> volatile [
	self addFlag: #volatile
]
