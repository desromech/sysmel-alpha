Class {
	#name : #SYMLRuleBasedMetaMethod,
	#superclass : #SYMLMetaMethod,
	#instVars : [
		'rules'
	],
	#category : #Sysmel-Metamodel-MetaMethods
}

{ #category : #adding }
SYMLRuleBasedMetaMethod >> addRules: newRules [
	rules addAll: newRules
]

{ #category : #'meta methods' }
SYMLRuleBasedMetaMethod >> analyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition [
	rules do: [ :rule |
		(rule matchesMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition) ifTrue: [ 
			^ rule analyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition
		]
	].
	self error: 'Failed to analyze message.'
]

{ #category : #'meta methods' }
SYMLRuleBasedMetaMethod >> canAnalyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition [
	rules do: [ :rule |
		(rule matchesMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition) ifTrue: [ 
			^ true
		]
	].
	^ false
]

{ #category : #initialization }
SYMLRuleBasedMetaMethod >> initialize [
	super initialize.
	rules := OrderedCollection new.
	
]

{ #category : #testing }
SYMLRuleBasedMetaMethod >> isRuleBasedMetaMethod [
	^ true
]

{ #category : #accessing }
SYMLRuleBasedMetaMethod >> rules [
	^ rules
]
