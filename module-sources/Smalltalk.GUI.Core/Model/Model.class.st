Class {
	#name : #Model,
	#superclass : #Object,
	#instVars : [
		'dependents',
		'announcer'
	],
	#category : #Model
}

{ #category : #accessing }
Model >> announcer [

	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #updating }
Model >> changed [
	"Receiver changed in a general way; inform all the dependents by 
	sending each dependent an update: message."

	self changed: self
]

{ #category : #updating }
Model >> changed: aParameter [ 
	"Receiver changed. The change is denoted by the argument aParameter. 
	Usually the argument is a Symbol that is part of the dependent's change 
	protocol. Inform all of the dependents."

	self dependents do: [:aDependent | aDependent update: aParameter]
]

{ #category : #updating }
Model >> changed: anAspect with: anObject [
	"Receiver changed. The change is denoted by the argument anAspect. 
	Usually the argument is a Symbol that is part of the dependent's change 
	protocol. Inform all of the dependents. Also pass anObject for additional information."

	self dependents do: [:aDependent | aDependent update: anAspect with: anObject]
]

{ #category : #dependents }
Model >> dependents [
	"Answer a collection of objects that are 'dependent' on the receiver;
	 that is, all objects that should be notified if the receiver changes."

	^ self myDependents ifNil: [#()]
]

{ #category : #accessing }
Model >> myDependents [

	^ dependents
]

{ #category : #'dependents-private' }
Model >> myDependents: aCollectionOrNil [

	dependents := aCollectionOrNil
]

{ #category : #updating }
Model >> okToChange [
	"Allows a controller to ask this of any model"
	^ true
]

{ #category : #stepping }
Model >> step [
	"Default for morphic models is no-op"
]

{ #category : #stepping }
Model >> stepAt: millisecondClockValue in: aWindow [

	^ self stepIn: aWindow
]

{ #category : #stepping }
Model >> stepIn: aWindow [

	^ self step
]

{ #category : #stepping }
Model >> stepTime [
	
	^ 1000 "milliseconds -- default backstop for objects serving as models of system windows"
]

{ #category : #stepping }
Model >> stepTimeIn: aSystemWindow [
	
	^ self stepTime 
]

{ #category : #updating }
Model >> update: anAspect [

	^ self
]

{ #category : #updating }
Model >> update: anAspect with: anObject [
	"Receive a change notice from an object of whom the receiver is a 
	dependent. The default behavior is to call update:,
	which by default does nothing; a subclass might want 
	to change itself in some way."

	^ self update: anAspect
]

{ #category : #stepping }
Model >> wantsSteps [
	"Overridden by morphic classes whose instances want to be stepped,
	or by model classes who want their morphic views to be stepped."

	^ false
]

{ #category : #'as yet unclassified' }
Model >> wantsStepsIn: aSystemWindow [
	
	^ self wantsSteps
]

{ #category : #updating }
Model >> windowIsClosing [
	"This message is used to inform a models that its window is closing. Most models do nothing, but some, such as the Debugger, must do some cleanup. Note that this mechanism must be used with care by models that support multiple views, since one view may be closed while others left open."

]
