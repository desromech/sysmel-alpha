Class {
	#name : #SYMLTemplateActivationScope,
	#superclass : #SYMLLexicalScope,
	#instVars : [
		'template'
	],
	#category : #'Sysmel-Metamodel-Scope'
}

{ #category : #accessing }
SYMLTemplateActivationScope >> template [
	^ template
]

{ #category : #accessing }
SYMLTemplateActivationScope >> template: anObject [
	template := anObject
]
