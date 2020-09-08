Class {
	#name : #PharoLightTheme,
	#superclass : #UITheme,
	#classVars : [
		'Current'
	],
	#category : #UITheme
}

{ #category : #'as yet unclassified' }
PharoLightTheme class >> baseColor [
	^ Color r: 210 g: 210 b: 210 range: 255
]

{ #category : #'as yet unclassified' }
PharoLightTheme class >> basePassiveBackgroundColor [
	^ Color r: 245 g: 245 b: 245 range: 255
]

{ #category : #'as yet unclassified' }
PharoLightTheme class >> baseSelectionColor [
	^ Color r: 97 g: 163 b: 225 range: 255
]

{ #category : #'as yet unclassified' }
PharoLightTheme class >> darkBaseColor [
	^ Color r: 200 g: 200 b: 200 range: 255
]

{ #category : #'as yet unclassified' }
PharoLightTheme class >> lightBaseColor [
	^ Color r: 230 g: 230 b: 230 range: 255
]

{ #category : #'as yet unclassified' }
PharoLightTheme class >> lightSelectionColor [
	^ Color r: 175 g: 213 b: 250 range: 255
]

{ #category : #'as yet unclassified' }
PharoLightTheme class >> veryLightSelectionColor [
	^ self lightSelectionColor muchLighter
]
