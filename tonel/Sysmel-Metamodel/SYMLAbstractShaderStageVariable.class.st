Class {
	#name : #SYMLAbstractShaderStageVariable,
	#superclass : #SYMLAbstractVariable,
	#instVars : [
		'location',
		'slotIndex',
		'spirVVariable'
	],
	#category : #'Sysmel-Metamodel-Shader'
}

{ #category : #'code generation' }
SYMLAbstractShaderStageVariable >> generateSSAReferenceWith: builder [
	self compilationTarget isSpirV ifFalse: [ self error: 'Shader stage variable access is not yet implemented here.' ].
	^ self generateSpirVSSAReferenceWith: builder
]

{ #category : #'code generation' }
SYMLAbstractShaderStageVariable >> generateSpirVSSAReferenceWith: builder [
	^ spirVVariable
]

{ #category : #'as yet unclassified' }
SYMLAbstractShaderStageVariable >> generateSpirVVariable [
	| variable |
	spirVVariable ifNotNil: [ ^ self ].
	variable := SLVMGlobalVariable module: self module ssaModule
		name: self mangledName
		valueType: self type ssaType
		storage: self spirvStorage.
	location ifNotNil: [ 
		variable propertyAt: #location put: location.
	].
	
	spirVVariable := variable
]

{ #category : #'code generation' }
SYMLAbstractShaderStageVariable >> getSpirVShaderInterfaceBlock [
	self subclassResponsibility
]

{ #category : #testing }
SYMLAbstractShaderStageVariable >> isInput [
	^ false
]

{ #category : #testing }
SYMLAbstractShaderStageVariable >> isOutput [
	^ false
]

{ #category : #accessing }
SYMLAbstractShaderStageVariable >> location [
	<compileTime>
	^ location
]

{ #category : #accessing }
SYMLAbstractShaderStageVariable >> location: anObject [
	<compileTime>
	location := anObject
]

{ #category : #'as yet unclassified' }
SYMLAbstractShaderStageVariable >> referenceType [
	^ self type ref
]

{ #category : #'as yet unclassified' }
SYMLAbstractShaderStageVariable >> semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition [
	name ifNil: [
		message selector numArgs = 0 ifTrue: [
			self name: message selector.
			definitionEnvironment addShaderStageVariable: self at: aPosition.
			^ message receiver
		].
	].

	^ super semanticAnalyzeMessageToYou: message inEnvironment: environment at: aPosition
]

{ #category : #'as yet unclassified' }
SYMLAbstractShaderStageVariable >> shaderInterfaceAnnotations [
	^ { #location . location }
]

{ #category : #accessing }
SYMLAbstractShaderStageVariable >> slotIndex [
	^ slotIndex
]

{ #category : #accessing }
SYMLAbstractShaderStageVariable >> slotIndex: anObject [
	slotIndex := anObject
]

{ #category : #'as yet unclassified' }
SYMLAbstractShaderStageVariable >> spirvStorage [
	self subclassResponsibility
]
