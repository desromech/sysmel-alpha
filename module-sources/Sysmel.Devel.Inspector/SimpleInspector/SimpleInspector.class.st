Class {
	#name : #SimpleInspector,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'listView',
		'codeEditor'
	],
	#category : #SimpleInspector
}

{ #category : #'as yet unclassified' }
SimpleInspector class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #listView;
		add: #codeEditor;
		yourself
]

{ #category : #'as yet unclassified' }
SimpleInspector >> addKey: key value: value [
	Stdn stdout << 'TODO: Add key ' << key << ' ' << value; nl
]

{ #category : #accessing }
SimpleInspector >> codeEditor [
	^ codeEditor
]

{ #category : #initialization }
SimpleInspector >> initializePresenters [
	listView := self newList.
	codeEditor := self newText.
]

{ #category : #accessing }
SimpleInspector >> listView [
	^ listView
]

{ #category : #'as yet unclassified' }
SimpleInspector >> modelChanged [
	self model simpleInspectorEmitItemsInto: self
]
