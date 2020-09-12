Extension { #name : #Number }

{ #category : #arithmetic }
Number >> @ y [
	^ Point x: self y: y
]

{ #category : #converting }
Number >> year [
	^ self year
]

{ #category : #converting }
Number >> years [
	^ Duration years: self
]

{ #category : #converting }
Number >> month [
	^ self months
]

{ #category : #converting }
Number >> months [
	^ Duration months: self
]

{ #category : #converting }
Number >> week [
	^ self weeks
]

{ #category : #converting }
Number >> weeks [
	^ Duration weeks: self
]

{ #category : #converting }
Number >> day [
	^ self days
]

{ #category : #converting }
Number >> days [
	^ Duration days: self
]

{ #category : #converting }
Number >> hour [
	^ self hours
]

{ #category : #converting }
Number >> hours [
	^ Duration hours: self
]

{ #category : #converting }
Number >> minute [
	^ self minutes
]

{ #category : #converting }
Number >> minutes [
	^ Duration minutes: self
]

{ #category : #converting }
Number >> second [
	^ self seconds
]

{ #category : #converting }
Number >> seconds [
	^ Duration seconds: self
]

{ #category : #converting }
Number >> milliSecond [
	^ self milliSecond
]

{ #category : #converting }
Number >> milliSeconds [
	^ Duration milliSecond: self
]

{ #category : #converting }
Number >> nanoSecond [
	^ self nanoSecond
]

{ #category : #converting }
Number >> nanoSeconds [
	^ Duration nanoSeconds: self
]
