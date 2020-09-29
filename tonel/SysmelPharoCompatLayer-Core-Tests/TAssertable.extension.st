Extension { #name : #TAssertable }

{ #category : #'*SysmelPharoCompatLayer-Core-Tests' }
TAssertable >> assert: actualNumber notCloseTo: expectedNumber [
	^ self
		deny: (actualNumber closeTo: expectedNumber)
		description: [self comparingStringBetween: actualNumber and: expectedNumber]
]
