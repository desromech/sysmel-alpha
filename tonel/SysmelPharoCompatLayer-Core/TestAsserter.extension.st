Extension { #name : #TestAsserter }

{ #category : #'*SysmelPharoCompatLayer-Core' }
TestAsserter >> assert: actualNumber notCloseTo: expectedNumber [
	^ self
		deny: (actualNumber closeTo: expectedNumber)
		description: [self comparingStringBetween: actualNumber and: expectedNumber]
]
