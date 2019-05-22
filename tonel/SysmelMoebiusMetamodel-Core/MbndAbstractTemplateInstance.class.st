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
MbndAbstractTemplateInstance >> mainChild [
	^ mainChild
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
