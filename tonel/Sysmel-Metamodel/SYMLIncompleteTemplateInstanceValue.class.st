Class {
	#name : #SYMLIncompleteTemplateInstanceValue,
	#superclass : #SYMLIncompleteValue,
	#instVars : [
		'template',
		'arguments'
	],
	#category : #'Sysmel-Metamodel-Values'
}

{ #category : #accessing }
SYMLIncompleteTemplateInstanceValue >> arguments [
	^ arguments
]

{ #category : #accessing }
SYMLIncompleteTemplateInstanceValue >> arguments: anObject [
	arguments := anObject
]

{ #category : #'pattern matching' }
SYMLIncompleteTemplateInstanceValue >> matchValue: suppliedValue withMatchingContext: argumentMatchingContext at: position [
	self halt
]

{ #category : #'pattern matching' }
SYMLIncompleteTemplateInstanceValue >> matchValueOfType: suppliedArgumentType withMatchingContext: argumentMatchingContext at: position [
	| suppliedTemplateInstance suppliedTemplateArguments expectedTemplateArguments suppliedTemplateArgument expectedTemplateArgument |
	(suppliedArgumentType isInstanceOfTemplate: template) ifFalse: [
		(suppliedArgumentType valueType isInstanceOfTemplate: template) ifTrue: [
			^ self matchValueOfType: suppliedArgumentType valueType withMatchingContext: argumentMatchingContext at: position
		].

		(suppliedArgumentType cleanType isInstanceOfTemplate: template) ifTrue: [
			^ self matchValueOfType: suppliedArgumentType cleanType withMatchingContext: argumentMatchingContext at: position
		].

		(suppliedArgumentType cleanValueType isInstanceOfTemplate: template) ifTrue: [
			^ self matchValueOfType: suppliedArgumentType cleanValueType withMatchingContext: argumentMatchingContext at: position
		].
	
		^ nil
	].

	suppliedTemplateInstance := suppliedArgumentType parent.
	self assert: suppliedTemplateInstance isTemplateInstance.
	self assert: suppliedTemplateInstance parent == template.
	
	suppliedTemplateArguments := suppliedTemplateInstance arguments.
	expectedTemplateArguments := arguments.
	suppliedTemplateArguments size ~= expectedTemplateArguments size ifTrue: [ ^ nil ].
	
	1 to: suppliedTemplateArguments size do: [ :i |
		suppliedTemplateArgument := suppliedTemplateArguments at: i.
		expectedTemplateArgument := expectedTemplateArguments at: i.
		(expectedTemplateArgument matchValue: suppliedTemplateArgument withMatchingContext: argumentMatchingContext at: position) ifNil: [
			^ nil
		]
	].
	
	^ suppliedArgumentType
]

{ #category : #accessing }
SYMLIncompleteTemplateInstanceValue >> template [
	^ template
]

{ #category : #accessing }
SYMLIncompleteTemplateInstanceValue >> template: anObject [
	template := anObject
]
