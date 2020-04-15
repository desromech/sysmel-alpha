Class {
	#name : #MbndTemplateInstance,
	#superclass : #MbndAbstractTemplateInstance,
	#traits : 'TMbndSymbolContainer',
	#classTraits : 'TMbndSymbolContainer classTrait',
	#instVars : [
		'module',
		'instanceArguments',
		'mainAliasCompileTimeConstant'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Template'
}

{ #category : #serialization }
MbndTemplateInstance class >> messagePackTypeName [
	^ #TemplateInstance
]

{ #category : #visiting }
MbndTemplateInstance >> accept: aVisitor [
	^ aVisitor visitTemplateInstance: self
]

{ #category : #accessing }
MbndTemplateInstance >> attemptToSetMainAliasTo: aCompileTimeConstant [
	mainAliasCompileTimeConstant ifNotNil: [ ^ self ].
	self assert: (parent isNotNil and: [ parent isTemplate ]).
	parent parent ifNil: [ ^ self ].
	
	aCompileTimeConstant parent == parent parent ifFalse: [ ^ self ].
	
	mainAliasCompileTimeConstant := aCompileTimeConstant.
]

{ #category : #serialization }
MbndTemplateInstance >> encodeFieldsForMessagePackWith: graphEncoder [
	^ (super encodeFieldsForMessagePackWith: graphEncoder), {
		#module . module encodeGraphForMessagePackWith: graphEncoder.
		#instanceArguments . instanceArguments encodeGraphForMessagePackWith: graphEncoder.
		#mainAliasCompileTimeConstant . mainAliasCompileTimeConstant encodeGraphForMessagePackWith: graphEncoder.
	}
]

{ #category : #initialization }
MbndTemplateInstance >> initialize [
	super initialize.
	children := OrderedCollection new.
]

{ #category : #accessing }
MbndTemplateInstance >> instanceArguments [
	^ instanceArguments
]

{ #category : #accessing }
MbndTemplateInstance >> instanceArguments: aListWithInstanceArguments [
	instanceArguments := aListWithInstanceArguments.
	instanceArguments do: [ :arg |
		arg parent: self.
		children add: arg. 
		
		arg name isMbndAnonymousSymbol ifFalse: [
			self setLocalSymbol: arg name value: arg
		].
	].
]

{ #category : #serialization }
MbndTemplateInstance >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	module := encodedFields at: #module.
	instanceArguments := encodedFields at: #instanceArguments.
	mainAliasCompileTimeConstant := encodedFields at: #mainAliasCompileTimeConstant ifAbsent: [nil].
]

{ #category : #accessing }
MbndTemplateInstance >> module [
	^ module
]

{ #category : #accessing }
MbndTemplateInstance >> module: anObject [
	module := anObject
]

{ #category : #accessing }
MbndTemplateInstance >> postMaterializeSetupParent: newParent withModule: newModule [
	newParent module ~~ newModule ifTrue: [ 
		newParent addInstance: self importedFromExternalModule: newModule 
	].

	super postMaterializeSetupParent: newParent withModule: newModule.
]

{ #category : #printing }
MbndTemplateInstance >> printOn: aStream [
	aStream nextPutAll: 'templateInstance '; nextPutAll: self qualifiedName
]

{ #category : #accessing }
MbndTemplateInstance >> qualifiedNameForParent [
	mainAliasCompileTimeConstant ifNotNil: [ ^ mainAliasCompileTimeConstant qualifiedNameForParent ].
	^ super qualifiedNameForParent
]

{ #category : #'member symbols' }
MbndTemplateInstance >> setLocalSymbol: aSymbol value: aValue [
	^ self localSymbolTable at: aSymbol put: aValue
]

{ #category : #accessing }
MbndTemplateInstance >> validName [
	<compileTime>
	^ ByteString streamContents: [:out |
		self assert: module isNotNil.
		module == parent module ifFalse: [ 
			out nextPut: $[.
			out nextPutAll: module name.
			out nextPut: $].
		].

		out nextPut: $(.
		instanceArguments doWithIndex: [ :each :index |
			index > 1 ifTrue: [ out nextPutAll: ', ' ].
			out nextPutAll: each evaluatedValue asString
		].
		out nextPut: $).
	]
]
