Class {
	#name : #MbndAbstractTemplateInstance,
	#superclass : #Object,
	#traits : 'TMbndProgramEntity',
	#classTraits : 'TMbndProgramEntity classTrait',
	#instVars : [
		'parent',
		'children',
		'mainChild'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Template'
}

{ #category : #serialization }
MbndAbstractTemplateInstance class >> messagePackTypeName [
	^ nil
]

{ #category : #adding }
MbndAbstractTemplateInstance >> addChild: aChild [
	self assert: aChild parent isNil.
	
	aChild parent: self.
	self children add: aChild.
	mainChild ifNil: [
		mainChild := aChild.
	].

]

{ #category : #converting }
MbndAbstractTemplateInstance >> asLiteralValueNode [
	^ mainChild asLiteralValueNode
]

{ #category : #accessing }
MbndAbstractTemplateInstance >> children [
	^ children
]

{ #category : #accessing }
MbndAbstractTemplateInstance >> children: anObject [
	children := anObject
]

{ #category : #accessing }
MbndAbstractTemplateInstance >> compilationEnvironment [
	^ parent compilationEnvironment
]

{ #category : #serialization }
MbndAbstractTemplateInstance >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#mainChild . mainChild encodeGraphForMessagePackWith: graphEncoder.
		#children . graphEncoder encodeProgramEntityList: children.
	}
]

{ #category : #testing }
MbndAbstractTemplateInstance >> isTemplateInstance [
	^ true
]

{ #category : #accessing }
MbndAbstractTemplateInstance >> mainChild [
	^ mainChild
]

{ #category : #serialization }
MbndAbstractTemplateInstance >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	mainChild := encodedFields at: #mainChild.
	children := encodedFields at: #children.
]

{ #category : #serialization }
MbndAbstractTemplateInstance >> messagePackTypeName [
	^ self class messagePackTypeName
]

{ #category : #accessing }
MbndAbstractTemplateInstance >> module [
	^ parent module
]

{ #category : #accessing }
MbndAbstractTemplateInstance >> name [
	^ #_
]

{ #category : #accessing }
MbndAbstractTemplateInstance >> parent [
	^ parent
]

{ #category : #accessing }
MbndAbstractTemplateInstance >> parent: anObject [
	parent := anObject
]

{ #category : #accessing }
MbndAbstractTemplateInstance >> postMaterializeSetupParent: newParent withModule: newModule [
	self parent: newParent.
	self childrenDo: [ :child |
		child postMaterializeSetupParent: self withModule: newModule
	].
]
