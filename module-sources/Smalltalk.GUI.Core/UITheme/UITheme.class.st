Class {
	#name : #UITheme,
	#superclass : #Object,
	#classVars : [
		'Current'
	],
	#category : #UITheme
}

{ #category : #'as yet unclassified' }
UITheme class >> baseColor [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
UITheme class >> basePassiveBackgroundColor [ 
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
UITheme class >> baseSelectionColor [ 
	^ self subclassResponsibility 
]

{ #category : #accessing }
UITheme class >> current [
	^ Current ifNil: [ Current := PharoLightTheme new ]
]

{ #category : #accessing }
UITheme class >> current: aTheme [
	Current := aTheme
]

{ #category : #'as yet unclassified' }
UITheme class >> darkBaseColor [
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
UITheme class >> lightBaseColor [
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
UITheme class >> lightSelectionColor [ 
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
UITheme class >> veryLightSelectionColor [ 
	^ self subclassResponsibility 
]

{ #category : #'accessing colors' }
UITheme >> backgroundColor [

	^ Color white
]

{ #category : #'accessing colors' }
UITheme >> balloonBackgroundColor [

	^self lightBaseColor
]

{ #category : #'accessing colors' }
UITheme >> balloonTextColor [

	^self textColor
]

{ #category : #'accessing colors' }
UITheme >> baseColor [
	^ self class baseColor
]

{ #category : #'accessing colors' }
UITheme >> borderColor [ 
	^ Color gray
]

{ #category : #'accessing colors' }
UITheme >> buttonColor [ 
	^ self settings buttonColor
]

{ #category : #'accessing colors' }
UITheme >> caretColor [
	^ Color blue
]

{ #category : #'accessing colors' }
UITheme >> classExtensionColor [
	^ Color gray darker
]

{ #category : #'accessing colors' }
UITheme >> dangerBackgroundColor [
	^ self dangerTextColor darker darker
]

{ #category : #'accessing colors' }
UITheme >> dangerTextColor [
	^ Color red darker darker
]

{ #category : #'accessing colors' }
UITheme >> darkBaseColor [
	^ self class darkBaseColor
]

{ #category : #'accessing colors' }
UITheme >> disabledColor [ 
	^ Color gray
]

{ #category : #'accessing colors' }
UITheme >> disabledTextColor [ 
	^ self disabledColor
]

{ #category : #'accessing colors' }
UITheme >> enabledColor [ 
	^ Color black
]

{ #category : #'accessing colors' }
UITheme >> ghostTextColor [ 
	^ Color lightGray
]

{ #category : #'accessing colors' }
UITheme >> lightBackgroundColor [ 
	^ Color veryLightGray muchLighter
]

{ #category : #'accessing colors' }
UITheme >> lightBaseColor [

	^ self class lightBaseColor
]

{ #category : #'accessing colors' }
UITheme >> lineNumberColor [ 
	^ Color gray muchDarker
]

{ #category : #'accessing colors' }
UITheme >> listBackgroundColor [
	^ self backgroundColor
]

{ #category : #'accessing colors' }
UITheme >> listTextColor [
	"Answer the list text color to use."

	^Color black
]

{ #category : #'accessing colors' }
UITheme >> menuBorderColor [
	^  self settings menuBorderColor
]

{ #category : #'accessing colors' }
UITheme >> menuColor [
	"Answer the menu color to use."

	^self settings menuColor
]

{ #category : #'accessing colors' }
UITheme >> menuKeyboardFocusColor [
	^ self settings menuKeyboardFocusColor
]

{ #category : #'accessing colors' }
UITheme >> menuSelectionColor [
	^ self settings menuSelectionColor
]

{ #category : #'accessing colors' }
UITheme >> menuShadowColor [
	^ self settings menuShadowColor
]

{ #category : #'accessing colors' }
UITheme >> menuTitleColor [
	"Answer the menu title color to use."
	^self settings menuTitleColor
]

{ #category : #'accessing colors' }
UITheme >> scrollbarColor [
	^ self settings scrollbarColor
]

{ #category : #'accessing colors' }
UITheme >> secondarySelectionColor [
	^ Color r: 0.927 g: 0.962 b: 0.995 alpha: 1.0
]

{ #category : #'accessing colors' }
UITheme >> selectedItemListTextColor [
	"Answer the color for the selected item in a list text."

	^ self textColor
]

{ #category : #'accessing colors' }
UITheme >> selectionBarColor [

	^ self settings selectionBarColor


]

{ #category : #'accessing colors' }
UITheme >> selectionColor [
	"Answer the selection color to use.."

	^ self settings selectionColor
]

{ #category : #'accessing colors' }
UITheme >> selectionTextColor [
 ^ self settings selectionTextColor
]

{ #category : #'accessing colors' }
UITheme >> spotlightWindowColor [ 
	^ self selectionColor muchDarker
]

{ #category : #'accessing colors' }
UITheme >> successBackgroundColor [
	^ self successTextColor lighter lighter
]

{ #category : #'accessing colors' }
UITheme >> successTextColor [
	^ Color r: 0 g: 0.5 b: 0
]

{ #category : #'accessing colors' }
UITheme >> textColor [ 
	^ Color black
]

{ #category : #'accessing colors' }
UITheme >> textColorForNonStandardBackground [
	^ self textColor
]

{ #category : #'accessing colors' }
UITheme >> unfocusedSelectionColor [
	^ self settings unfocusedSelectionColor
]

{ #category : #'accessing colors' }
UITheme >> urlColor [
	^ Color fromHexString: '03A9F4'
]

{ #category : #'accessing colors' }
UITheme >> warningBackgroundColor [
	^ Color yellow
]

{ #category : #'accessing colors' }
UITheme >> warningTextColor [
	^ Color yellow muchDarker
]

{ #category : #'accessing colors' }
UITheme >> windowColor [
	"Answer the window color to use."

	^self settings windowColor
]

{ #category : #'as yet unclassified' }
UITheme >> windowShadowColor [
	"Answer the window shadow color to use."

	^ Color gray
]
