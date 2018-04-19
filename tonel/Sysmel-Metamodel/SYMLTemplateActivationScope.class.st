Class {
	#name : #SYMLTemplateActivationScope,
	#superclass : #SYMLLexicalScope,
	#instVars : [
		'template',
		'instance'
	],
	#category : #'Sysmel-Metamodel-Scope'
}

{ #category : #accessing }
SYMLTemplateActivationScope >> definitionProgramEntity [
	^ instance
]

{ #category : #accessing }
SYMLTemplateActivationScope >> instance: anObject [
	instance := anObject
]

{ #category : #accessing }
SYMLTemplateActivationScope >> template [
	^ template
]

{ #category : #accessing }
SYMLTemplateActivationScope >> template: anObject [
	template := anObject
]
