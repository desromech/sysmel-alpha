Class {
	#name : #MbndTemplateInstance,
	#superclass : #MbndAbstractTemplateInstance,
	#traits : 'TMbndSymbolContainer',
	#classTraits : 'TMbndSymbolContainer classTrait',
	#instVars : [
		'instanceArguments'
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

{ #category : #serialization }
MbndTemplateInstance >> encodeFieldsForMessagePackWith: graphEncoder [
	^ (super encodeFieldsForMessagePackWith: graphEncoder), {
		#instanceArguments . instanceArguments encodeGraphForMessagePackWith: graphEncoder.
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
	instanceArguments := encodedFields at: #instanceArguments.
]

{ #category : #'member symbols' }
MbndTemplateInstance >> setLocalSymbol: aSymbol value: aValue [
	^ self localSymbolTable at: aSymbol put: aValue
]

{ #category : #accessing }
MbndTemplateInstance >> validName [
	^ ByteString streamContents: [:out |
		out nextPut: $(.
		instanceArguments doWithIndex: [ :each :index |
			index > 1 ifTrue: [ out nextPutAll: ', ' ].
			out nextPutAll: each evaluatedValue asString
		].
		out nextPut: $).
	]
]
