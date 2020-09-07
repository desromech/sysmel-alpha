"
SpPresenter is an abstract class which represent a applicative presenter made to be composed with other SpPresenter

Most often, I am used to display other subclasses of SpPresenter or subclasses of SpAbstractWidgetPresenter.

I collaborate with
- ValueHolder to managed some of my variables.
- SpecFocusOrder when no focusOrder are specified.
- SpecLayout
- WindowPresenter or DialogWindowPresenter to display myself.

A new subclass of SpPresenter must at least define initializeWidgets and defaultSpec on the class side.

I provide the following methods
- aboutText: set the text displayed in the About.
- initializeWindow: to set the title, and other information related to the window.
- extent: set the initial size of the window, alternative possibility is define again initialExtent, it must be called before have displayed the widget.
- focusOrder: set an instance what manage the order of focus of the keyboard navigation.
- bindKeyCombination:toAction: create a shortcut on keyboard what perform the block of the  action.
- owner getter of my parent.
- window getter of the window displaying me.

On my class side, I provide methods returning standard height and width for some elements.

todo
- announce:
- applyMenuModel: and neglectMenuModel:
- keyStrokeForNextFocus:, giveFocusToNextFrom: and takeKeyboardFocus
- ensureExtentFor:
- hide
- needRebuild
- on:do:
- update:
- widget

Window
=======

- openWithSpec instantiates a WindowPresenter using the lookup to found the layout to use.
- openDialogWithSpec instanciates a DialogWindowPresenter using the lookup to found the layout to use.
Their variants openWithSpec: and openDialogWithSpec:  use the layout parameter.

These methods can be useful to manage the window
- isDisplayed returns true if the window of the widget is displayed
- hasWindow returns true if the widget have a window
- centered to center the window in the world.
- delete to delete the window.

todo
- cancelled
- setModal:
- windowIcon:


Instantiation
===========

* initializeWidgets is called by the initialize method, it should contain initialization of subwidgets and of the focusorder.

The instantiation of a subwidget should use one of that way
- instantiate: take a class in parameter and return the created instance.
- methods named 'new' followed by a widget name are shortcut working with instatiate:

Usually, the subwidgets must be added in the focusOrder using something like 'self focusOrder add: accessor of  the  subwidget'

Note that instantiateModels: is legacy code in ComposablePresenter and must not be used. It will be deprecated and removed.

* initializePresenter is called by the initialize method after initializeWidgets, it should manage interaction of subwidgets.

Methods named 'when' followed by an event provide hook to perform the action in parameter.

Note
-------
Be careful about code order if you are overriding initialize method.
Normally in Spec initializing instance variables should be done BEFORE calling super initialize (so the opposite of the normal approach), because super initialize calls initalizeWidgets and initializePresenter that normally would make use of those variables.

Layout
======

See SpecLayout

defaultSpec or a method containing the pragma <spec: #default> must be defined in the class side of my subclasses.
It contains informations about how place its elements.
It possible to define more than one method to give the possibility to use another layout, by default the one containing the pragma will be used if it exists, if not defaultSpec will be used.
"
Class {
	#name : #SpPresenter,
	#superclass : #SpAbstractPresenter,
	#instVars : [
		'application',
		'visible',
		'extent',
		'announcer',
		'windowIcon',
		'aboutText',
		'askOkToClose',
		'titleHolder',
		'layout'
	],
	#category : #'Spec2-Core-Base'
}

