Class {
	#name : #SpPresenterWithModel,
	#superclass : #SpPresenter,
	#instVars : [
		'announcingObject'
	],
	#category : #'Spec2-Core-Base'
}

{ #category : #acccessing }
SpPresenterWithModel >> model [
	^ announcingObject
]

{ #category : #acccessing }
SpPresenterWithModel >> model: aModel [
	announcingObject := aModel.
	self modelChanged.
]

{ #category : #updating }
SpPresenterWithModel >> modelChanged [

	"subclass responsibility (optional)"
]

{ #category : #acccessing }
SpPresenterWithModel >> setModelBeforeInitialization: aModel [
	announcingObject := aModel
]

{ #category : #updating }
SpPresenterWithModel >> updatePresenter [
	self modelChanged
]
