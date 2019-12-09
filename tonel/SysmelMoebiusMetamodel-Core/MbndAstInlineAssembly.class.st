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
