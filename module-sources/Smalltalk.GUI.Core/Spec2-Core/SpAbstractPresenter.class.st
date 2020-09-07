"
I'm a base for all presenters.
I define common behaviours for widget presenters and also for composable presenters (the ones an user regularly uses).
"
Class {
	#name : #SpAbstractPresenter,
	#superclass : #Model,
	#instVars : [
		'adapter',
		'owner'
	],
	#category : #'Spec2-Core-Base'
}

{ #category : #'as yet unclassified' }
SpAbstractPresenter class >> isAbstract [
	^ self = SpAbstractPresenter
]

{ #category : #'as yet unclassified' }
SpAbstractPresenter class >> owner: anOwningPresenter [

	^ self basicNew
		owner: anOwningPresenter;
		initialize;
		yourself
]

{ #category : #accessing }
SpAbstractPresenter >> adapter [
	^ adapter
]

{ #category : #accessing }
SpAbstractPresenter >> adapter: anAdapter [
	adapter := anAdapter
]

{ #category : #accessing }
SpAbstractPresenter >> application [
	"Answer application owner of this composition.
	 The tree for a composition starts always with an application, which is responsible of
	 providing all resources the presenter needs. "

	^ self owner application
]

{ #category : #'private building' }
SpAbstractPresenter >> defaultSpecSelector [
	^ #defaultSpec
	"(Pragma allNamed: #spec: from: self class class to: SpAbstractPresenter class class) detect: [ :each | (each argumentAt: 1) = #default ] ifFound: [ :pragma | ^ pragma methodSelector ].

	^ (Pragma allNamed: #spec from: self class class to: SpAbstractPresenter class class)
		ifEmpty: [ #defaultSpec ]
		ifNotEmpty: [ :pragmas | pragmas size = 1 ifTrue: [ pragmas first methodSelector ] ifFalse: [ #defaultSpec ] ]"
]

{ #category : #showing }
SpAbstractPresenter >> openWithSpec [

	^ self application
		open: self
		withSpecLayout: self retrieveDefaultSpec
]

{ #category : #accessing }
SpAbstractPresenter >> owner [
	^ owner
]

{ #category : #accessing }
SpAbstractPresenter >> owner: anOwner [
	owner := anOwner
]

{ #category : #'as yet unclassified' }
SpAbstractPresenter >> property: aName whenChangedDo: aBlock [
	self flag: 'todo'
]

{ #category : #'private building' }
SpAbstractPresenter >> retrieveDefaultSpec [

	^ self retrieveSpec: self defaultSpecSelector
]

{ #category : #'as yet unclassified' }
SpAbstractPresenter >> retrieveSpec: aSelector [
	| layout |

	layout := self class perform: aSelector.
	layout isSpLayout ifTrue: [
		layout selector: aSelector ].
	^ layout
]

{ #category : #accessing }
SpAbstractPresenter >> root [
	"Answer root presenter of this composition."

	^ self owner
		ifNotNil: [ :presenter | presenter root ]
		ifNil: [ self ]
]
