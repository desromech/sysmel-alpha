Class {
	#name : #MbndBenchmark,
	#superclass : #Object,
	#classVars : [
		'BenchmarkActive',
		'BenchmarkReports',
		'SubComponentRunning'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

{ #category : #initialization }
MbndBenchmark class >> activate [
	BenchmarkActive := true
]

{ #category : #initialization }
MbndBenchmark class >> component: elementName with: aBlock [
	| resultValue runningTime totalRunningTime oldSubrunningTime |
	self isActive ifFalse: [ ^ aBlock value ].
	
	oldSubrunningTime := SubComponentRunning ifNil: [0].
	SubComponentRunning := 0.
	[ 
		runningTime := (Time microsecondsToRun: [resultValue := aBlock value]) *0.001.
		totalRunningTime := runningTime + (self report at: elementName ifAbsent: [ 0 ]) - SubComponentRunning.
		self report at: elementName put: totalRunningTime.
	] ensure: [ SubComponentRunning := oldSubrunningTime + runningTime ].
	^ resultValue
]

{ #category : #initialization }
MbndBenchmark class >> deactivate [
	BenchmarkActive := false
]

{ #category : #initialization }
MbndBenchmark class >> isActive [
	^ BenchmarkActive ifNil: [ BenchmarkActive := false ]
]

{ #category : #initialization }
MbndBenchmark class >> report [
	^ BenchmarkReports ifNil: [ BenchmarkReports := OrderedDictionary new ]
]

{ #category : #initialization }
MbndBenchmark class >> reset [
	self report removeAll
]
