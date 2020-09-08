Class {
	#name : #UIThemeRegistry,
	#superclass : #Object,
	#category : #UITheme
}

{ #category : #'as yet unclassified' }
UIThemeRegistry class >> theme [
	^ UITheme current
]
