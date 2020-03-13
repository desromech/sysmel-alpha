Class {
	#name : #MbndProfiler,
	#superclass : #Object,
	#classVars : [
		'ProfilerActive',
		'ProfilerReports',
		'SubComponentRunning'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

{ #category : #initialization }
MbndProfiler class >> activate [
	<script>
	ProfilerActive := true
]

{ #category : #initialization }
MbndProfiler class >> component: elementName with: aBlock [
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
MbndProfiler class >> deactivate [
	<script>
	ProfilerActive := false
]

{ #category : #initialization }
MbndProfiler class >> isActive [
	^ ProfilerActive ifNil: [ ProfilerActive := false ]
]

{ #category : #initialization }
MbndProfiler class >> report [
	<script: 'self report inspect'>
	^ ProfilerReports ifNil: [ ProfilerReports := OrderedDictionary new ]
]

{ #category : #initialization }
MbndProfiler class >> reset [
	<script>
	self report removeAll
]
