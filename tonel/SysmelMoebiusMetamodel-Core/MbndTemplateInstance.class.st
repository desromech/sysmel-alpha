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

{ #category : #visiting }
MbndTemplateInstance >> accept: aVisitor [
	^ aVisitor visitTemplateInstance: self
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