{ #category : #'as yet unclassified' }
SpPresenter class >> currentApplication [

	^ SpApplication defaultApplication
]

{ #category : #specs }
SpPresenter class >> defaultSpec [

	^ self subclassResponsibility
]

{ #category : #'instance creation' }
SpPresenter class >> newApplication: anApplication [

	^ self basicNew
		application: anApplication;
		initialize;
		yourself
]

{ #category : #'instance creation' }
SpPresenter class >> newApplication: anApplication model: aModel [

	^ self basicNew
		application: anApplication;
		setModelBeforeInitialization: aModel;
		initialize;
		yourself
]

{ #category : #'instance creation' }
SpPresenter class >> newApplication: anApplication owner: anOwningPresenter [

	^ self basicNew
		application: anApplication;
		owner: anOwningPresenter;
		initialize;
		yourself
]

{ #category : #'instance creation' }
SpPresenter class >> newApplication: anApplication owner: anOwningPresenter model: aDomainObject [

	^ self basicNew
		application: anApplication;
		owner: anOwningPresenter;
		setModelBeforeInitialization: aDomainObject;
		initialize;
		yourself
]

{ #category : #'instance creation' }
SpPresenter class >> on: aDomainObject [

	^ self
		newApplication: self currentApplication
		model: aDomainObject
]

{ #category : #'instance creation' }
SpPresenter class >> owner: anOwningPresenter on: aDomainObject [

	^ self basicNew
		owner: anOwningPresenter;
		setModelBeforeInitialization: aDomainObject;
		initialize;
		yourself
]

{ #category : #specs }
SpPresenter class >> title [

	^ 'Untitled window'
]

{ #category : #accessing }
SpPresenter >> application [
	^ application
]

{ #category : #accessing }
SpPresenter >> application: anApplication [
	application := anApplication
]

{ #category : #'as yet unclassified' }
SpPresenter >> connectPresenters [
	"The method connectPresenters defines the interactions between the dif- ferent widgets. By connecting the behaviors of the different widgets it speci- fies the overall presentation, i.e., how the overall UI responds to interactions by the user. Usually this method consists of specifications of actions to per- form when a certain event is received by a widget. The whole interaction flow of the UI then emerges from the propagation of those events."
]

{ #category : #'as yet unclassified' }
SpPresenter >> defaultWindowPresenterClass [

	^ SpWindowPresenter
]

{ #category : #initialization }
SpPresenter >> initialize [

	super initialize.

	visible := true.

	self initializePrivateAnnouncer.
	self initializePrivateHooks.
	self initializePrivateAnnouncements
]

{ #category : #initialization }
SpPresenter >> initializePresenter [
	"Now, presenters should implement #connectPresenters instead."

	self
		property: #extent
		whenChangedDo: [ :ex |
			self withAdapterDo: [ :widget |
				(widget respondsTo: #extent:)
					ifTrue: [ widget extent: ex ] ] ]
]

{ #category : #initialization }
SpPresenter >> initializePresenters [
	"The method initializePresenters instantiates, saves in instance vari- ables, and partially configures the different widgets that will be part of the UI.
	In general the initializePresenters method should follow the pattern:
		• widget instantiation
		• widget configuration specification
		• specification of focus order"

	"self subclassResponsibility"
]

{ #category : #'initialization - private' }
SpPresenter >> initializePrivateAnnouncements [

	self property: #titleHolder whenChangedDo: [ self updateTitle ].
	self property: #layout whenChangedDo: [ :newLayout | self replaceLayoutWith: newLayout ]
]

{ #category : #'initialization - private' }
SpPresenter >> initializePrivateAnnouncer [

  announcer := Announcer new.

]

{ #category : #'initialization - private' }
SpPresenter >> initializePrivateHooks [
	self flag: #todo. "We should remove later #initializeWidgets and #initializePresenter."
	self initializeWidgets.
	self initializePresenters.
	self initializePresenter.
	self connectPresenters.
	self updatePresenter.

]

{ #category : #initialization }
SpPresenter >> initializeWidgets [
	"Now, presenters should implement #initializePresenters instead."
]

{ #category : #initialization }
SpPresenter >> initializeWindow: aWindowPresenter [
	"override this to set window values before opening.
	 You may want to add a menu, a toolbar or a statusbar"

	"IMPORTANT: Please ovirride this method and set yourself the informations you want in your window.
	The content of this method is here to help the transition between Spec 1 and 2.
	In the next Spec version the content of this method will be removed and it will do nothing by default because the goal is to remove the management of all of those informations from Composable to put them in WindowPresenter."

]

{ #category : #'accessing model' }
SpPresenter >> setModel: aDomainObject [


]

{ #category : #'accessing model' }
SpPresenter >> setModelBeforeInitialization: aDomainObject [

]

{ #category : #initialization }
SpPresenter >> updatePresenter [
]
