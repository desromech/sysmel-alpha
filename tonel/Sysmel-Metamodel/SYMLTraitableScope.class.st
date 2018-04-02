Class {
	#name : #SYMLTraitableScope,
	#superclass : #SYMLProgramEntityScope,
	#instVars : [
		'symbols'
	],
	#category : #'Sysmel-Metamodel-Scope'
}

{ #category : #'as yet unclassified' }
SYMLTraitableScope >> definitionProgramEntity [
	^ programEntity
]

{ #category : #accessing }
SYMLTraitableScope >> fillSymbols [
	| module |
	module := programEntity module.
	symbols
		at: #method put: (SYMLMetaBuilder for: SYMLMethod module: module);
		yourself
	
]

{ #category : #initialization }
SYMLTraitableScope >> initialize [
	super initialize.
	symbols := Dictionary new.
]

{ #category : #'as yet unclassified' }
SYMLTraitableScope >> lookSymbol: symbol ifPresent: ifPresentBlock [
	symbols at: symbol ifPresent: [ :existent | ^ ifPresentBlock value: existent ].
	programEntity lookSymbol: symbol ifPresent: ifPresentBlock
]

{ #category : #accessing }
SYMLTraitableScope >> programEntity: anObject [
	programEntity := anObject.
	self fillSymbols
]
