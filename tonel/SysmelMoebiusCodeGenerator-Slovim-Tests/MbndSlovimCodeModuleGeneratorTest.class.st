"
A MbndSlovimCodeModuleGeneratorTest is a test class for testing the behavior of MbndSlovimCodeModuleGenerator
"
Class {
	#name : #MbndSlovimCodeModuleGeneratorTest,
	#superclass : #MbndSlovimCodeModuleGeneratorCommonTest,
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Tests-Module'
}

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testAggregateGeneratedInitializeFinalize [
	| function classWithGuard |
	self
		evaluateSysmelSource: '
class Guard definition: { 
	method initialize => Void
		:= grabLock().
	method finalize => Void
		:= releaseLock().
}.

function grabLock externC() => Void.
function releaseLock externC() => Void.

class ClassWithGuard definition: {
	field guard type: Guard.
}.
';
		generateSSAModule.

	classWithGuard := (self evaluateSysmelSource: 'ClassWithGuard') unwrapMbndValue.
	self deny: classWithGuard hasTrivialInitialization.
	self deny: classWithGuard hasTrivialFinalization.

	function := ssaModule globalNamed: #'_ZN10TestModule14ClassWithGuard11.initializeERNS0_E'.
	self assert: function isFunction.
	self assert: function basicBlocks size equals: 2.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (getElementPointer call returnVoid))
	).
	self assert: function basicBlocks second firstInstruction nextInstruction functionValue name equals: #'_ZN10TestModule5Guard11.initializeERNS0_E'.
	
	function := ssaModule globalNamed: #'_ZN10TestModule14ClassWithGuard9.finalizeERNS0_E'.
	self assert: function isFunction.
	self assert: function basicBlocks size equals: 2.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (getElementPointer call returnVoid))
	).
	self assert: function basicBlocks second firstInstruction nextInstruction functionValue name equals: #'_ZN10TestModule5Guard9.finalizeERNS0_E'.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testAggregateGeneratedInitializeFinalizeExplicitMethod [
	| function classWithGuard |
	self
		evaluateSysmelSource: '
class Guard definition: { 
	method initialize => Void
		:= grabLock().
	method finalize => Void
		:= releaseLock().
}.

function grabLock externC() => Void.
function methodWithSideEffect externC() => Void.
function releaseLock externC() => Void.

class ClassWithGuard definition: {
	field guard type: Guard.

	method initialize => Void
		:= { methodWithSideEffect(). }.
	method finalize => Void
		:= { methodWithSideEffect(). }.
}.
';
		generateSSAModule.

	classWithGuard := (self evaluateSysmelSource: 'ClassWithGuard') unwrapMbndValue.
	self deny: classWithGuard hasTrivialInitialization.
	self deny: classWithGuard hasTrivialFinalization.

	function := ssaModule globalNamed: #'_ZN10TestModule14ClassWithGuard11.initializeERNS0_E'.
	self assert: function isFunction.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (getElementPointer call #jump))
		(tryScope (#jump))
		(tryScope (call returnVoid))
	).
	self assert: function basicBlocks second firstInstruction nextInstruction functionValue name equals: #'_ZN10TestModule5Guard11.initializeERNS0_E'.
	self assert: function basicBlocks fourth firstInstruction functionValue name equals: #'methodWithSideEffect'.
	
	function := ssaModule globalNamed: #'_ZN10TestModule14ClassWithGuard9.finalizeERNS0_E'.
	self assert: function isFunction.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (jump))
		(tryScope (call getElementPointer call returnVoid))
	).
	self assert: function basicBlocks third firstInstruction functionValue name equals: #'methodWithSideEffect'.
	self assert: function basicBlocks third firstInstruction nextInstruction nextInstruction functionValue name equals: #'_ZN10TestModule5Guard9.finalizeERNS0_E'.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testAggregateGeneratedSubclassInitializeFinalize [
	| function subclassWithGuard |
	self
		evaluateSysmelSource: '
class Guard definition: { 
	method initialize => Void
		:= grabLock().
	method finalize => Void
		:= releaseLock().
}.

function grabLock externC() => Void.
function releaseLock externC() => Void.

class ClassWithGuard definition: {
	field guard type: Guard.
}.

class SubClassWithGuard superclass: ClassWithGuard; definition: {
}.

';
		generateSSAModule.

	subclassWithGuard := (self evaluateSysmelSource: 'SubClassWithGuard') unwrapMbndValue.
	self deny: subclassWithGuard hasTrivialInitialization.
	self deny: subclassWithGuard hasTrivialFinalization.

	function := ssaModule globalNamed: #'_ZN10TestModule17SubClassWithGuard11.initializeERNS0_E'.
	self assert: function isFunction.
	self assert: function basicBlocks size equals: 2.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (bitcast call returnVoid))
	).
	self assert: function basicBlocks second firstInstruction nextInstruction functionValue name equals: #'_ZN10TestModule14ClassWithGuard11.initializeERNS0_E'.
	
	function := ssaModule globalNamed: #'_ZN10TestModule17SubClassWithGuard9.finalizeERNS0_E'.
	self assert: function isFunction.
	self assert: function basicBlocks size equals: 2.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (bitcast call returnVoid))
	).
	self assert: function basicBlocks second firstInstruction nextInstruction functionValue name equals: #'_ZN10TestModule14ClassWithGuard9.finalizeERNS0_E'.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testAggregateGeneratedSubclassInitializeFinalizeExplicitMethod [
	| function subclassWithGuard |
	self
		evaluateSysmelSource: '
class Guard definition: { 
	method initialize => Void
		:= grabLock().
	method finalize => Void
		:= releaseLock().
}.

function grabLock externC() => Void.
function releaseLock externC() => Void.
function methodWithSideEffect externC() => Void.

class ClassWithGuard definition: {
	field guard type: Guard.
}.

class SubClassWithGuard superclass: ClassWithGuard; definition: {
	method initialize => Void := {
		super initialize.
		methodWithSideEffect().
	}.
	
	method finalize => Void := {
		methodWithSideEffect().
		super finalize.
	}.
}.

';
		generateSSAModule.

	subclassWithGuard := (self evaluateSysmelSource: 'SubClassWithGuard') unwrapMbndValue.
	self deny: subclassWithGuard hasTrivialInitialization.
	self deny: subclassWithGuard hasTrivialFinalization.

	function := ssaModule globalNamed: #'_ZN10TestModule17SubClassWithGuard11.initializeERNS0_E'.
	self assert: function isFunction.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (jump))
		(tryScope (bitcast call call returnVoid))
	).
	self assert: function basicBlocks third firstInstruction nextInstruction functionValue name equals: #'_ZN10TestModule14ClassWithGuard11.initializeERNS0_E'.
	self assert: function basicBlocks third firstInstruction nextInstruction nextInstruction functionValue name equals: #methodWithSideEffect.
	
	function := ssaModule globalNamed: #'_ZN10TestModule17SubClassWithGuard9.finalizeERNS0_E'.
	self assert: function isFunction.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (jump))
		(tryScope (call bitcast call returnVoid))
	).
	self assert: function basicBlocks third firstInstruction functionValue name equals: #methodWithSideEffect.
	self assert: function basicBlocks third firstInstruction nextInstruction nextInstruction functionValue name equals: #'_ZN10TestModule14ClassWithGuard9.finalizeERNS0_E'.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testAggregateGeneratedSubclassInitializeFinalizeExplicitMethod2 [
	| function subclassWithGuard |
	self
		evaluateSysmelSource: '
class Guard definition: { 
	method initialize => Void
		:= grabLock().
	method finalize => Void
		:= releaseLock().
}.

function grabLock externC() => Void.
function releaseLock externC() => Void.
function methodWithSideEffect externC() => Void.

class ClassWithGuard definition: {
	field guard type: Guard.
}.

class SubClassWithGuard superclass: ClassWithGuard; definition: {
	method initialize => Void := {
		methodWithSideEffect().
	}.
	
	method finalize => Void := {
		methodWithSideEffect().
	}.
}.

';
		generateSSAModule.

	subclassWithGuard := (self evaluateSysmelSource: 'SubClassWithGuard') unwrapMbndValue.
	self deny: subclassWithGuard hasTrivialInitialization.
	self deny: subclassWithGuard hasTrivialFinalization.

	function := ssaModule globalNamed: #'_ZN10TestModule17SubClassWithGuard11.initializeERNS0_E'.
	self assert: function isFunction.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (bitcast call jump))
		(tryScope #(jump))
		(tryScope #(call returnVoid))
	).
	self assert: function basicBlocks second firstInstruction nextInstruction functionValue name equals: #'_ZN10TestModule14ClassWithGuard11.initializeERNS0_E'.
	self assert: function basicBlocks fourth firstInstruction functionValue name equals: #methodWithSideEffect.
	
	function := ssaModule globalNamed: #'_ZN10TestModule17SubClassWithGuard9.finalizeERNS0_E'.
	self assert: function isFunction.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (jump))
		(tryScope (call bitcast call returnVoid))
	).
	self assert: function basicBlocks third firstInstruction functionValue name equals: #methodWithSideEffect.
	self assert: function basicBlocks third firstInstruction nextInstruction nextInstruction functionValue name equals: #'_ZN10TestModule14ClassWithGuard9.finalizeERNS0_E'.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testAggregateLocalInitialize [
	| function |
	self
		evaluateSysmelSource: '
class SomeResource definition: { 
	method initialize => Void
		:= initSideEffect().
}.

function initSideEffect externC() => Void.
function sideEffect externC() => Void.

function withSomeResource externC() => Void := {
	let _ mutable type: SomeResource.
	sideEffect().
}.
';
		generateSSAModule.

	function := ssaModule globalNamed: #withSomeResource.
	self assert: function isFunction.
	
	self assert: function allInstructionsMnemonics equals: #(
		(entry (alloca jump))
		(body (jump))
		(tryScope (store call call returnVoid))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testAggregateLocalInitializeFinalize [
	| function |
	self
		evaluateSysmelSource: '
class Guard definition: { 
	method initialize => Void
		:= grabLock().
	method finalize => Void
		:= releaseLock().

}.

function grabLock externC() => Void.
function sideEffect externC() => Void.
function releaseLock externC() => Void.

function useGuard externC() => Void := {
	let _ mutable type: Guard.
	sideEffect().
}.
';
		generateSSAModule.

	function := ssaModule globalNamed: #useGuard.
	self assert: function isFunction.
	
	self assert: function allInstructionsMnemonics equals: #(
		(entry (alloca alloca alloca alloca jump))
		(body (jump))
		(tryScope #(#store #store #call #store #call #jump))
		(normalCleanUpBlock #(#load #branch))
		(tryUnwind #(#landingpath #extractValue #store #extractValue #store #jump))
		(implicitCleanUpAction #(#call #jump))
		(implicitCleanUpMerge #(#returnVoid))
		(unwindCleanUp #(#load #branch))
		(forbiddenExceptionTarget #(#landingpath #extractValue #call #unreachable))
		(implicitCleanUpAction #(#call #jump))
		(implicitCleanUpMerge #(#load #insertValue #load #insertValue #resumeException))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testAggregateLocalInitializeFinalizeNoExceptions [
	| function |
	self
		disableExceptions;
		evaluateSysmelSource: '
class Guard definition: { 
	method initialize => Void
		:= grabLock().
	method finalize => Void
		:= releaseLock().

}.

function grabLock externC() => Void.
function sideEffect externC() => Void.
function releaseLock externC() => Void.

function useGuard externC() => Void := {
	let _ mutable type: Guard.
	sideEffect().
}.
';
		generateSSAModule.

	function := ssaModule globalNamed: #useGuard.
	self assert: function isFunction.
	
	self assert: function allInstructionsMnemonics equals: #(
		(entry (alloca alloca jump))
		(body (store store call store call load branch))
		(implicitCleanUpAction (call jump))
		(implicitCleanUpMerge (returnVoid))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testAggregateLocalInitializeFinalizeWithExplicitReturn [
	| function |
	self
		evaluateSysmelSource: '
class Guard definition: { 
	method initialize => Void
		:= grabLock().
	method finalize => Void
		:= releaseLock().
}.

function grabLock externC() => Void.
function sideEffect externC() => Void.
function releaseLock externC() => Void.

function useGuard externC() => Int32 := {
	let _ mutable type: Guard.
	sideEffect().
	return: 42
}.
';
		generateSSAModule.

	function := ssaModule globalNamed: #useGuard.
	self assert: function isFunction.
	
	self assert: function allInstructionsMnemonics equals: #(
		#(#entry #(#alloca #alloca #alloca #alloca #jump))
		#(#body #(#jump))
		#(#tryScope #(#store #store #call #store #call #load #branch))
		#(#tryUnwind #(#landingpath #extractValue #store #extractValue #store #jump))
		#(#implicitCleanUpAction #(#call #jump))
		#(#implicitCleanUpMerge #(#return))
		#(#unwindCleanUp #(#load #branch))
		#(#forbiddenExceptionTarget #(#landingpath #extractValue #call #unreachable))
		#(#implicitCleanUpAction #(#call #jump))
		#(#implicitCleanUpMerge #(#load #insertValue #load #insertValue #resumeException))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testAggregateLocalInitializeFinalizeWithExplicitReturnNoException [
	| function |
	self
		disableExceptions;
		evaluateSysmelSource: '
class Guard definition: { 
	method initialize => Void
		:= grabLock().
	method finalize => Void
		:= releaseLock().
}.

function grabLock externC() => Void.
function sideEffect externC() => Void.
function releaseLock externC() => Void.

function useGuard externC() => Int32 := {
	let _ mutable type: Guard.
	sideEffect().
	return: 42
}.
';
		generateSSAModule.

	function := ssaModule globalNamed: #useGuard.
	self assert: function isFunction.
	
	self assert: function allInstructionsMnemonics equals: #(
		(entry (alloca alloca jump))
		(body (store store call store call load branch))
		(implicitCleanUpAction (call jump))
		(implicitCleanUpMerge (return))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testAggregateWithLock [
	| function |
	self
		evaluateSysmelSource: '
class Mutex definition: { 
	method lock => Void
		:= grabLock().
	method unlock => Void
		:= releaseLock().

    macro method withLock: aBlock := ``{
		`,self lock.
        `,aBlock __macroInlineBlockEnsure: `,self unlock.
    }.
}.

function grabLock externC() => Void.
function sideEffect externC() => Void.
function releaseLock externC() => Void.

function useMutex externC() => Void := {
	let mutex mutable type: Mutex.
	mutex withLock: { 
		sideEffect().
	}
}.
';
		generateSSAModule.

	function := ssaModule globalNamed: #useMutex.
	self assert: function isFunction.
	
	self assert: function allInstructionsMnemonics equals: #(
		#(#entry #(#alloca #alloca #alloca #jump))
		#(#body #(#jump))
		#(#tryScope #(#store #jump))
		#(#tryScope #(#call #jump))
		#(#tryScope #(#jump))
		#(#normalCleanUpBlock #(#jump))
		#(#tryUnwind #(#landingpath #extractValue #store #extractValue #store #jump))
		#(#tryScope #(#call #jump))
		#(#tryScope #(#call #returnVoid))
		#(#forbiddenExceptionTarget #(#landingpath #extractValue #call #unreachable))
		#(#unwindCleanUp #(#jump))
		#(#tryScope #(#call #load #insertValue #load #insertValue #resumeException))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testAggregateWithLock2 [
	| function |
	self
		evaluateSysmelSource: '
class Mutex definition: { 
	method lock => Void
		:= grabLock().
	method unlock => Void
		:= releaseLock().

    macro method withLock: aBlock := ``{
		`,self lock.
		try: `,aBlock __macroInlineBlock finally: `,self unlock.
    }.
}.

function grabLock externC() => Void.
function sideEffect externC() => Void.
function releaseLock externC() => Void.

function useMutex externC() => Void := {
	let mutex mutable type: Mutex.
	mutex withLock: { 
		sideEffect().
	}
}.
';
		generateSSAModule.

	function := ssaModule globalNamed: #useMutex.
	self assert: function isFunction.
	
	self assert: function allInstructionsMnemonics equals: #(
		#(#entry #(#alloca #alloca #alloca #jump))
		#(#body #(#jump))
		#(#tryScope #(#store #jump))
		#(#tryScope #(#call #jump))
		#(#tryScope #(#jump))
		#(#normalCleanUpBlock #(#jump))
		#(#tryUnwind #(#landingpath #extractValue #store #extractValue #store #jump))
		#(#tryScope #(#call #jump))
		#(#tryScope #(#call #returnVoid))
		#(#forbiddenExceptionTarget #(#landingpath #extractValue #call #unreachable))
		#(#unwindCleanUp #(#jump))
		#(#tryScope #(#call #load #insertValue #load #insertValue #resumeException))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testAggregateWithLockExplicitReturn [
	| function |
	self
		evaluateSysmelSource: '
class Mutex definition: { 
	method lock => Void
		:= grabLock().
	method unlock => Void
		:= releaseLock().

    macro method withLock: aBlock := ``{
		`,self lock.
        `,aBlock __macroInlineBlockEnsure: `,self unlock.
    }.
}.

function grabLock externC() => Void.
function sideEffect externC() => Void.
function releaseLock externC() => Void.

function useMutex externC() => Int32 := {
	let mutex mutable type: Mutex.
	mutex withLock: { 
		sideEffect().
		return: 42
	}.
	
	return: 0
}.
';
		generateSSAModule.

	function := ssaModule globalNamed: #useMutex.
	self assert: function isFunction.
	
	self assert: function allInstructionsMnemonics equals: #(
		#(#entry #(#alloca #alloca #alloca #jump))
		#(#body #(#jump))
		#(#tryScope #(#store #jump))
		#(#tryScope #(#call #jump))
		#(#tryScope #(#jump))
		#(#tryUnwind #(#landingpath #extractValue #store #extractValue #store #jump))
		#(#tryScope #(#call #jump))
		#(#tryScope #(#call #return))
		#(#forbiddenExceptionTarget #(#landingpath #extractValue #call #unreachable))
		#(#unwindCleanUp #(#jump))
		#(#tryScope #(#call #load #insertValue #load #insertValue #resumeException))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testAggregateWithLockExplicitReturnNoExceptions [
	| function |
	self
		disableExceptions;
		evaluateSysmelSource: '
class Mutex definition: { 
	method lock => Void
		:= grabLock().
	method unlock => Void
		:= releaseLock().

    macro method withLock: aBlock := ``{
		`,self lock.
        `,aBlock __macroInlineBlockEnsure: `,self unlock.
    }.
}.

function grabLock externC() => Void.
function sideEffect externC() => Void.
function releaseLock externC() => Void.

function useMutex externC() => Int32 := {
	let mutex mutable type: Mutex.
	mutex withLock: { 
		sideEffect().
		return: 42
	}.
	
	return: 0
}.
';
		generateSSAModule.

	function := ssaModule globalNamed: #useMutex.
	self assert: function isFunction.
	
	self assert: function allInstructionsMnemonics equals: #(
		(entry (alloca jump))
		(body (store jump))
		(tryScope (call jump))
		(tryScope (call jump))
		(tryScope (call return))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testAggregateWithLockNoExceptions [
	| function |
	self
		disableExceptions;
		evaluateSysmelSource: '
class Mutex definition: { 
	method lock => Void
		:= grabLock().
	method unlock => Void
		:= releaseLock().

    macro method withLock: aBlock := ``{
		`,self lock.
        `,aBlock __macroInlineBlockEnsure: `,self unlock.
    }.
}.

function grabLock externC() => Void.
function sideEffect externC() => Void.
function releaseLock externC() => Void.

function useMutex externC() => Void := {
	let mutex mutable type: Mutex.
	mutex withLock: { 
		sideEffect().
	}
}.
';
		generateSSAModule.

	function := ssaModule globalNamed: #useMutex.
	self assert: function isFunction.
	
	self assert: function allInstructionsMnemonics equals: #(
		(entry (alloca jump))
		(body (store jump))
		(tryScope (call jump))
		(tryScope (call jump))
		(tryScope (call returnVoid))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testArraySubscriptAt [
	| function |
	self
		evaluateSysmelSource: '
global theArray mutable type: (Int32 array: 32).

function f externC(x: Int32) => Int32 ref
	:= theArray[x].';
		generateSSAModule.

	function := ssaModule globalNamed: #f.
	self assert: function asFullSExpressionForTesting equals: #(
function f cdecl (pointer i32 generic) arguments ((x i32 ()))
    literals ()
    blocks
    (
        (()
            (nil jump void () () (block 2 body))
        )
        (()
            (nil sext i64 () ((local 0 x)))
            (nil getElementPointer (pointer i32 generic) () ((global 0 _ZN10TestModule8theArrayE) (const i32 0) (local 2 nil)))
            (nil return void () ((local 3 nil))))
    )
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testAssociationExtractKeyElement [
	| function |
	self
		evaluateSysmelSource: '
function assocElement externC(assoc: (Int32 -->Float32)) => Int32
	:= assoc key.

';
		generateSSAModule.

	function := ssaModule globalNamed: #assocElement.
	self assert: function asFullSExpressionForTesting equals: #(
function assocElement cdecl i32
arguments ((assoc (struct 'special.(Int32 --> Float32)') ()))
literals ()
blocks (
    (()
        (nil jump void () () (block 2 body))
    )
    (()
        (nil extractValue i32 () ((local 0 assoc)) (0))
        (nil return void () ((local 2 nil)))
    )
)
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testAtomicBooleanFlagLoad [
	| function |
	self
		evaluateSysmelSource: '
class AtomicFlag definition: { 
	field flag private type: Boolean8.
	
	method loadWith: (ordering: Int32) ::=> Boolean8 := {
        <staticBinding>
        <intrinsic: #"atomic.load">
        flag
    }.
}.

';
		generateSSAModule.

	function := ssaModule globalNamed: #'_ZN10TestModule10AtomicFlag10.loadWith.ERNS0_Ei'.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 1.
	
	self assert: function allInstructionsMnemonics equals: #(
		(intrinsic (getElementPointer call return))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testBooleanAllSet [
	| function |
	self
		evaluateMiniObjectModelRuntime;
		evaluateSysmelSource: 'function op externC(x: Boolean8) => Boolean8 := x isAllSet';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function asFullSExpressionForTesting equals: #(
	function op cdecl b8
    arguments ((x b8 ()))
    literals ()
    blocks (
        (()
            (nil jump void () () (block 2 body))
        )
        (()
            (nil return void () ((local 0 x)))
        )
    )
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testBooleanAnySet [
	| function |
	self
		evaluateMiniObjectModelRuntime;
		evaluateSysmelSource: 'function op externC(x: Boolean8) => Boolean8 := x isAnySet';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function asFullSExpressionForTesting equals: #(
	function op cdecl b8
    arguments ((x b8 ()))
    literals ()
    blocks (
        (()
            (nil jump void () () (block 2 body))
        )
        (()
            (nil return void () ((local 0 x)))
        )
    )
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testBooleanEquality [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Boolean8, y: Boolean8) => Boolean8 := x = y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ieq.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testBooleanEquality2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Boolean8, y: Boolean8) => Boolean8 := x == y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ieq.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testBooleanGreater [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Boolean8, y: Boolean8) => Boolean8 := x > y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ugt.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testBooleanGreaterOrEqual [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Boolean8, y: Boolean8) => Boolean8 := x >= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #uge.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testBooleanLess [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Boolean8, y: Boolean8) => Boolean8 := x < y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ult.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testBooleanLessOrEqual [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Boolean8, y: Boolean8) => Boolean8 := x <= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ule.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testBooleanLoadFromRef [
	| function |
	self
		evaluateSysmelSource: '
		function loadBoolFromRef externC(v: Boolean8 ref) => Boolean8 := v';
		generateSSAModule.

	function := ssaModule globalNamed: #loadBoolFromRef.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (
			load
			truncate
			return))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testBooleanLoadStructure [
	| function |
	self
		evaluateSysmelSource: '
struct TestStruct definition: {
	public field b type: Boolean8.
}.

		function getField externC(s: TestStruct ref) => Boolean8 := s b';
		generateSSAModule.

	function := ssaModule globalNamed: #getField.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (
			getElementPointer
			load
			truncate
			return))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testBooleanLoadStructure2 [
	| function |
	self
		evaluateSysmelSource: '
struct TestStruct definition: {
	public field b type: Boolean8.
}.

		function getField externC(s: TestStruct) => Boolean8 := s b';
		generateSSAModule.

	function := ssaModule globalNamed: #getField.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (
			extractValue
			truncate
			return))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testBooleanLocal [
	| function |
	self
		evaluateSysmelSource: '
		function boolLocal externC() => Boolean8 := {
			let v mutable := true.
			v
		}.';
		generateSSAModule.

	function := ssaModule globalNamed: #boolLocal.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (alloca jump))
		(body (jump))
		(tryScope (
			store
			load
			truncate
			return))
	).
	
	self assert: function basicBlocks third firstInstruction value type isIntegerType.

]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testBooleanNot [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Boolean8) => Boolean8 := !x';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isUnaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #lnot.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testBooleanNot2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Boolean8) => Boolean8 := x not';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isUnaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #lnot.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testBooleanNotEquality [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Boolean8, y: Boolean8) => Boolean8 := x ~= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ine.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testBooleanNotEquality2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Boolean8, y: Boolean8) => Boolean8 := x ~~ y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ine.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testBooleanThreeWayComparison [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Boolean8, y: Boolean8) => Int32 := x <=> y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function asFullSExpressionForTesting equals: #(
    function op cdecl i32
        arguments ((x b8 ()) (y b8 ()))
        literals ()
        blocks
        (
            (()
                (nil jump void () () (block 2 body))
            )
            (()
                (nil zext i32 () ((local 0 x)))
                (nil zext i32 () ((local 1 y)))
                (nil sub i32 () ((local 3 nil) (local 4 nil)))
                (nil return void () ((local 5 nil)))
            )
        )
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testBooleanToDynamicObject [
	| function |
	self
		evaluateMiniObjectModelRuntime;
		evaluateSysmelSource: 'function cast externC(x: Boolean8) => ProtoObject := x';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBoolToDynamicObjectCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testBooleanToInt32 [
	| function |
	self
		evaluateMiniObjectModelRuntime;
		evaluateSysmelSource: 'function cast externC(x: Boolean8) => Int32 := x castTo: Int32';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isZeroExtend.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testBooleanVectorIsAllSet [
	| function |
	self
		evaluateMiniObjectModelRuntime;
		evaluateSysmelSource: 'function op externC(x: Boolean8x4) => Boolean8 := x isAllSet';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function asFullSExpressionForTesting equals: #(
	function op cdecl b8
    arguments ((x (vector b8 4) ()))
    literals ()
    blocks (
        (()
            (nil jump void () () (block 2 body))
        )
        (()
            (nil call b8 () ((builtInFunction (pointer (function cdecl ((vector b8 4)) false b8) generic) 'vector.all') (local 0 x)))
            (nil return void () ((local 2 nil)))
        )
    )
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testBooleanVectorIsAnySet [
	| function |
	self
		evaluateMiniObjectModelRuntime;
		evaluateSysmelSource: 'function op externC(x: Boolean8x4) => Boolean8 := x isAnySet';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function asFullSExpressionForTesting equals: #(
	function op cdecl b8
    arguments ((x (vector b8 4) ()))
    literals ()
    blocks (
        (()
            (nil jump void () () (block 2 body))
        )
        (()
            (nil call b8 () ((builtInFunction (pointer (function cdecl ((vector b8 4)) false b8) generic) 'vector.any') (local 0 x)))
            (nil return void () ((local 2 nil)))
        )
    )
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testCStringCFunction [
	| function |
	self
		evaluateSysmelSource: 'function cstringFunction externC() => UInt8 const pointer := "Hello World\n"';
		generateSSAModule.

	function := ssaModule globalNamed: #cstringFunction.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks first firstInstruction isJump.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testCallWithGCBlockClosure [
	| function |
	self
		evaluateMiniObjectModelRuntime;
		evaluateSysmelSource: '
function calledWithGCBlockClosure externC(f: (Void => ProtoObject) gcBlockClosure) => ProtoObject
	:= f().

function callWithGCBlockClosure externC(v: ProtoObject) => ProtoObject
	:= calledWithGCBlockClosure(function () => ProtoObject := v).
';
		generateSSAModule.

	function := ssaModule globalNamed: #calledWithGCBlockClosure.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (
			getElementPointer
			load
			bitcast
			call
			return
		))
	).
	
	function := ssaModule globalNamed: #callWithGCBlockClosure.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (
			instantiateClosure
			bitcast 
			call
			return
		))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testCallWithGCBlockClosure2 [
	| function |
	self
		evaluateMiniObjectModelRuntime;
		evaluateSysmelSource: '
function calledWithGCBlockClosure externC(f: (Void => ProtoObject) gcBlockClosure) => ProtoObject
	:= f().

function callWithGCBlockClosure externC(v: ProtoObject) => ProtoObject
	:= calledWithGCBlockClosure({ :: ProtoObject | v }).
';
		generateSSAModule.

	function := ssaModule globalNamed: #calledWithGCBlockClosure.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (
			getElementPointer
			load
			bitcast
			call
			return
		))
	).
	
	function := ssaModule globalNamed: #callWithGCBlockClosure.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (
			instantiateClosure
			bitcast 
			call
			return
		))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testCallWithNativeBlockClosure [
	| function |
	self
		evaluateSysmelSource: '
function calledWithNativeBlockClosure externC(f: (Void => Int32) nativeStackBlockClosure) => Int32
	:= f().

function callWithNativeBlockClosure externC(v: Int32) => Int32
	:= calledWithNativeBlockClosure(function () => Int32 := v).
';
		generateSSAModule.

	function := ssaModule globalNamed: #calledWithNativeBlockClosure.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (
			getElementPointer
			load
			bitcast
			call
			return
		))
	).
	
	function := ssaModule globalNamed: #callWithNativeBlockClosure.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (
			instantiateClosure
			bitcast 
			call
			return
		))
	).

]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testCallWithNativeBlockClosure2 [
	| function |
	self
		evaluateSysmelSource: '
function calledWithNativeBlockClosure externC(f: (Void => Int32) nativeStackBlockClosure) => Int32
	:= f().

function callWithNativeBlockClosure externC(v: Int32) => Int32
	:= calledWithNativeBlockClosure({ :: Int32 | v }).
';
		generateSSAModule.

	function := ssaModule globalNamed: #calledWithNativeBlockClosure.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (
			getElementPointer
			load
			bitcast
			call
			return
		))

	).
	
	function := ssaModule globalNamed: #callWithNativeBlockClosure.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (
			instantiateClosure
			bitcast 
			call
			return
		))
	).

]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testCallWithNativeBlockClosureWithNonLocalReturn [
	| function closure |
	self
		evaluateMiniRTTI;
		evaluateMiniExceptionRuntime;
		evaluateSysmelSource: '
function calledWithNativeBlockClosure externC(f: (Void => Int32) nativeStackBlockClosure) => Int32
	:= f() * 10.

function callWithNativeBlockClosure externC(v: Int32) => Int32
	:= calledWithNativeBlockClosure({ :: Int32 | return: 42 }).
';
		generateSSAModule.

	function := ssaModule globalNamed: #calledWithNativeBlockClosure.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (getElementPointer load bitcast call mul return
		))

	).
	
	function := ssaModule globalNamed: #callWithNativeBlockClosure.
	self assert: function allInstructionsMnemonics equals: #(
		#(#entry #(#alloca #alloca #alloca #jump))
		#(#body #(#getThisContext #jump))
		#(#tryScope #(#instantiateClosure #bitcast #call #return))
		#(#tryUnwind #(#landingpath #extractValue #store #extractValue #store #jump))
		#(#unwindCleanUp #(#load #getExceptionSelectorFromTypeInfo #ieq #branch))
		#(#nonLocalReturn #(#load #call #load #return))
		#(#unwindResume #(#load #insertValue #load #insertValue #resumeException))
	).

	closure := function basicBlocks third firstInstruction definition.
	self assert: closure allInstructionsMnemonics equals: #(
		#(#entry #(#jump))
		#(#body #(#store #call unreachable))
	).

]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testCatchNativeExceptionIgnore [
	| function |
	self
		evaluateMiniRTTI;
		evaluateMiniExceptionRuntime;
		evaluateSysmelSource: '

function mayThrow externC() => Void.
function catchSideEffect externC() => Void.

function withCatch externC() => Void := { 
	try: { 
		mayThrow()
	} catch: Error doing: { 
		catchSideEffect()
	}
}
';
		generateSSAModule.

	function := ssaModule globalNamed: #withCatch.
	self assert: function isFunction.
	self assert: function allInstructionsMnemonics equals: #(
		(entry #(#alloca #alloca #jump))
		(body #(#jump))
		(tryScope #(#jump))
		(catchAction #(#load #call #jump))
		(tryScope #(#jump))
		(normalCleanUpBlock #(#returnVoid))
		(tryUnwind #(#landingpath #extractValue #store #extractValue #store #jump))
		(tryScope #(#call #jump))
		(catchNormalCleanUp #(#call #jump))
		(catchUnwind #(#landingpath #extractValue #store #extractValue #store #jump))
		(tryScope #(#call #jump))
		(unwindCleanUp #(#load #insertValue #load #insertValue #resumeException))
		(forbiddenExceptionTarget #(#landingpath #extractValue #call #unreachable))
		(unwindCatchSelection #(#load #getExceptionSelectorFromTypeInfo #ieq #branch))
		(unwindCleanUp #(#jump))
		(catchSelectContinue #(#jump))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testCatchNativeNestedException [
	| function |
	
"Try inside of try gets merged."
	self
		evaluateMiniRTTI;
		evaluateMiniExceptionRuntime;
		evaluateSysmelSource: '
function mayThrow externC() => Void.
function mayThrow2 externC() => Void.
function catchSideEffect externC() => Void.

function withCatch externC() => Void := { 
	try: { 
		try: { 
			mayThrow()
		} catch: AssertionFailure doing: { 
			catchSideEffect()
		}.
		mayThrow2()
	} catch: Error doing: { 
		catchSideEffect()
	}
}
';
		generateSSAModule.

	function := ssaModule globalNamed: #withCatch.
	self assert: function isFunction.
	self flag: 'TODO: Double check that this generated code is correct.'.
	self assert: function allInstructionsMnemonics equals: #(
		#(#entry #(#alloca #alloca #jump))
		#(#body #(#jump))
		#(#tryScope #(#jump))
		#(#catchAction #(#load #call #jump))
		#(#tryScope #(#jump))
		#(#normalCleanUpBlock #(#returnVoid))
		#(#tryUnwind #(#landingpath #extractValue #store #extractValue #store #jump))
		#(#tryScope #(#jump))
		#(#catchAction #(#load #call #jump))
		#(#tryScope #(#jump))
		#(#normalCleanUpBlock #(#call #jump))
		#(#tryUnwind #(#landingpath #extractValue #store #extractValue #store #jump))
		#(#tryScope #(#call #jump))
		#(#catchNormalCleanUp #(#call #jump))
		#(#catchUnwind #(#landingpath #extractValue #store #extractValue #store #jump))
		#(#tryScope #(#call #jump))
		#(#catchNormalCleanUp #(#call #jump))
		#(#catchUnwind #(#landingpath #extractValue #store #extractValue #store #jump))
		#(#tryScope #(#call #jump))
		#(#unwindCleanUp #(#load #insertValue #load #insertValue #resumeException))
		#(#forbiddenExceptionTarget #(#landingpath #extractValue #call #unreachable))
		#(#unwindCatchSelection #(#load #getExceptionSelectorFromTypeInfo #ieq #branch))
		#(#unwindCleanUp #(#jump))
		#(#unwindCatchSelection #(#load #getExceptionSelectorFromTypeInfo #ieq #branch))
		#(#unwindCleanUp #(#jump))
		#(#unwindCleanUp #(#jump))
		#(#catchSelectContinue #(#jump))
		#(#catchSelectContinue #(#jump))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testCharacterToDynamicObject [
	| function |
	self
		evaluateMiniObjectModelRuntime;
		evaluateSysmelSource: 'function cast externC(x: Char32) => ProtoObject := x';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isCharToDynamicObjectCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testClassConstPointerUpcast [
	| function |
	self
		evaluateSysmelSource: '
class SuperClass definition: { 
	field int32Field type: Int32.
}.

class SubClass superclass: SuperClass; definition: { 
	field float32Field type: Float32.
}.

function upcast externC(x: SubClass pointer) => SuperClass const pointer := x
';
		generateSSAModule.

	function := ssaModule globalNamed: #upcast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks first firstInstruction isJump.
	self assert: function basicBlocks second firstInstruction isBitCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testClassGetSuperclassField [
	| function |
	self
		evaluateSysmelSource: '
class SuperClass definition: { 
	field int32Field type: Int32.
}.

class SubClass superclass: SuperClass; definition: { 
	field float32Field type: Float32.
	
	method getField => Int32 := int32Field.
}.

';
		generateSSAModule.

	function := ssaModule globalNamed: #'_ZN10TestModule8SubClass9.getFieldERNS0_E'.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks first firstInstruction isJump.
	self assert: function basicBlocks second firstInstruction isGetElementPointer.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testClassGetSuperclassField2 [
	| function |
	self
		evaluateSysmelSource: '
class SuperClass definition: { 
	field int32Field type: Int32.
}.

class SubClass superclass: SuperClass; definition: { 
	field float32Field type: Float32.
	
	function getField externC() => Int32 := int32Field.
}.

';
		generateSSAModule.

	function := ssaModule globalNamed: #getField.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks first firstInstruction isJump.
	self assert: function basicBlocks second firstInstruction isGetElementPointer.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testClassPointerUpcast [
	| function |
	self
		evaluateSysmelSource: '
class SuperClass definition: { 
	field int32Field type: Int32.
}.

class SubClass superclass: SuperClass; definition: { 
	field float32Field type: Float32.
}.

function upcast externC(x: SubClass pointer) => SuperClass pointer := x
';
		generateSSAModule.

	function := ssaModule globalNamed: #upcast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks first firstInstruction isJump.
	self assert: function basicBlocks second firstInstruction isBitCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testClassVirtualAbstractMessageSend [
	| function |
	self
		evaluateSysmelSource: '
class SuperClass definition: { 
	field int32Field type: Int32.
	
	abstract method getValue => Float64.
}.

function callVirtual externC(o: SuperClass ref) => Float64
	:= o getValue.
';
		generateSSAModule.

	function := ssaModule globalNamed: #callVirtual.
	self assert: function asFullSExpressionForTesting equals: #(
	function callVirtual cdecl f64
    arguments ((o (pointer (struct 'class.TestModule::SuperClass') generic) ()))
    literals ()
    blocks (
        (()
            (nil jump void () () (block 2 body))
        )
        (()
            (nil getElementPointer (pointer (pointer (pointer void generic) generic) generic) () ((local 0 o) (const i32 0) (const i32 0)))
            (nil load (pointer (pointer void generic) generic) () ((local 2 nil)))
            (nil getElementPointer (pointer (pointer void generic) generic) () ((local 3 nil) (const i32 0)))
            (nil load (pointer void generic) () ((local 4 nil)))
            (nil bitcast (pointer (function cdecl ((pointer (struct 'class.TestModule::SuperClass') generic)) false f64) generic) () ((local 5 nil)))
            (nil call f64 () ((local 6 nil) (local 0 o)))
            (nil return void () ((local 7 nil)))
        )
    )
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testClassVirtualMessageSend [
	| function |
	self
		evaluateSysmelSource: '
class SuperClass definition: { 
	field int32Field type: Int32.
	
	virtual method getValue => Float64
		:= int32Field.
}.

function callVirtual externC(o: SuperClass ref) => Float64
	:= o getValue.
';
		generateSSAModule.

	function := ssaModule globalNamed: #callVirtual.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (
			getElementPointer
			load
			getElementPointer
			load
			bitcast
			call
			return
		))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testClassVirtualMessageSuperSend [
	| function |
	self
		evaluateSysmelSource: '
class SuperClass definition: { 
	field int32Field type: Int32.
	
	virtual method getValue => Float64
		:= int32Field.
}.

class SubClass superclass: SuperClass; definition: { 
	field float32Field type: Float32.
	
	override method getValue => Float64
		:= super getValue + float32Field.
}.

function callVirtual externC(o: SuperClass ref) => Float64
	:= o getValue.
';
		generateSSAModule.

	function := ssaModule globalNamed: #callVirtual.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (
			getElementPointer
			load
			getElementPointer
			load
			bitcast
			call
			return
		))
	).
	
	function := ssaModule globalNamed: #'_ZN10TestModule8SubClass9.getValueERNS0_E'.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (
			bitcast
			call
			getElementPointer
			load
			fpcast
			fadd
			return
		))
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testCountTwiceCFunction [
	| function |
	self
		evaluateSysmelSource: 'function countTwice externC(destCount: Int32) => Int32 := { 
			let i mutable := 0.
			let count mutable := 0.
			while: (i < destCount) do: { 
				count := count + 2
			} continueWith: (i := i + 1).

			count
		}';
		generateSSAModule.

	function := ssaModule globalNamed: #countTwice.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (alloca alloca jump))
		(body (jump))
		(tryScope (store store jump))
		(whileHeader (load ilt branch))
		(whileBody (jump))
		(whileContinue (load add store jump))
		(whileMerge (load return))
		(tryScope (load add store jump))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testDestructuringAssignment [
	| function |
	self
		evaluateSysmelSource: '
function tupleShuffle externC(tuple: (Int32 -- Int32)) => (Int32 -- Int32) := {
	let (let a, let b) := tuple.
	(b, a)
}';
		generateSSAModule.

	function := ssaModule globalNamed: #tupleShuffle.
	self assert: function asFullSExpressionForTesting equals: #(
function tupleShuffle cdecl (struct nil generic (i32 i32) (element0 element1) ())
    arguments ((tuple (struct nil generic (i32 i32) (element0 element1) ()) ()))
    literals ()
    blocks (
        (()
            (nil jump void () () (block 2 body))
        )
        (()
            (nil jump void () () (block 3 tryScope))
        )
        (()
            (nil extractValue i32 () ((local 0 tuple)) (0))
            (nil extractValue i32 () ((local 0 tuple)) (1))
            (nil insertValue (struct nil generic (i32 i32) (element0 element1) ()) () ((undef (struct nil generic (i32 i32) (element0 element1) ())) (local 4 nil)) (0))
            (nil insertValue (struct nil generic (i32 i32) (element0 element1) ()) () ((local 5 nil) (local 3 nil)) (1))
            (nil return void () ((local 6 nil)))
        )
    )
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testDestructuringAssignment2 [
	| function |
	self
		evaluateSysmelSource: '
function tupleFirst externC(tuple: (Int32 -- Int32)) => Int32 := {
	let (let a, _) := tuple.
	a
}';
		generateSSAModule.

	function := ssaModule globalNamed: #tupleFirst.
	self assert: function asFullSExpressionForTesting equals: #(
function tupleFirst cdecl i32
    arguments ((tuple (struct nil generic (i32 i32) (element0 element1) ()) ()))
    literals ()
    blocks (
        (()
            (nil jump void () () (block 2 body))
        )
        (()
            (nil jump void () () (block 3 tryScope))
        )
        (()
            (nil extractValue i32 () ((local 0 tuple)) (0))
            (nil extractValue i32 () ((local 0 tuple)) (1))
            (nil return void () ((local 3 nil)))
        )
    )
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testDestructuringAssignment3 [
	| function |
	self
		evaluateSysmelSource: '
function tupleShuffle externC(tuple: (Int32 -- Int32) const ref) => (Int32 -- Int32) := {
	let (let a, let b) := tuple.
	(b, a)
}';
		generateSSAModule.

	function := ssaModule globalNamed: #tupleShuffle.
	self assert: function asFullSExpressionForTesting equals: #(
function tupleShuffle cdecl (struct nil generic (i32 i32) (element0 element1) ())
    arguments ((tuple (pointer (struct nil generic (i32 i32) (element0 element1) ()) generic) ()))
    literals ()
    blocks (
        (()
            (nil jump void () () (block 2 body))
        )
        (()
            (nil jump void () () (block 3 tryScope))
        )
        (()
            (nil getElementPointer (pointer i32 generic) () ((local 0 tuple) (const i32 0) (const i32 0)))
            (nil getElementPointer (pointer i32 generic) () ((local 0 tuple) (const i32 0) (const i32 1)))
            (nil insertValue (struct nil generic ((pointer i32 generic) (pointer i32 generic)) (element0 element1) ()) () ((undef (struct nil generic ((pointer i32 generic) (pointer i32 generic)) (element0 element1) ())) (local 4 nil)) (0))
            (nil insertValue (struct nil generic ((pointer i32 generic) (pointer i32 generic)) (element0 element1) ()) () ((local 5 nil) (local 3 nil)) (1))
            (nil extractValue (pointer i32 generic) () ((local 6 nil)) (0))
            (nil load i32 () ((local 7 nil)))
            (nil extractValue (pointer i32 generic) () ((local 6 nil)) (1))
            (nil load i32 () ((local 9 nil)))
            (nil insertValue (struct nil generic (i32 i32) (element0 element1) ()) () ((undef (struct nil generic (i32 i32) (element0 element1) ())) (local 8 nil)) (0))
            (nil insertValue (struct nil generic (i32 i32) (element0 element1) ()) () ((local 11 nil) (local 10 nil)) (1))
            (nil return void () ((local 12 nil)))
        )
    )
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testDestructuringAssignment4 [
	| function |
	self
		evaluateSysmelSource: '
function tupleFirst externC(tuple: (Int32 -- Int32) const ref) => Int32 := {
	let (let a, _) := tuple.
	a
}';
		generateSSAModule.

	function := ssaModule globalNamed: #tupleFirst.
	self assert: function asFullSExpressionForTesting equals: #(
function tupleFirst cdecl i32
    arguments ((tuple (pointer (struct nil generic (i32 i32) (element0 element1) ()) generic) ()))
    literals ()
    blocks (
        (()
            (nil jump void () () (block 2 body))
        )
        (()
            (nil jump void () () (block 3 tryScope))
        )
        (()
            (nil getElementPointer (pointer i32 generic) () ((local 0 tuple) (const i32 0) (const i32 0)))
            (nil getElementPointer (pointer i32 generic) () ((local 0 tuple) (const i32 0) (const i32 1)))
            (nil load i32 () ((local 3 nil)))
            (nil return void () ((local 5 nil)))
        )
    )
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testDestructuringAssignment5 [
	| function |
	self
		evaluateSysmelSource: '
function tupleFirst externC(tuple: (Int32 -- Int32)) => Int32 := {
	let (let a, 42) := tuple.
	a
}';
		generateSSAModule.

	function := ssaModule globalNamed: #tupleFirst.
	self assert: function asFullSExpressionForTesting equals: #(
function tupleFirst cdecl i32
    arguments ((tuple (struct nil generic (i32 i32) (element0 element1) ()) ()))
    literals ()
    blocks (
        (()
            (nil jump void () () (block 2 body))
        )
        (()
            (nil jump void () () (block 3 tryScope))
        )
        ((merge (block 5 patternMatchingSuccess))
            (nil extractValue i32 () ((local 0 tuple)) (0))
            (nil extractValue i32 () ((local 0 tuple)) (1))
            (nil ieq b8 () ((local 4 nil) (const i32 42)))
            (nil branch void () ((local 5 nil)) ((block 5 patternMatchingSuccess) (block 4 patternMatchingFailureTrap)))
        )
        (()
            (nil call void () ((global 1 __sysmel_patternMatchingFailureRaise)))
            (nil unreachable void () ())
        )
        (()
            (nil return void () ((local 3 nil)))
        )
    )
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testDestructuringAssignment6 [
	| function |
	self
		evaluateSysmelSource: '
function tupleFirst externC(tuple: (Int32 -- Int32)) => Int32 := {
	let (42, let a) := tuple.
	a
}';
		generateSSAModule.

	function := ssaModule globalNamed: #tupleFirst.
	self assert: function asFullSExpressionForTesting equals: #(
function tupleFirst cdecl i32
    arguments ((tuple (struct nil generic (i32 i32) (element0 element1) ()) ()))
    literals ()
    blocks (
        (()
            (nil jump void () () (block 2 body))
        )
        (()
            (nil jump void () () (block 3 tryScope))
        )
        ((merge (block 5 patternFailure))
            (nil extractValue i32 () ((local 0 tuple)) (0))
            (nil ieq b8 () ((local 3 nil) (const i32 42)))
            (nil branch void () ((local 4 nil)) ((block 4 patternNextCheck) (block 5 patternFailure)))
        )
        (()
            (nil extractValue i32 () ((local 0 tuple)) (1))
            (nil jump void () () (block 5 patternFailure))
        )
        ((merge (block 7 patternMatchingSuccess))
            (nil phi b8 () ((local 4 nil) (const b8 true)) ((block 3 tryScope) (block 4 patternNextCheck)))
            (nil branch void () ((local 8 nil)) ((block 7 patternMatchingSuccess) (block 6 patternMatchingFailureTrap)))
        )
        (()
            (nil call void () ((global 1 __sysmel_patternMatchingFailureRaise)))
            (nil unreachable void () ())
        )
        (()
            (nil return void () ((local 6 nil)))
        )
    )
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testDestructuringAssignment7 [
	| function |
	self
		evaluateSysmelSource: '
function tupleFirst externC(tuple: (Int32 -- Int32) const ref) => Int32 := {
	let (let a, 42) := tuple.
	a
}';
		generateSSAModule.

	function := ssaModule globalNamed: #tupleFirst.
	self assert: function asFullSExpressionForTesting equals: #(
function tupleFirst cdecl i32
    arguments ((tuple (pointer (struct nil generic (i32 i32) (element0 element1) ()) generic) ()))
    literals ()
    blocks (
        (()
            (nil jump void () () (block 2 body))
        )
        (()
            (nil jump void () () (block 3 tryScope))
        )
        ((merge (block 5 patternMatchingSuccess))
            (nil getElementPointer (pointer i32 generic) () ((local 0 tuple) (const i32 0) (const i32 0)))
            (nil getElementPointer (pointer i32 generic) () ((local 0 tuple) (const i32 0) (const i32 1)))
            (nil load i32 () ((local 4 nil)))
            (nil ieq b8 () ((local 5 nil) (const i32 42)))
            (nil branch void () ((local 6 nil)) ((block 5 patternMatchingSuccess) (block 4 patternMatchingFailureTrap)))
        )
        (()
            (nil call void () ((global 1 __sysmel_patternMatchingFailureRaise)))
            (nil unreachable void () ())
        )
        (()
            (nil load i32 () ((local 3 nil)))
            (nil return void () ((local 10 nil)))
        )
    )
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testDestructuringAssignment8 [
	| function |
	self
		evaluateSysmelSource: '
function tupleFirst externC(tuple: (Int32 -- Int32) const ref) => Int32 := {
	let (42, let a) := tuple.
	a
}';
		generateSSAModule.

	function := ssaModule globalNamed: #tupleFirst.
	self assert: function asFullSExpressionForTesting equals: #(
function tupleFirst cdecl i32
    arguments ((tuple (pointer (struct nil generic (i32 i32) (element0 element1) ()) generic) ()))
    literals ()
    blocks (
        (()
            (nil jump void () () (block 2 body))
        )
        (()
            (nil jump void () () (block 3 tryScope))
        )
        ((merge (block 5 patternFailure))
            (nil getElementPointer (pointer i32 generic) () ((local 0 tuple) (const i32 0) (const i32 0)))
            (nil load i32 () ((local 3 nil)))
            (nil ieq b8 () ((local 4 nil) (const i32 42)))
            (nil branch void () ((local 5 nil)) ((block 4 patternNextCheck) (block 5 patternFailure)))
        )
        (()
            (nil getElementPointer (pointer i32 generic) () ((local 0 tuple) (const i32 0) (const i32 1)))
            (nil jump void () () (block 5 patternFailure))
        )
        ((merge (block 7 patternMatchingSuccess))
            (nil phi b8 () ((local 5 nil) (const b8 true)) ((block 3 tryScope) (block 4 patternNextCheck)))
            (nil branch void () ((local 9 nil)) ((block 7 patternMatchingSuccess) (block 6 patternMatchingFailureTrap)))
        )
        (()
            (nil call void () ((global 1 __sysmel_patternMatchingFailureRaise)))
            (nil unreachable void () ())
        )
        (()
            (nil load i32 () ((local 7 nil)))
            (nil return void () ((local 13 nil)))
        )
    )
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testDynamicObjectToBoolean [
	| function |
	self
		evaluateMiniObjectModelRuntime;
		evaluateSysmelSource: 'function cast externC(x: ProtoObject) => Boolean8 := x castTo: Boolean8';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isDynamicObjectToBoolCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testDynamicObjectToCharacter [
	| function |
	self
		evaluateMiniObjectModelRuntime;
		evaluateSysmelSource: 'function cast externC(x: ProtoObject) => Char32 := x castTo: Char32';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isDynamicObjectToCharCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testDynamicObjectToFloat [
	| function |
	self
		evaluateMiniObjectModelRuntime;
		evaluateSysmelSource: 'function cast externC(x: ProtoObject) => Float32 := x castTo: Float32';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isDynamicObjectToFloatCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testDynamicObjectToInteger [
	| function |
	self
		evaluateMiniObjectModelRuntime;
		evaluateSysmelSource: 'function cast externC(x: ProtoObject) => Int32 := x castTo: Int32';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isDynamicObjectToIntCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testEmbeddedShaderGeneration [
	self
		evaluateShaderMetadata;
		evaluateSysmelSource: 'class SampleShader definition: { 
	function v vertexShader() => Void := {
	}.
}.';
		generateSSAModule.
		
	self flag: 'TODO: Add tests for the shader module generation.'
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testEmptyModule [
	self generateSSAModule.
	
	self assert: ssaModule globalValues isEmpty.

]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testEnumSelectCase [
	| function |
	self
		evaluateSysmelSource: '
enum TestEnum values: #{
	First: 1.
	Second: 2.
}.

		function selectCaseTest externC(value: TestEnum) => Float32
			:= value selectCase: #{
	TestEnum First : 0.0.
	TestEnum Second : 1.0.
}';
		generateSSAModule.

	function := ssaModule globalNamed: #selectCaseTest.
	self assert: function asFullSExpressionForTesting equals: #(
	function selectCaseTest cdecl f32
		arguments ((value #i32 ()))
	literals ()
	blocks (
    (()
        (nil jump void () () (block 2 body))
    )
    ((merge (block 6 casesOfMerge))
        (nil switch void () ((local 0 value) (const i32 1) (const i32 2)) (((block 3 casesOfCase) (block 4 casesOfCase)) (block 5 casesOfDefault)))
    )
    (()
        (nil jump void () () (block 6 casesOfMerge))
    )
    (()
        (nil jump void () () (block 6 casesOfMerge))
    )
    (()
        (nil call void () ((global 2 __sysmel_patternMatchingFailureRaise)))
        (nil unreachable void () ())
    )
    (()
        (casesResult phi f32 () ((const f32 0.0) (const f32 1.0)) ((block 3 casesOfCase) (block 4 casesOfCase)))
        (nil return void () ((local 7 casesResult)))
    )
	)
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testEnumSelectIntervalCase [
	| function |
	self
		evaluateSysmelSource: '
enum TestEnum values: #{
	First: 1.
	Second: 2.
	Third: 3.
	Fourth: 4.
}.

		function selectCaseTest externC(value: TestEnum) => Float32
			:= value selectCase: #{
	(TestEnum First to: TestEnum Third) : 0.0.
	TestEnum Fourth : 1.0.
}';
		generateSSAModule.

	function := ssaModule globalNamed: #selectCaseTest.
	self assert: function asFullSExpressionForTesting equals: #(
	function selectCaseTest cdecl f32
		arguments ((value #i32 ()))
	literals ()
	blocks 
    (
    (()
        (nil jump void () () (block 2 body))
    )
    ((merge (block 6 casesOfMerge))
        (nil switch void () ((local 0 value) (const i32 1) (const i32 2) (const i32 3) (const i32 4)) (((block 3 casesOfCase) (block 3 casesOfCase) (block 3 casesOfCase) (block 4 casesOfCase)) (block 5 casesOfDefault)))
    )
    (()
        (nil jump void () () (block 6 casesOfMerge))
    )
    (()
        (nil jump void () () (block 6 casesOfMerge))
    )
    (()
        (nil call void () ((global 2 __sysmel_patternMatchingFailureRaise)))
        (nil unreachable void () ())
    )
    (()
        (casesResult phi f32 () ((const f32 0.0) (const f32 1.0)) ((block 3 casesOfCase) (block 4 casesOfCase)))
        (nil return void () ((local 7 casesResult)))
    )
)
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testEnumSelectSetCase [
	| function |
	self
		evaluateSysmelSource: '
enum TestEnum values: #{
	First: 1.
	Second: 2.
	Third: 3.
	Fourth: 4.
}.

		function selectCaseTest externC(value: TestEnum) => Float32
			:= value selectCase: #{
	(TestEnum First, TestEnum Third, TestEnum Fourth) asValueInSetPattern : 0.0.
	TestEnum Second : 1.0.
}';
		generateSSAModule.

	function := ssaModule globalNamed: #selectCaseTest.
	self assert: function asFullSExpressionForTesting equals: #(
	function selectCaseTest cdecl f32
		arguments ((value #i32 ()))
		literals ()
		blocks 
(
    (()
        (nil jump void () () (block 2 body))
    )
    ((merge (block 6 casesOfMerge))
        (nil switch void () ((local 0 value) (const i32 1) (const i32 3) (const i32 4) (const i32 2)) (((block 3 casesOfCase) (block 3 casesOfCase) (block 3 casesOfCase) (block 4 casesOfCase)) (block 5 casesOfDefault)))
    )
    (()
        (nil jump void () () (block 6 casesOfMerge))
    )
    (()
        (nil jump void () () (block 6 casesOfMerge))
    )
    (()
        (nil call void () ((global 2 __sysmel_patternMatchingFailureRaise)))
        (nil unreachable void () ())
    )
    (()
        (casesResult phi f32 () ((const f32 0.0) (const f32 1.0)) ((block 3 casesOfCase) (block 4 casesOfCase)))
        (nil return void () ((local 7 casesResult)))
    )
)
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testEnumSelectSingleCase [
	| function |
	self
		evaluateSysmelSource: '
enum TestEnum values: #{
	First: 1.
	Second: 2.
}.

		function selectCaseTest externC(value: TestEnum) => Float32
			:= value selectCase: #{
	TestEnum First : 42.0.
}';
		generateSSAModule.

	function := ssaModule globalNamed: #selectCaseTest.
	self assert: function asFullSExpressionForTesting equals: #(
	function selectCaseTest cdecl f32
		arguments ((value i32 ()))
		literals ()
		blocks
(
    (()
        (nil jump void () () (block 2 body))
    )
    ((merge (block 5 casesOfMerge))
        (nil switch void () ((local 0 value) (const i32 1)) (((block 3 casesOfCase)) (block 4 casesOfDefault)))
    )
    (()
        (nil jump void () () (block 5 casesOfMerge))
    )
    (()
        (nil call void () ((global 2 __sysmel_patternMatchingFailureRaise)))
        (nil unreachable void () ())
    )
    (()
        (casesResult phi f32 () ((const f32 42.0)) ((block 3 casesOfCase)))
        (nil return void () ((local 6 casesResult)))
    )
)
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testEnumValueAsIntegerCastReturn [
	| function |
	self
		evaluateSysmelSource: '
enum TestEnum values: #{
	First: 1.
	Second: 2.
}.

function returnValue externC() => Int64 := TestEnum First castTo: Int64';
		generateSSAModule.

	function := ssaModule globalNamed: #returnValue.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function functionType returnType isIntegerType.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isSignExtend.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testEnumValueAsIntegerReturn [
	| function |
	self
		evaluateSysmelSource: '
enum TestEnum values: #{
	First: 1.
	Second: 2.
}.

function returnValue externC() => Int32 := TestEnum First value';
		generateSSAModule.

	function := ssaModule globalNamed: #returnValue.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function functionType returnType isIntegerType.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testEnumValueFromValueCast2Return [
	| function |
	self
		evaluateSysmelSource: '
enum TestEnum values: #{
	First: 1.
	Second: 2.
}.

function asEnum externC(value: Int64) => TestEnum := value castTo: TestEnum';
		generateSSAModule.

	function := ssaModule globalNamed: #asEnum.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function functionType returnType isIntegerType.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isTruncate.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testEnumValueFromValueCastReturn [
	| function |
	self
		evaluateSysmelSource: '
enum TestEnum values: #{
	First: 1.
	Second: 2.
}.

function asEnum externC(value: Int32) => TestEnum := value castTo: TestEnum';
		generateSSAModule.

	function := ssaModule globalNamed: #asEnum.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function functionType returnType isIntegerType.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testEnumValueReturn [
	| function |
	self
		evaluateSysmelSource: '
enum TestEnum values: #{
	First: 1.
	Second: 2.
}.

function returnValue externC() => TestEnum := TestEnum First';
		generateSSAModule.

	function := ssaModule globalNamed: #returnValue.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function functionType returnType isIntegerType.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testEnumValueReturn2 [
	| function |
	self
		evaluateSysmelSource: '
enum TestEnum values: #{
	None: .
	First: .
	Second: .
}.

function returnValue externC() => TestEnum := TestEnum First';
		generateSSAModule.

	function := ssaModule globalNamed: #returnValue.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function functionType returnType isIntegerType.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testExtraFieldAlignment [
	| fetchAlignedField structureType |
	self
		evaluateSysmelSource: '
struct StructWithExtraAlignment definition: { 
	public field byte type: Int8.

	public field alignedField
		type: Int8;
		alignment: 16.
	
}.

function fetchAlignedField externC(s: StructWithExtraAlignment ref) => Int8
	:= s alignedField';
		generateSSAModule.

	structureType := ssaModule structureNamed: 'struct.TestModule::StructWithExtraAlignment'.
	self assert: structureType size equals: 32.
	self assert: structureType alignment equals: 16.
	
	fetchAlignedField := ssaModule globalNamed: #fetchAlignedField.
	self assert: fetchAlignedField asFullSExpressionForTesting equals: #(
function fetchAlignedField cdecl i8
    arguments ((s (pointer (struct 'struct.TestModule::StructWithExtraAlignment') generic) ()))
    literals ()
    blocks (
        (()
            (nil jump void () () (block 2 body))
        )
        (()
            (nil getElementPointer (pointer i8 generic) () ((local 0 s) (const i32 0) (const i32 2)))
            (nil load i8 () ((local 2 nil)))
            (nil return void () ((local 3 nil)))
        )
    )
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatAdd [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32) => Float32 := x + 1.0';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #fadd.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatDivide [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32) => Float32 := x / 3.0';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #fdiv.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatEquality [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32, y: Float32) => Boolean8 := x = y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ufeq.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatEquality2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32, y: Float32) => Boolean8 := x == y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ufeq.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatGreater [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32, y: Float32) => Boolean8 := x > y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ufgt.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatGreaterOrEqual [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32, y: Float32) => Boolean8 := x >= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ufge.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatLess [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32, y: Float32) => Boolean8 := x < y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #uflt.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatLessOrEqual [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32, y: Float32) => Boolean8 := x <= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ufle.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixAdd [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4x4, y: Float32x4x4) => Float32x4x4 := x + y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #fadd.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixColumnMajorIndices [
	| function |
	self
		evaluateSysmelSource: 'function makeMatrix externC() => Float32x4x4
			:= Float32x4x4 columnMajorIndices';
		generateSSAModule.

	function := ssaModule globalNamed: #makeMatrix.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
	self assert: function basicBlocks second firstInstruction value asFloatArray asArray equals: #(
		0.0 4.0 8.0 12.0
		1.0 5.0 9.0 13.0
		2.0 6.0 10.0 14.0
		3.0 7.0 11.0 15.0
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixConstructWithColumns [
	| function |
	self
		evaluateSysmelSource: 'function makeMatrix externC(
			firstColumn: Float32x4, secondColumn: Float32x4, thirdColumn: Float32x4, fourthColumn: Float32x4) => Float32x4x4
			:= Float32x4x4(firstColumn, secondColumn, thirdColumn, fourthColumn)';
		generateSSAModule.

	function := ssaModule globalNamed: #makeMatrix.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isMakeMatrix.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixElementwiseDivision [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4x4, y: Float32x4x4) => Float32x4x4 := x %/ y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #fdiv.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixElementwiseProduct [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4x4, y: Float32x4x4) => Float32x4x4 := x %* y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #fmul.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixGetFirstColumn [
	| function |
	self
		evaluateSysmelSource: 'function getMatrixColumn externC(vector: Float32x4x4) => Float32x4
			:= vector firstColumn';
		generateSSAModule.

	function := ssaModule globalNamed: #getMatrixColumn.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isExtractValue.
	self assert: function basicBlocks second firstInstruction indices value equals: #(0).
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixGetFirstRow [
	| function |
	self
		evaluateSysmelSource: 'function getMatrixColumn externC(vector: Float32x4x4) => Float32x4
			:= vector firstRow';
		generateSSAModule.

	function := ssaModule globalNamed: #getMatrixColumn.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (
			extractValue
			extractValue
			extractValue
			extractValue
			shuffleVectors
			shuffleVectors
			makeVector
			return
		))
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixGetFourthColumn [
	| function |
	self
		evaluateSysmelSource: 'function getMatrixColumn externC(vector: Float32x4x4) => Float32x4
			:= vector fourthColumn';
		generateSSAModule.

	function := ssaModule globalNamed: #getMatrixColumn.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isExtractValue.
	self assert: function basicBlocks second firstInstruction indices value equals: #(3).
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixGetSecondColumn [
	| function |
	self
		evaluateSysmelSource: 'function getMatrixColumn externC(vector: Float32x4x4) => Float32x4
			:= vector secondColumn';
		generateSSAModule.

	function := ssaModule globalNamed: #getMatrixColumn.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isExtractValue.
	self assert: function basicBlocks second firstInstruction indices value equals: #(1).
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixGetThirdColumn [
	| function |
	self
		evaluateSysmelSource: 'function getMatrixColumn externC(vector: Float32x4x4) => Float32x4
			:= vector thirdColumn';
		generateSSAModule.

	function := ssaModule globalNamed: #getMatrixColumn.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isExtractValue.
	self assert: function basicBlocks second firstInstruction indices value equals: #(2).
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixIdentity [
	| function |
	self
		evaluateSysmelSource: 'function makeIdentity externC() => Float32x4x4
			:= Float32x4x4 identity';
		generateSSAModule.

	function := ssaModule globalNamed: #makeIdentity.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
	self assert: function basicBlocks second firstInstruction value asFloatArray asArray equals: #(
		1.0 0.0 0.0 0.0
		0.0 1.0 0.0 0.0
		0.0 0.0 1.0 0.0
		0.0 0.0 0.0 1.0
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixIdentityNonSquare [
	| function |
	self
		evaluateSysmelSource: 'function makeIdentity externC() => Float32x3x4
			:= Float32x3x4 identity';
		generateSSAModule.

	function := ssaModule globalNamed: #makeIdentity.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
	self assert: function basicBlocks second firstInstruction value asFloatArray asArray equals: #(
		1.0 0.0 0.0 0.0
		0.0 1.0 0.0 0.0
		0.0 0.0 1.0 0.0
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixMatrixMultiplication [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4x3, y: Float32x3x4) => Float32x4x4 := x * y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #mulMatrixMatrix.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixOnes [
	| function |
	self
		evaluateSysmelSource: 'function makeOnes externC() => Float32x4x4
			:= Float32x4x4 ones';
		generateSSAModule.

	function := ssaModule globalNamed: #makeOnes.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
	self assert: function basicBlocks second firstInstruction value asFloatArray asArray equals: #(
		1.0 1.0 1.0 1.0
		1.0 1.0 1.0 1.0
		1.0 1.0 1.0 1.0
		1.0 1.0 1.0 1.0
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixReferenceGetFirstColumn [
	| function |
	self
		evaluateSysmelSource: 'function getMatrixColumn externC(vector: Float32x4x4 ref) => Float32x4
			:= vector firstColumn';
		generateSSAModule.

	function := ssaModule globalNamed: #getMatrixColumn.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isGetElementPointer.
	self assert: function basicBlocks second firstInstruction indices last value equals: 0.
	self assert: function basicBlocks second firstInstruction nextInstruction isLoad.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixReferenceGetFourthColumn [
	| function |
	self
		evaluateSysmelSource: 'function getMatrixColumn externC(vector: Float32x4x4 ref) => Float32x4
			:= vector fourthColumn';
		generateSSAModule.

	function := ssaModule globalNamed: #getMatrixColumn.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isGetElementPointer.
	self assert: function basicBlocks second firstInstruction indices last value equals: 3.
	self assert: function basicBlocks second firstInstruction nextInstruction isLoad.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixReferenceGetSecondColumn [
	| function |
	self
		evaluateSysmelSource: 'function getMatrixColumn externC(vector: Float32x4x4 ref) => Float32x4
			:= vector secondColumn';
		generateSSAModule.

	function := ssaModule globalNamed: #getMatrixColumn.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isGetElementPointer.
	self assert: function basicBlocks second firstInstruction indices last value equals: 1.
	self assert: function basicBlocks second firstInstruction nextInstruction isLoad.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixReferenceGetThirdColumn [
	| function |
	self
		evaluateSysmelSource: 'function getMatrixColumn externC(vector: Float32x4x4 ref) => Float32x4
			:= vector thirdColumn';
		generateSSAModule.

	function := ssaModule globalNamed: #getMatrixColumn.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isGetElementPointer.
	self assert: function basicBlocks second firstInstruction indices last value equals: 2.
	self assert: function basicBlocks second firstInstruction nextInstruction isLoad.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixRowMajorIndices [
	| function |
	self
		evaluateSysmelSource: 'function makeMatrix externC() => Float32x4x4
			:= Float32x4x4 rowMajorIndices';
		generateSSAModule.

	function := ssaModule globalNamed: #makeMatrix.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
	self assert: function basicBlocks second firstInstruction value asFloatArray asArray equals: #(
		0.0 1.0 2.0 3.0
		4.0 5.0 6.0 7.0
		8.0 9.0 10.0 11.0
		12.0 13.0 14.0 15.0
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixSubtract [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4x4, y: Float32x4x4) => Float32x4x4 := x - y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #fsub.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixVectorMultiplication [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4x4, y: Float32x4) => Float32x4 := x * y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #mulMatrixVector.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixVectorMultiplication2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x2x3, y: Float32x3) => Float32x2 := x * y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #mulMatrixVector.
	self assert: function basicBlocks second firstInstruction type isVectorType.
	self assert: function basicBlocks second firstInstruction type elements equals: 2.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixVectorMultiplicationError [
	self should: [ 
		self
		evaluateSysmelSource: 'function op externC(x: Float32x4x2, y: Float32x4x4) => Void := x * y';
		generateSSAModule
	] raise: MbndSemanticError.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixZeros [
	| function |
	self
		evaluateSysmelSource: 'function makeZeros externC() => Float32x4x4
			:= Float32x4x4 zeros';
		generateSSAModule.

	function := ssaModule globalNamed: #makeZeros.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
	self assert: function basicBlocks second firstInstruction value asFloatArray asArray equals: #(
		0.0 0.0 0.0 0.0
		0.0 0.0 0.0 0.0
		0.0 0.0 0.0 0.0
		0.0 0.0 0.0 0.0
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMultiply [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32) => Float32 := x * 3.0';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #fmul.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatNegate [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32) => Float32 := -x';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isUnaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #fneg.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatNegate2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32) => Float32 := x negated';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isUnaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #fneg.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatNotEquality [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32, y: Float32) => Boolean8 := x ~= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ufne.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatNotEquality2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32, y: Float32) => Boolean8 := x ~~ y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ufne.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatScalarToMatrix [
	| function |
	self
		evaluateSysmelSource: 'function scalarToMatrix externC(scalar: Float32) => Float32x4x4
			:= Float32x4x4(scalar)';
		generateSSAModule.

	function := ssaModule globalNamed: #scalarToMatrix.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second allInstructionsMnemonics equals:
		#(makeVector makeVector makeVector makeVector makeMatrix return).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatScalarToMatrix2 [
	| function |
	self
		evaluateSysmelSource: 'function scalarToMatrix externC(scalar: Float32) => Float32x4x4
			:= scalar';
		generateSSAModule.

	function := ssaModule globalNamed: #scalarToMatrix.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second allInstructionsMnemonics equals:
		#(makeVector makeVector makeVector makeVector makeMatrix return).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatSqrt [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32) => Float32 := x sqrt';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isUnaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #fsqrt.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatSubtract [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32) => Float32 := x - 1.0';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #fsub.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatThreeWayComparison [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32, y: Float32) => Int32 := x <=> y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function asFullSExpressionForTesting equals: #(
    function op cdecl i32
        arguments ((x f32 ()) (y f32 ()))
        literals ()
        blocks (
            (()
                (nil jump void () () (block 2 body))
            )
            (()
                (nil fsub f32 () ((local 0 x) (local 1 y)))
                (nil call f32 () ((builtInFunction (pointer (function cdecl (f32) false f32) generic) 'math.fsign')
                (local 3 nil))) (nil fp2int i32 () ((local 4 nil)))
                (nil return void () ((local 5 nil)))
            )
        )
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatToDynamicObject [
	| function |
	self
		evaluateMiniObjectModelRuntime;
		evaluateSysmelSource: 'function cast externC(x: Float32) => ProtoObject := x';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isFloatToDynamicObjectCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatToIntegerCast [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Float32) => Int32 := x castTo: Int32';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isFloatToIntCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorAdd [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4, y: Float32x4) => Float32x4 := x + y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #fadd.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorAddWithScalar [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4, y: Float32) => Float32x4 := x + y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isMakeVector.
	self assert: function basicBlocks second firstInstruction nextInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction nextInstruction operation equals: #fadd.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorAddWithScalarLiteral [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4) => Float32x4 := x + 1.0';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #fadd.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorArcTan [
	| function |
	self
		evaluateSysmelSource: 'function op externC(a: Float32x4, b: Float32x4) => Float32x4
			:= a arcTan: b';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isCall.
	self assert: function basicBlocks second firstInstruction functionValue isConstantBuiltInFunction.
	self assert: function basicBlocks second firstInstruction functionValue name equals: #'math.atan2'.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorCastToIntVector [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(v: Float32x2) => Int32x2
			:= v castTo: Int32x2';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isFloatToIntCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorCastToIntVector2 [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(v: Float32x3) => UInt32x3
			:= v castTo: UInt32x3';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isFloatToIntCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorConstruction [
	| function |
	self
		evaluateSysmelSource: 'function makeVector externC(x: Float32, y: Float32) => Float32x2
			:= Float32x2 x: x y: y';
		generateSSAModule.

	function := ssaModule globalNamed: #makeVector.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isMakeVector.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorConstruction2 [
	| function |
	self
		evaluateSysmelSource: 'function makeVector externC(xy: Float32x2, z: Float32) => Float32x3
			:= Float32x3(xy, z)';
		generateSSAModule.

	function := ssaModule globalNamed: #makeVector.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isMakeVector.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorCross [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x3, y: Float32x3) => Float32x3 := x cross: y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isCall.
	self assert: function basicBlocks second firstInstruction functionValue isConstantBuiltInFunction.
	self assert: function basicBlocks second firstInstruction functionValue name equals: #'vector.cross'.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorCross2D [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x2, y: Float32x2) => Float32 := x cross: y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self deny: function basicBlocks second firstInstruction isCall.
	self deny: function basicBlocks second firstInstruction isReturn.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorDivide [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4, y: Float32x4) => Float32x4 := x / y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #fdiv.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorDot [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4, y: Float32x4) => Float32 := x dot: y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isCall.
	self assert: function basicBlocks second firstInstruction functionValue isConstantBuiltInFunction.
	self assert: function basicBlocks second firstInstruction functionValue name equals: #'vector.dot'.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorElementEquality [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4, y: Float32x4) => Boolean8x4 := x %= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ufeq.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorElementEquality2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4, y: Float32x4) => Boolean8x4 := x %== y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ufeq.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorElementGreaterOrEqual [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4, y: Float32x4) => Boolean8x4 := x %>= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ufge.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorElementGreaterThan [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4, y: Float32x4) => Boolean8x4 := x %> y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ufgt.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorElementLessOrEqual [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4, y: Float32x4) => Boolean8x4 := x %<= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ufle.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorElementLessThan [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4, y: Float32x4) => Boolean8x4 := x %< y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #uflt.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorElementNotEquality [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4, y: Float32x4) => Boolean8x4 := x %~= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ufne.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorElementNotEquality2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4, y: Float32x4) => Boolean8x4 := x %~~ y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ufne.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorElementThreeWayComparison [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4, y: Float32x4) => Int32x4 := x %<=> y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function asFullSExpressionForTesting equals: #(
	function op cdecl (vector i32 4)
    arguments ((x (vector f32 4) ()) (y (vector f32 4) ()))
    literals ()
    blocks (
        (()
            (nil jump void () () (block 2 body))
        )
        (()
            (nil fsub (vector f32 4) () ((local 0 x) (local 1 y)))
            (nil call (vector f32 4) () ((builtInFunction (pointer (function cdecl ((vector f32 4)) false (vector f32 4)) generic) 'math.fsign') (local 3 nil)))
            (nil fp2int (vector i32 4) () ((local 4 nil)))
            (nil return void () ((local 5 nil)))
        )
    )
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorEquality [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4, y: Float32x4) => Boolean8 := x = y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function asFullSExpressionForTesting equals: #(
	function op cdecl b8
    arguments ((x (vector f32 4) ()) (y (vector f32 4) ()))
    literals ()
    blocks (
        (()
            (nil jump void () () (block 2 body))
        )
        (()
            (nil ufeq (vector b8 4) () ((local 0 x) (local 1 y)))
            (nil call b8 () ((builtInFunction (pointer (function cdecl ((vector b8 4)) false b8) generic) 'vector.all') (local 3 nil)))
            (nil return void () ((local 4 nil)))
        )
    )
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorEquality2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4, y: Float32x4) => Boolean8 := x == y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function asFullSExpressionForTesting equals: #(
	function op cdecl b8
    arguments ((x (vector f32 4) ()) (y (vector f32 4) ()))
    literals ()
    blocks (
        (()
            (nil jump void () () (block 2 body))
        )
        (()
            (nil ufeq (vector b8 4) () ((local 0 x) (local 1 y)))
            (nil call b8 () ((builtInFunction (pointer (function cdecl ((vector b8 4)) false b8) generic) 'vector.all') (local 3 nil)))
            (nil return void () ((local 4 nil)))
        )
    )
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorGetW [
	| function |
	self
		evaluateSysmelSource: 'function getVectorElement externC(vector: Float32x4) => Float32
			:= vector w';
		generateSSAModule.

	function := ssaModule globalNamed: #getVectorElement.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isExtractVectorElement.
	self assert: function basicBlocks second firstInstruction index value equals: 3.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorGetX [
	| function |
	self
		evaluateSysmelSource: 'function getVectorElement externC(vector: Float32x4) => Float32
			:= vector x';
		generateSSAModule.

	function := ssaModule globalNamed: #getVectorElement.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isExtractVectorElement.
	self assert: function basicBlocks second firstInstruction index value equals: 0.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorGetY [
	| function |
	self
		evaluateSysmelSource: 'function getVectorElement externC(vector: Float32x4) => Float32
			:= vector y';
		generateSSAModule.

	function := ssaModule globalNamed: #getVectorElement.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isExtractVectorElement.
	self assert: function basicBlocks second firstInstruction index value equals: 1.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorGetZ [
	| function |
	self
		evaluateSysmelSource: 'function getVectorElement externC(vector: Float32x4) => Float32
			:= vector z';
		generateSSAModule.

	function := ssaModule globalNamed: #getVectorElement.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isExtractVectorElement.
	self assert: function basicBlocks second firstInstruction index value equals: 2.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorInterpolateToAt [
	| function |
	self
		evaluateSysmelSource: 'function op externC(edge0: Float32x4, edge1: Float32x4, value: Float32x4) => Float32x4
			:= edge0 interpolateTo: edge1 at: value';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isCall.
	self assert: function basicBlocks second firstInstruction functionValue isConstantBuiltInFunction.
	self assert: function basicBlocks second firstInstruction functionValue name equals: #'math.fmix'.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorInterpolateToAt2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(edge0: Float32x4, edge1: Float32x4, value: Float32) => Float32x4
			:= edge0 interpolateTo: edge1 at: value';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second lastInstruction previousInstruction isCall.
	self assert: function basicBlocks second lastInstruction previousInstruction functionValue isConstantBuiltInFunction.
	self assert: function basicBlocks second lastInstruction previousInstruction functionValue name equals: #'math.fmix'.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorLength2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4) => Float32 := x length2';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isCall.
	self assert: function basicBlocks second firstInstruction functionValue isConstantBuiltInFunction.
	self assert: function basicBlocks second firstInstruction functionValue name equals: #'vector.dot'.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorLessThan [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4, y: Float32x4) => Boolean8 := x < y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function asFullSExpressionForTesting equals: #(
function op cdecl b8
    arguments ((x (vector f32 4) ()) (y (vector f32 4) ()))
    literals ()
    blocks (
        (()
            (nil jump void () () (block 2 body))
        )
        (()
            (nil fsub (vector f32 4) () ((local 0 x) (local 1 y)))
            (nil call (vector f32 4) () ((builtInFunction (pointer (function cdecl ((vector f32 4)) false (vector f32 4)) generic) 'math.fsign') (local 3 nil)))
            (nil fp2int (vector i32 4) () ((local 4 nil)))
            (nil call i32 () ((builtInFunction (pointer (function cdecl ((vector i32 4) (vector i32 4)) false i32) generic) 'vector.dot') (local 5 nil) (constVector (vector i32 4) ((const i32 1073741824) (const i32 268435456) (const i32 67108864) (const i32 16777216)))))
            (nil ilt b8 () ((local 6 nil) (const i32 0)))
            (nil return void () ((local 7 nil)))
        )
    )
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorMatrixMultiplication [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4, y: Float32x4x4) => Float32x4 := x * y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #mulVectorMatrix.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorMax [
	| function |
	self
		evaluateSysmelSource: 'function op externC(a: Float32x4, b: Float32x4) => Float32x4
			:= a max: b';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isCall.
	self assert: function basicBlocks second firstInstruction functionValue isConstantBuiltInFunction.
	self assert: function basicBlocks second firstInstruction functionValue name equals: #'math.fmax'.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorMin [
	| function |
	self
		evaluateSysmelSource: 'function op externC(a: Float32x4, b: Float32x4) => Float32x4
			:= a min: b';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isCall.
	self assert: function basicBlocks second firstInstruction functionValue isConstantBuiltInFunction.
	self assert: function basicBlocks second firstInstruction functionValue name equals: #'math.fmin'.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorMultiply [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4, y: Float32x4) => Float32x4 := x * y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #fmul.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorNegate [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4) => Float32x4 := -x';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isUnaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #fneg.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorNegate2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4) => Float32x4 := x negated';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isUnaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #fneg.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorNotEquality [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4, y: Float32x4) => Boolean8 := x ~= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function asFullSExpressionForTesting equals: #(
	function op cdecl b8
    arguments ((x (vector f32 4) ()) (y (vector f32 4) ()))
    literals ()
    blocks (
        (()
            (nil jump void () () (block 2 body))
        )
        (()
            (nil ufne (vector b8 4) () ((local 0 x) (local 1 y)))
            (nil call b8 () ((builtInFunction (pointer (function cdecl ((vector b8 4)) false b8) generic) 'vector.any') (local 3 nil)))
            (nil return void () ((local 4 nil)))
        )
    )
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorNotEquality2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4, y: Float32x4) => Boolean8 := x ~~ y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function asFullSExpressionForTesting equals: #(
	function op cdecl b8
    arguments ((x (vector f32 4) ()) (y (vector f32 4) ()))
    literals ()
    blocks (
        (()
            (nil jump void () () (block 2 body))
        )
        (()
            (nil ufne (vector b8 4) () ((local 0 x) (local 1 y)))
            (nil call b8 () ((builtInFunction (pointer (function cdecl ((vector b8 4)) false b8) generic) 'vector.any') (local 3 nil)))
            (nil return void () ((local 4 nil)))
        )
    )
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorRaisedTo [
	| function |
	self
		evaluateSysmelSource: 'function op externC(a: Float32x4, b: Float32x4) => Float32x4
			:= a raisedTo: b';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isCall.
	self assert: function basicBlocks second firstInstruction functionValue isConstantBuiltInFunction.
	self assert: function basicBlocks second firstInstruction functionValue name equals: #'math.pow'.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorSetYConstReferenceValue [
	| function |
	self
		evaluateSysmelSource: 'function setVectorElement externC(vector: Float32x4 const ref, value: Float32) => Float32x4
			:= vector y: value';
		generateSSAModule.

	function := ssaModule globalNamed: #setVectorElement.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isLoad.
	self assert: function basicBlocks second firstInstruction nextInstruction isInsertVectorElement.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorSetYReferenceValue [
	| function |
	self
		evaluateSysmelSource: 'function setVectorElement externC(vector: Float32x4 ref, value: Float32) => Float32
			:= vector y := value';
		generateSSAModule.

	function := ssaModule globalNamed: #setVectorElement.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isGetElementPointer.
	self assert: function basicBlocks second firstInstruction nextInstruction isStore.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorSetYReferenceValue2 [
	| function |
	self
		evaluateSysmelSource: 'function setVectorElement externC(vector: Float32x4 ref, value: Float32) => Float32x4
			:= vector y: value';
		generateSSAModule.

	function := ssaModule globalNamed: #setVectorElement.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isGetElementPointer.
	self assert: function basicBlocks second firstInstruction nextInstruction isStore.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorSin [
	| function |
	self
		evaluateSysmelSource: 'function op externC(a: Float32x4) => Float32x4
			:= a sin';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isCall.
	self assert: function basicBlocks second firstInstruction functionValue isConstantBuiltInFunction.
	self assert: function basicBlocks second firstInstruction functionValue name equals: #'math.sin'.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorSmoothStep [
	| function |
	self
		evaluateSysmelSource: 'function op externC(edge0: Float32x4, edge1: Float32x4, value: Float32x4) => Float32x4
			:= edge0 smoothStepTo: edge1 value: value';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isCall.
	self assert: function basicBlocks second firstInstruction functionValue isConstantBuiltInFunction.
	self assert: function basicBlocks second firstInstruction functionValue name equals: #'math.smoothstep'.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorSmoothStep2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(edge0: Float32, edge1: Float32, value: Float32x4) => Float32x4
			:= edge0 smoothStepTo: edge1 value: value';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isCall.
	self assert: function basicBlocks second firstInstruction functionValue isConstantBuiltInFunction.
	self assert: function basicBlocks second firstInstruction functionValue name equals: #'math.smoothstep'.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorSqrt [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4) => Float32x4 := x sqrt';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isUnaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #fsqrt.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorStep [
	| function |
	self
		evaluateSysmelSource: 'function op externC(edge0: Float32x4, value: Float32x4) => Float32x4
			:= edge0 stepValue: value';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isCall.
	self assert: function basicBlocks second firstInstruction functionValue isConstantBuiltInFunction.
	self assert: function basicBlocks second firstInstruction functionValue name equals: #'math.step'.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorStep2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(edge0: Float32, value: Float32x4) => Float32x4
			:= edge0 stepValue: value';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isCall.
	self assert: function basicBlocks second firstInstruction functionValue isConstantBuiltInFunction.
	self assert: function basicBlocks second firstInstruction functionValue name equals: #'math.step'.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorSubtract [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4, y: Float32x4) => Float32x4 := x - y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #fsub.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorSwizzle [
	| function |
	self
		evaluateSysmelSource: 'function getVectorElements externC(vector: Float32x4) => Float32x4
			:= vector wzyx';
		generateSSAModule.

	function := ssaModule globalNamed: #getVectorElements.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isShuffleVectors.
	self assert: function basicBlocks second firstInstruction components value equals: #(3 2 1 0).
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorThreeWayComparison [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4, y: Float32x4) => Int32 := x <=> y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function asFullSExpressionForTesting equals: #(
function op cdecl i32
    arguments ((x (vector f32 4) ()) (y (vector f32 4) ()))
    literals ()
    blocks (
        (()
            (nil jump void () () (block 2 body))
        )
        (()
            (nil fsub (vector f32 4) () ((local 0 x) (local 1 y)))
            (nil call (vector f32 4) () ((builtInFunction (pointer (function cdecl ((vector f32 4)) false (vector f32 4)) generic) 'math.fsign') (local 3 nil)))
            (nil fp2int (vector i32 4) () ((local 4 nil)))
            (nil call i32 () ((builtInFunction (pointer (function cdecl ((vector i32 4) (vector i32 4)) false i32) generic) 'vector.dot') (local 5 nil) (constVector (vector i32 4) ((const i32 1073741824) (const i32 268435456) (const i32 67108864) (const i32 16777216)))))
            (nil return void () ((local 6 nil)))
        )
    )
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatingPointCast [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Float32) => Float64 := x';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isFloatingPointCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGCClassGetPublicField [
	| function |
	self
		evaluateMiniObjectModelRuntime;
		evaluateSysmelSource: '
gcclass ClassWithPublicField definition: { 
	public field int32Field type: Int32.
}.

function getPublicField externC(o: ClassWithPublicField) => Int32
	:= o int32Field.
';
		generateSSAModule.

	function := ssaModule globalNamed: #getPublicField.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (
			getElementPointer
			load
			return
		))
	).
	
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGCClassGetPublicField2 [
	| function |
	self
		evaluateMiniObjectModelRuntime;
		evaluateSysmelSource: '
gcclass ClassWithPublicField definition: { 
	public field int32Field type: Int32.
}.

function getPublicField externC(o: ClassWithPublicField ref) => Int32
	:= o int32Field.
';
		generateSSAModule.

	function := ssaModule globalNamed: #getPublicField.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (
			load
			getElementPointer
			load
			return
		))
	).
	
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGCClassMessageSend [
	| function |
	self
		evaluateMiniObjectModelRuntime;
		evaluateSysmelSource: '
gcclass SuperClass definition: { 
	field int32Field type: Int32.
	
	method getValue => Float64
		:= int32Field.
}.

function callMessage externC(o: SuperClass) => Float64
	:= o getValue.
';
		generateSSAModule.

	function := ssaModule globalNamed: #callMessage.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (
			send
			return
		))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGCClassMessageSuperSend [
	| function |
	self
		evaluateMiniObjectModelRuntime;
		evaluateSysmelSource: '
gcclass SuperClass definition: { 
	field int32Field type: Int32.
	
	method getValue => Float64
		:= int32Field.
}.

gcclass SubClass superclass: SuperClass; definition: { 
	field float32Field type: Float32.
	
	method getValue => Float64
		:= super getValue + float32Field.
}.

function callMessage externC(o: SubClass) => Float64
	:= o getValue.
';
		generateSSAModule.

	function := ssaModule globalNamed: #callMessage.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (
			send
			return
		))
	).
	
	function := ssaModule globalNamed: #'_ZN10TestModule8SubClass9.getValueEPNS0_Ed'.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (
			bitcast
			send
			getElementPointer
			load
			fpcast
			fadd
			return
		))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGetFieldReference [
	| function |
	self
		evaluateSysmelSource: '
		struct TestStruct definition: {
			field intField public type: Int32
		}.
		
		function getFieldRef externC(s: TestStruct ref) => Int32
			:= s intField
';
		generateSSAModule.

	function := ssaModule globalNamed: #getFieldRef.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks first firstInstruction isJump.
	self assert: function basicBlocks second firstInstruction isGetElementPointer.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGetFieldValue [
	| function |
	self
		evaluateSysmelSource: '
		struct TestStruct definition: {
			field intField public type: Int32
		}.
		
		function getFieldValue externC(s: TestStruct) => Int32
			:= s intField
';
		generateSSAModule.

	function := ssaModule globalNamed: #getFieldValue.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks first firstInstruction isJump.
	self assert: function basicBlocks second firstInstruction isExtractValue.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGetPointerElementAtFunction [
	| function |
	self
		evaluateSysmelSource: '
function getPointerElement externC(pointer: Int32 pointer, index: Int32) => Int32
	:= pointer at: index';
		generateSSAModule.

	function := ssaModule globalNamed: #getPointerElement.
	self assert: function asFullSExpressionForTesting equals: #(
function getPointerElement cdecl i32
    arguments ((pointer (pointer i32 generic) ()) (index i32 ()))
    literals ()
    blocks (
        (()
            (nil jump void () () (block 2 body))
        )
        (()
            (nil sext i64 () ((local 1 index)))
            (nil sub i64 () ((local 3 nil) (const i64 1)))
            (nil getElementPointer (pointer i32 generic) () ((local 0 pointer) (local 4 nil)))
            (nil load i32 () ((local 5 nil)))
            (nil return void () ((local 6 nil)))
        )
    )
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGetPointerElementFunction [
	| function |
	self
		evaluateSysmelSource: '
function getPointerElement externC(pointer: Int32 pointer, index: Int32) => Int32
	:= pointer[index]';
		generateSSAModule.

	function := ssaModule globalNamed: #getPointerElement.
	self assert: function asFullSExpressionForTesting equals: #(
function getPointerElement cdecl i32
    arguments ((pointer (pointer i32 generic) ()) (index i32 ()))
    literals ()
    blocks (
        (()
            (nil jump void () () (block 2 body))
        )
        (()
            (nil sext i64 () ((local 1 index)))
            (nil getElementPointer (pointer i32 generic) () ((local 0 pointer) (local 3 nil)))
            (nil load i32 () ((local 4 nil)))
            (nil return void () ((local 5 nil)))
        )
    )
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGetPrivateFieldReference [
	| function |
	self
		evaluateSysmelSource: '
		struct TestStruct definition: {
			field intField public type: Int32
		}.
		
		function getFieldRef externC(s: TestStruct ref) => Int32
			:= s __private intField
';
		generateSSAModule.

	function := ssaModule globalNamed: #getFieldRef.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks first firstInstruction isJump.
	self assert: function basicBlocks second firstInstruction isGetElementPointer.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGetPrivateFieldValue [
	| function |
	self
		evaluateSysmelSource: '
		struct TestStruct definition: {
			field intField public type: Int32
		}.
		
		function getFieldValue externC(s: TestStruct) => Int32
			:= s __private intField
';
		generateSSAModule.

	function := ssaModule globalNamed: #getFieldValue.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks first firstInstruction isJump.
	self assert: function basicBlocks second firstInstruction isExtractValue.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGetUnionFieldReference [
	| function |
	self
		evaluateSysmelSource: '
		union TestUnion definition: {
			field intField public type: Int32.
			field floatField public type: Int32.
		}.
		
		function getFieldRef externC(s: TestUnion ref) => Int32
			:= s intField
';
		generateSSAModule.

	function := ssaModule globalNamed: #getFieldRef.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks first firstInstruction isJump.
	self assert: function basicBlocks second firstInstruction isBitCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGetUnionFieldValue [
	| function |
	self
		evaluateSysmelSource: '
		union TestUnion definition: {
			field intField public type: Int32.
			field floatField public type: Float64.
		}.
		
		function getFieldValue externC(s: TestUnion) => Int32
			:= s intField
';
		generateSSAModule.

	function := ssaModule globalNamed: #getFieldValue.
	self assert: function isFunction.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (bitcast load return))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGlobalArrayInitialization [
	| globalVariable |
	self
		evaluateSysmelSource: '
global theArray mutable externC type: (Int32 array: 5) := #(1 2 3 4 5).
';
		generateSSAModule.

	globalVariable := ssaModule globalNamed: #theArray.
	self assert: globalVariable isGlobalVariable.
	self deny: globalVariable readOnly.
	self assert: (globalVariable initialValue slots collect: [:each | each value]) equals: #(1 2 3 4 5).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGlobalArrayInitialization2 [
	| globalVariable |
	self
		evaluateSysmelSource: '
global theArray mutable externC type: (Int32 array: 5) := (1, 2, 3, 4, 5).
';
		generateSSAModule.

	globalVariable := ssaModule globalNamed: #theArray.
	self assert: globalVariable isGlobalVariable.
	self deny: globalVariable readOnly.
	self assert: (globalVariable initialValue slots collect: [:each | each value]) equals: #(1 2 3 4 5).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGlobalArrayInitialization3 [
	| globalVariable |
	self
		evaluateSysmelSource: '
global firstPointed mutable externC type: Int32.
global secondPointed mutable externC type: Int32.
global theArray mutable externC type: (Int32 pointer array: 2) := (
	firstPointed address,
	secondPointed address
).
';
		generateSSAModule.

	globalVariable := ssaModule globalNamed: #theArray.
	self assert: globalVariable isGlobalVariable.
	self deny: globalVariable readOnly.
	self assert: globalVariable initialValue slots equals: {
		ssaModule globalNamed: #firstPointed.
		ssaModule globalNamed: #secondPointed.
	}.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGlobalVariableDefinition [
	| global |
	self
		evaluateSysmelSource: 'global testGlobal externC mutable := 42';
		generateSSAModule.

	global := ssaModule globalNamed: #testGlobal.
	self assert: global isGlobalVariable.
	self deny: global readOnly.
	self assert: global valueType isIntegerType.
	self assert: global initialValue isConstantValue.
	self assert: global initialValue value equals: 42.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGlobalVariableImmutableLoad [
	| global function |
	self
		evaluateSysmelSource: '
global testGlobal externC := 42.

function testFunction externC () => Int32 := testGlobal.
';
		generateSSAModule.

	global := ssaModule globalNamed: #testGlobal.
	function := ssaModule globalNamed: #testFunction.
	self assert: global isGlobalVariable.
	self assert: global readOnly.
	self assert: function isFunction.
	self assert: function basicBlocks second firstInstruction isLoad.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGlobalVariableLazyInitialization [
	| global pointed |
	self
		evaluateSysmelSource: '
struct StructWithPointer.
		
global testGlobal externC mutable type: StructWithPointer := StructWithPointer newValue
	pointer: testPointed address.

StructWithPointer definition: {
	public field pointer type: Int32 pointer.	
}.

global testPointed externC mutable type: Int32 := 42.
';
		generateSSAModule.

	global := ssaModule globalNamed: #testGlobal.
	pointed := ssaModule globalNamed: #testPointed.
	self assert: global isGlobalVariable.
	self assert: pointed isGlobalVariable.
	self assert: global valueType isStructureType.
	self assert: global initialValue isConstantStructureValue.
	self assert: global initialValue slots first equals: pointed.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGlobalVariableMultipleInitialization [
	| testA testB testC |
	self
		evaluateSysmelSource: '
struct TestStruct definition: { 
	public field f type: Int32.
}.

global testA externC mutable := TestStruct newValue f: 0.
global testB externC mutable := TestStruct newValue f: 1.
global testC externC mutable := TestStruct newValue f: 2.
';
		generateSSAModule.

	testA := ssaModule globalNamed: #testA.
	testB := ssaModule globalNamed: #testB.
	testC := ssaModule globalNamed: #testC.
	self assert: testA isGlobalVariable.
	self assert: testA initialValue isConstantStructureValue.
	self assert: testA initialValue slots first value equals: 0.
	
	self assert: testB isGlobalVariable.
	self assert: testB initialValue isConstantStructureValue.
	self assert: testB initialValue slots first value equals: 1.

	self assert: testC isGlobalVariable.
	self assert: testC initialValue isConstantStructureValue.
	self assert: testC initialValue slots first value equals: 2.

]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGlobalVariableMultipleInitialization2 [
	| testA testB testC |
	self
		evaluateSysmelSource: '
struct TestStruct definition: { 
	meta method for: (v: Int32) ::=> TestStruct
		:= SelfType newValue f: v.

	public field f type: Int32.
}.

global testA externC mutable := TestStruct for: 0.
global testB externC mutable := TestStruct for: 1.
global testC externC mutable := TestStruct for: 2.
';
		generateSSAModule.

	testA := ssaModule globalNamed: #testA.
	self assert: testA isGlobalVariable.
	self assert: testA initialValue isConstantStructureValue.
	self assert: testA initialValue slots first value equals: 0.
	
	testB := ssaModule globalNamed: #testB.
	self assert: testB isGlobalVariable.
	self assert: testB initialValue isConstantStructureValue.
	self assert: testB initialValue slots first value equals: 1.

	testC := ssaModule globalNamed: #testC.
	self assert: testC isGlobalVariable.
	self assert: testC initialValue isConstantStructureValue.
	self assert: testC initialValue slots first value equals: 2.

]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGlobalVariableMultipleInitialization3 [
	| testA testB testC |
	self
		evaluateSysmelSource: '
struct TestStruct definition: { 
	meta method for: (v: Int32) ::=> TestStruct
		:= SelfType newValue f: v; yourself.

	public field f type: Int32.
}.

global testA externC mutable := TestStruct for: 0.
global testB externC mutable := TestStruct for: 1.
global testC externC mutable := TestStruct for: 2.
';
		generateSSAModule.

	testA := ssaModule globalNamed: #testA.
	self assert: testA isGlobalVariable.
	self assert: testA initialValue isConstantStructureValue.
	self assert: testA initialValue slots first value equals: 0.
	
	testB := ssaModule globalNamed: #testB.
	self assert: testB isGlobalVariable.
	self assert: testB initialValue isConstantStructureValue.
	self assert: testB initialValue slots first value equals: 1.

	testC := ssaModule globalNamed: #testC.
	self assert: testC isGlobalVariable.
	self assert: testC initialValue isConstantStructureValue.
	self assert: testC initialValue slots first value equals: 2.

]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGlobalVariablePackedStructre [
	| global |
	self
		evaluateSysmelSource: '
struct PackedStructure packed definition: { 
	public field byteValue type: Boolean8.
	public field wordValue type: UInt32.
}.

global testGlobal externC mutable type: PackedStructure';
		generateSSAModule.

	global := ssaModule globalNamed: #testGlobal.
	self assert: global isGlobalVariable.
	self assert: global valueType isStructureType.
	self assert: global valueType isPacked.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGlobalVariableWithConstructor [
	| global ctor globalCtor callInstruction |
	self
		evaluateSysmelSource: '
function makeHandle externC() => Int32.

struct Resource definition: { 
	public field handle type: Int32.
	
	method initialize => Void := { 
		handle := makeHandle().
	}.
}.

global globalHandle externC mutable type: Resource';
		generateSSAModule.

	global := ssaModule globalNamed: #globalHandle.
	self assert: global isGlobalVariable.
	self assert: global valueType isStructureType.
	self assert: global initialValue isNotNil.
	
	self assert: ssaModule globalConstructors isNotEmpty.
	ctor := ssaModule globalConstructors first.
	self assert: ctor global equals: global.
	self assert: ctor priority equals: semanticModule compilationTarget normalConstructorPriority.

	globalCtor := ctor function.
	self assert: globalCtor allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (call returnVoid))
	).
	
	callInstruction := globalCtor basicBlocks second firstInstruction.
	self assert: callInstruction isCall.
	self assert: callInstruction functionValue name equals: #'_ZN10TestModule8Resource11.initializeERNS0_E'. 
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGlobalVariableWithConstructorPriority [
	| global ctor globalCtor callInstruction |
	self
		evaluateSysmelSource: '
function makeHandle externC() => Int32.

struct Resource definition: { 
	public field handle type: Int32.
	
	method initialize => Void := { 
		handle := makeHandle().
	}.
}.

global globalHandle externC mutable type: Resource; constructionPriority: -100';
		generateSSAModule.

	global := ssaModule globalNamed: #globalHandle.
	self assert: global isGlobalVariable.
	self assert: global valueType isStructureType.
	self assert: global initialValue isNotNil.
	
	self assert: ssaModule globalConstructors isNotEmpty.
	ctor := ssaModule globalConstructors first.
	self assert: ctor global equals: global.
	self assert: ctor priority equals: -100.

	globalCtor := ctor function.
	self assert: globalCtor allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (call returnVoid))
	).
	
	callInstruction := globalCtor basicBlocks second firstInstruction.
	self assert: callInstruction isCall.
	self assert: callInstruction functionValue name equals: #'_ZN10TestModule8Resource11.initializeERNS0_E'.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGlobalVariableWithDestructor [
	| global dtor globalDtor callInstruction |
	self
		evaluateSysmelSource: '
function destroyHandle externC(handle: Int32) => Void.

struct Resource definition: { 
	public field handle type: Int32.
	
	method finalize => Void := { 
		destroyHandle(handle).
	}.
}.

global globalHandle externC mutable type: Resource';
		generateSSAModule.

	global := ssaModule globalNamed: #globalHandle.
	self assert: global isGlobalVariable.
	self assert: global valueType isStructureType.
	self assert: global initialValue isNotNil.
	
	self assert: ssaModule globalDestructors isNotEmpty.
	dtor := ssaModule globalDestructors first.
	self assert: dtor global equals: global.
	self assert: dtor priority equals: semanticModule compilationTarget normalConstructorPriority.

	globalDtor := dtor function.
	self assert: globalDtor allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (call returnVoid))
	).
	
	callInstruction := globalDtor basicBlocks second firstInstruction.
	self assert: callInstruction isCall.
	self assert: callInstruction functionValue name equals: #'_ZN10TestModule8Resource9.finalizeERNS0_E'.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGlobalVariableWithDestructorAndInitialization [
	| global dtor globalDtor callInstruction |
	self
		evaluateSysmelSource: '
function destroyHandle externC(handle: Int32) => Void.

struct Resource definition: { 
	public field handle type: Int32.
	
	method finalize => Void := { 
		destroyHandle(handle).
	}.
}.

global globalHandle externC mutable := Resource basicNewValue handle: 42';
		generateSSAModule.

	global := ssaModule globalNamed: #globalHandle.
	self assert: global isGlobalVariable.
	self assert: global valueType isStructureType.
	self assert: global initialValue isNotNil.
	
	self assert: ssaModule globalDestructors isNotEmpty.
	dtor := ssaModule globalDestructors first.
	self assert: dtor global equals: global.
	self assert: dtor priority equals: semanticModule compilationTarget normalConstructorPriority.

	globalDtor := dtor function.
	self assert: globalDtor allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (call returnVoid))
	).
	
	callInstruction := globalDtor basicBlocks second firstInstruction.
	self assert: callInstruction isCall.
	self assert: callInstruction functionValue name equals: #'_ZN10TestModule8Resource9.finalizeERNS0_E'.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGlobalVariableWithDestructorAndInitialization2 [
	| global dtor globalDtor callInstruction |
	self
		evaluateSysmelSource: '
function destroyHandle externC(handle: Int32) => Void.

struct Resource definition: { 
	public field handle type: Int32.
	
	method finalize => Void := { 
		destroyHandle(handle).
	}.
}.

global globalHandle externC mutable type: Resource := Resource basicNewValue handle: 42';
		generateSSAModule.

	global := ssaModule globalNamed: #globalHandle.
	self assert: global isGlobalVariable.
	self assert: global valueType isStructureType.
	self assert: global initialValue isNotNil.
	
	self assert: ssaModule globalDestructors isNotEmpty.
	dtor := ssaModule globalDestructors first.
	self assert: dtor global equals: global.
	self assert: dtor priority equals: semanticModule compilationTarget normalConstructorPriority.

	globalDtor := dtor function.
	self assert: globalDtor allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (call returnVoid))
	).
	
	callInstruction := globalDtor basicBlocks second firstInstruction.
	self assert: callInstruction isCall.
	self assert: callInstruction functionValue name equals: #'_ZN10TestModule8Resource9.finalizeERNS0_E'.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGlobalVariableWithDestructorAndInitialization3 [
	| global dtor globalDtor callInstruction |
	self
		evaluateSysmelSource: '
function destroyHandle externC(handle: Int32) => Void.

struct Resource definition: { 
	public field handle type: Int32.
	
	meta method for: (theHandle: Int32) ::=> SelfType
		:= SelfType basicNewValue handle: 42; yourself.
	
	method finalize => Void := { 
		destroyHandle(handle).
	}.
}.

global globalHandle externC mutable := Resource for: 42';
		generateSSAModule.

	global := ssaModule globalNamed: #globalHandle.
	self assert: global isGlobalVariable.
	self assert: global valueType isStructureType.
	self assert: global initialValue isNotNil.
	
	self assert: ssaModule globalDestructors isNotEmpty.
	dtor := ssaModule globalDestructors first.
	self assert: dtor global equals: global.
	self assert: dtor priority equals: semanticModule compilationTarget normalConstructorPriority.

	globalDtor := dtor function.
	self assert: globalDtor allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (call returnVoid))
	).
	
	callInstruction := globalDtor basicBlocks second firstInstruction.
	self assert: callInstruction isCall.
	self assert: callInstruction functionValue name equals: #'_ZN10TestModule8Resource9.finalizeERNS0_E'.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGlobalVariableWithDestructorAndInitialization4 [
	| global dtor globalDtor callInstruction |
	self
		evaluateSysmelSource: '
function destroyHandle externC(handle: Int32) => Void.

struct Resource definition: { 
	public field handle type: Int32.
	
	meta method for: (theHandle: Int32) ::=> SelfType
		:= SelfType basicNewValue handle: 42; yourself.
	
	method finalize => Void := { 
		destroyHandle(handle).
	}.
}.

global globalHandle externC mutable type: Resource := Resource for: 42';
		generateSSAModule.

	global := ssaModule globalNamed: #globalHandle.
	self assert: global isGlobalVariable.
	self assert: global valueType isStructureType.
	self assert: global initialValue isNotNil.
	
	self assert: ssaModule globalDestructors isNotEmpty.
	dtor := ssaModule globalDestructors first.
	self assert: dtor global equals: global.
	self assert: dtor priority equals: semanticModule compilationTarget normalConstructorPriority.

	globalDtor := dtor function.
	self assert: globalDtor allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (call returnVoid))
	).
	
	callInstruction := globalDtor basicBlocks second firstInstruction.
	self assert: callInstruction isCall.
	self assert: callInstruction functionValue name equals: #'_ZN10TestModule8Resource9.finalizeERNS0_E'.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGlobalVariableWithDestructorPriority [
	| global dtor globalDtor callInstruction |
	self
		evaluateSysmelSource: '
function destroyHandle externC(handle: Int32) => Void.

struct Resource definition: { 
	public field handle type: Int32.
	
	method finalize => Void := { 
		destroyHandle(handle).
	}.
}.

global globalHandle externC mutable type: Resource; constructionPriority: -100';
		generateSSAModule.

	global := ssaModule globalNamed: #globalHandle.
	self assert: global isGlobalVariable.
	self assert: global valueType isStructureType.
	self assert: global initialValue isNotNil.
	
	self assert: ssaModule globalDestructors isNotEmpty.
	dtor := ssaModule globalDestructors first.
	self assert: dtor global equals: global.
	self assert: dtor priority equals: -100.

	globalDtor := dtor function.
	self assert: globalDtor allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (call returnVoid))
	).
	
	callInstruction := globalDtor basicBlocks second firstInstruction.
	self assert: callInstruction isCall.
	self assert: callInstruction functionValue name equals: #'_ZN10TestModule8Resource9.finalizeERNS0_E'.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGlobalVariableWithMinimalAlignment [
	| global |
	self
		evaluateSysmelSource: '
global testGlobal externC mutable alignment: 4096; type: UIntPointer';
		generateSSAModule.

	global := ssaModule globalNamed: #testGlobal.
	self assert: global isGlobalVariable.
	self assert: global valueType isPrimitiveType.
	self assert: global minimalAlignment equals: 4096
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGlobalVariableWithNonCompileTimeInitialization [
	| global globalCtor ctor |
	self
		evaluateSysmelSource: '
function makeHandle externC() => Int32.

struct Resource definition: { 
	public field handle type: Int32.
}.

global globalHandle externC mutable type: Resource := (Resource newValue handle: makeHandle(); yourself)';
		generateSSAModule.

	global := ssaModule globalNamed: #globalHandle.
	self assert: global isGlobalVariable.
	self assert: global valueType isStructureType.
	self assert: global initialValue isNotNil.
	
	self assert: ssaModule globalConstructors isNotEmpty.
	ctor := ssaModule globalConstructors first.
	self assert: ctor global equals: global.
	self assert: ctor priority equals: semanticModule compilationTarget normalConstructorPriority.

	globalCtor := ctor function.
	self assert: globalCtor allInstructionsMnemonics equals: #(
		(entry (alloca jump))
		(body (store call getElementPointer store load store returnVoid))
	).

]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIdentityCFunction [
	| function |
	self
		evaluateSysmelSource: 'function identity externC(x: Int32) => Int32 := x';
		generateSSAModule.

	function := ssaModule globalNamed: #identity.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks first firstInstruction isJump.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIdentityCast [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Int32) => Int32 := x castTo: Int32';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIdentityScopedCFunction [
	| function |
	self
		evaluateSysmelSource: 'function identity externC(x: Int32) => Int32 := {x}';
		generateSSAModule.

	function := ssaModule globalNamed: #identity.
	self assert: function isFunction.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (jump))
		(tryScope (return))
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIdentityScopedSequenceCFunction [
	| function |
	self
		evaluateSysmelSource: 'function identity externC(x: Int32) => Int32 := {1 . x}';
		generateSSAModule.

	function := ssaModule globalNamed: #identity.
	self assert: function isFunction.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (jump))
		(tryScope (return))
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIfIntegerLiteralCoercion [
	| function |
	self
		evaluateSysmelSource: 'function coercion externC(condition: Boolean8, uint: UInt32) => UInt32
		:= if: condition then: uint else: 0.';
		generateSSAModule.

	function := ssaModule globalNamed: #coercion.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 5.
	self assert: function basicBlocks fifth firstInstruction isPhi.
	self assert: function basicBlocks fifth lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testInputChannelReceiveInteger [
	| function |
	self
		evaluateMiniObjectModelRuntime;
		evaluateSysmelSource: 'function receive externC(inputChannel: Int32 inputChannel) => Int32
			:= inputChannel receive';
		generateSSAModule.

	function := ssaModule globalNamed: #receive.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isMessageSend.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerAdd [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x + 1';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #add.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerAddUInt64 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: UInt64) => UInt64 := x + 1';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #add.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerAddUInt64Ref [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: UInt64 ref) => UInt64 := x + 1';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isLoad.
	self assert: function basicBlocks second firstInstruction nextInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction nextInstruction operation equals: #add.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerAddUInt64Ref2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: UInt64 ref) => UInt64 := 1 + x';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isLoad.
	self assert: function basicBlocks second firstInstruction nextInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction nextInstruction operation equals: #add.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerAddUInt64_2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: UInt64) => UInt64 := 1 + x';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #add.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerBitAnd [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x & 1';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #bitand.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerBitAnd2 [ 
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x bitAnd: 1';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #bitand.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerBitCast [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Int32) => UInt32 := x castTo: UInt32';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBitCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerBitInvert [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := ~x';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isUnaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #not.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerBitInvert2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x bitInvert';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isUnaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #not.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerBitOr [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x | 1';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #bitor.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerBitOr2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x bitOr: 1';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #bitor.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerBitShiftLeft [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x << 3';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #shiftleft.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerBitShiftLeftCoercion [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: UInt64) => UInt64 := 1 << x';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #shiftleft.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerBitShiftRight [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x >> 3';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #shiftrightarithmetic.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerBitXor [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x ^ 1';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #bitxor.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerBitXor2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x bitXor: 1';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #bitxor.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerDivide [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x / 2';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #div.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerDivideUnsigned [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: UInt32) => UInt32 := x / 2';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #udiv.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerEmptySelectCase [
	| function |
	self
		evaluateSysmelSource: 'function selectCaseTest externC(value: Int32) => Void
			:= value selectCase: #{
}';
		generateSSAModule.

	function := ssaModule globalNamed: #selectCaseTest.
	self assert: function asFullSExpressionForTesting equals: #(
function selectCaseTest cdecl void
arguments ((value i32 ()))
literals ()
blocks (
    (()
        (nil jump void () () (block 2 body))
    )
    (()
        (nil call void () ((global 1 __sysmel_patternMatchingFailureRaise)))
        (nil unreachable void () ())
    )
)
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerEquality [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32, y: Int32) => Boolean8 := x = y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ieq.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerEquality2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32, y: Int32) => Boolean8 := x == y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ieq.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerEquality3 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32 const, y: Int32) => Boolean8 := x = y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ieq.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerEquality4 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32 const, y: Int32) => Boolean8 := x == y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ieq.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerEquality5 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32 const ref, y: Int32) => Boolean8 := x = y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isLoad.
	self assert: function basicBlocks second firstInstruction nextNonDebugInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction nextNonDebugInstruction operation equals: #ieq.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerEquality6 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32 const ref, y: Int32) => Boolean8 := x == y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isLoad.
	self assert: function basicBlocks second firstInstruction nextNonDebugInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction nextNonDebugInstruction operation equals: #ieq.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerEquality7 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int16, y: Int32) => Boolean8 := x == y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isSignExtend.
	self assert: function basicBlocks second firstInstruction nextNonDebugInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction nextNonDebugInstruction operation equals: #ieq.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerEquality8 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32, y: Int16) => Boolean8 := x == y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isSignExtend.
	self assert: function basicBlocks second firstInstruction nextNonDebugInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction nextNonDebugInstruction operation equals: #ieq.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerGreater [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32, y: Int32) => Boolean8 := x > y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #igt.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerGreaterOrEqual [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32, y: Int32) => Boolean8 := x >= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ige.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerHighBit [ 
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x highBit';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isCall.
	self assert: function basicBlocks second firstInstruction nextNonDebugInstruction isBinaryOperation.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerLess [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32, y: Int32) => Boolean8 := x < y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ilt.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerLessOrEqual [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32, y: Int32) => Boolean8 := x <= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ile.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerLowBit [ 
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x lowBit';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isUnaryOperation.
	self assert: function basicBlocks second firstInstruction nextNonDebugInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction nextNonDebugInstruction nextNonDebugInstruction isCall.
	self assert: function basicBlocks second firstInstruction nextNonDebugInstruction nextNonDebugInstruction nextNonDebugInstruction isBinaryOperation.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerMultiply [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x * 3';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #mul.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerMultiplyUnsigned [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: UInt32) => UInt32 := x * 3';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #mul.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerNegate [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := -x';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isUnaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #neg.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerNegate2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x negated';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isUnaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #neg.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerNotEquality [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32, y: Int32) => Boolean8 := x ~= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ine.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerNotEquality2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32, y: Int32) => Boolean8 := x ~~ y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ine.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerNotEquality3 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int16, y: Int32) => Boolean8 := x ~~ y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isSignExtend.
	self assert: function basicBlocks second firstInstruction nextNonDebugInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction nextNonDebugInstruction operation equals: #ine.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerNotEquality4 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32, y: Int16) => Boolean8 := x ~~ y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isSignExtend.
	self assert: function basicBlocks second firstInstruction nextNonDebugInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction nextNonDebugInstruction operation equals: #ine.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerRemainder [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x % 2';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #rem.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerRemainderUnsigned [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: UInt32) => UInt32 := x % 2';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #urem.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerSelectCase [
	| function |
	self
		evaluateSysmelSource: 'function selectCaseTest externC(value: Int32) => Float32
			:= value selectCase: #{
	0: 0.0.
	1: 1.0.
	2: 2.0.
	3: 3.0.
	4: 4.0.
	let v : (v castTo: Float32) * 2.0
}';
		generateSSAModule.

	function := ssaModule globalNamed: #selectCaseTest.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 9.
	self assert: function basicBlocks second firstInstruction isSwitch.
	self assert: function basicBlocks last lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerSelectSingleCase [
	| function |
	self
		evaluateSysmelSource: 'function selectCaseTest externC(value: Int32) => Float32
			:= value selectCase: #{
	0: value.
}';
		generateSSAModule.

	function := ssaModule globalNamed: #selectCaseTest.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 5.
	self assert: function basicBlocks last lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerSelectSingleCase2 [
	| function |
	self
		evaluateSysmelSource: 'function selectCaseTest externC(value: Int32 ref) => Float32
			:= value selectCase: #{
	0: 42.0.
}';
		generateSSAModule.

	function := ssaModule globalNamed: #selectCaseTest.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 5.
	self assert: function basicBlocks last lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerSignExtension [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Int8) => Int32 := x';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isSignExtend.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerSubtract [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x - 1';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #sub.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerSubtractUInt64 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: UInt64) => UInt64 := x - 20';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #sub.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerThreeWayComparison [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32, y: Int32) => Int32 := x <=> y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function asFullSExpressionForTesting equals: #(
    function op cdecl i32
        arguments ((x i32 ()) (y i32 ()))
        literals ()
        blocks
        (
            (()
                (nil jump void () () (block 2 body))
            )
            (()
                (nil sub i32 () ((local 0 x) (local 1 y)))
                (nil return void () ((local 3 nil)))
            )
        )
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerToBoolean [
	| function |
	self
		evaluateMiniObjectModelRuntime;
		evaluateSysmelSource: 'function cast externC(x: Int32) => Boolean8 := x castTo: Boolean8';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerToDynamicObject [
	| function |
	self
		evaluateMiniObjectModelRuntime;
		evaluateSysmelSource: 'function cast externC(x: Int32) => ProtoObject := x';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isIntToDynamicObjectCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerToFloatCast [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Int32) => Float32 := x';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isIntToFloatCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerToPointerCast [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: IntPointer) => Void pointer
			:= x reinterpretCastTo: Void pointer';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isIntToPointerCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerToPointerCast2 [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: UIntPointer) => Void pointer
			:= x reinterpretCastTo: Void pointer';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isIntToPointerCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerTruncate [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Int32) => Int8 := x castTo: Int8';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isTruncate.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerUnsignedBitShiftRight [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: UInt32) => UInt32 := x >> 3';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #shiftright.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerUnsignedGreater [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: UInt32, y: UInt32) => Boolean8 := x > y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ugt.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerUnsignedGreaterOrEqual [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: UInt32, y: UInt32) => Boolean8 := x >= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #uge.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerUnsignedLess [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: UInt32, y: UInt32) => Boolean8 := x < y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ult.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerUnsignedLessOrEqual [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: UInt32, y: UInt32) => Boolean8 := x <= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ule.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerUnsignedThreeWayComparison [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: UInt32, y: UInt32) => Int32 := x <=> y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function asFullSExpressionForTesting equals: #(
    function op cdecl i32
        arguments ((x u32 ()) (y u32 ()))
        literals ()
        blocks
        (
            (()
                (nil jump void () () (block 2 body))
            )
            (()
                (nil sub u32 () ((local 0 x) (local 1 y)))
					 (nil bitcast i32 () ((local 3 nil)))
                (nil return void () ((local 4 nil)))
            )
        )
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerZeroExtension [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: UInt8) => UInt32 := x';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isZeroExtend.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testLetRef [
	| function |
	self
		evaluateSysmelSource: '
global someCount mutable type: UInt32 := 0.

function increase externC() => Void := {
	let count ref := someCount.
	count := count + 1
}';
		generateSSAModule.

	function := ssaModule globalNamed: #increase.
	self assert: function isFunction.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (jump))
		(tryScope (
			load
			add
			store
			returnVoid
		))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testLetZeroCFunction [
	| function |
	self
		evaluateSysmelSource: 'function zero externC() => Int32 := {
			let x := 0.
			x
		}';
		generateSSAModule.

	function := ssaModule globalNamed: #zero.
	self assert: function isFunction.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (jump))
		(tryScope (return))
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testLetZeroMutableAssignmentCFunction [
	| function |
	self
		evaluateSysmelSource: 'function zero externC() => Int32 := {
			let x mutable := 42.
			x := 0.
			x
		}';
		generateSSAModule.

	function := ssaModule globalNamed: #zero.
	self assert: function isFunction.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (alloca jump))
		(body (jump))
		(tryScope (store store load return))
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testLetZeroMutableCFunction [
	| function |
	self
		evaluateSysmelSource: 'function zero externC() => Int32 := {
			let x mutable := 0.
			x
		}';
		generateSSAModule.

	function := ssaModule globalNamed: #zero.
	self assert: function isFunction.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (alloca jump))
		(body (jump))
		(tryScope (store load return))
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testMainPutsCFunction [
	| function |
	self
		evaluateSysmelSource: '
	function puts externC(value: UInt8 const pointer) => Int32.

	function main externC() => Int32 := {
		puts("Hello World").
		0
	}.
';
		generateSSAModule.

	function := ssaModule globalNamed: #main.
	self assert: function isFunction.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (jump))
		(tryScope (call return))
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testMainPutsThenReturnCFunction [
	| function |
	self
		evaluateSysmelSource: '
	function puts externC(value: UInt8 const pointer) => Int32.

	function main externC() => Int32 := {
		puts("Hello World").
		return: 0
	}.
';
		generateSSAModule.

	function := ssaModule globalNamed: #main.
	self assert: function isFunction.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (jump))
		(tryScope (call return))
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testMinCFunction [
	| function |
	self
		evaluateSysmelSource: 'function min externC(a: Int32, b: Int32) => Int32
			:= if: a <= b then: a else: b';
		generateSSAModule.

	function := ssaModule globalNamed: #min.
	function applyDominanceTopoSort.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 5.
	self assert: function basicBlocks second firstInstruction isBinaryComparison.
	self assert: function basicBlocks last firstInstruction isPhi.
	self assert: function basicBlocks last lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testModuleLevelInlineAssembly [
	| fragment |
	self
		evaluateSysmelSource: '
inlineAssembly: "nop" architecture: #x86 dialect: #gas
';
		generateSSAModule.

	self assert: ssaModule inlineAssemblyFragments size equals: 1.
	fragment := ssaModule  inlineAssemblyFragments first.
	self assert: fragment architecture equals: #x86.
	self assert: fragment language equals: #gas.
	self assert: fragment source equals: 'nop'.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testMultipleChainsFunction [
	| function |
	self
		evaluateSysmelSource: 'function zero externC() => Int32
			:= {
			1 + 1; yourself.
			0 yourself; yourself.
		}';
		generateSSAModule.

	function := ssaModule globalNamed: #zero.
	self assert: function isFunction.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (alloca alloca jump))
		(body (jump))
		(tryScope (store load add store load return))
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testNoReturn [
	| function |
	self
		evaluateSysmelSource: '
function abort noReturn externC() => Void.

function callAbort externC() => Int32 := {
	abort()
}.

';
		generateSSAModule.

	function := ssaModule globalNamed: #callAbort.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body #(jump))
		(tryScope #(call unreachable))
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testNonPODAggregatePassing [
	| function |
	self
		evaluateSysmelSource: '
class Aggregate definition: {
	method initialize => Void.
	method finalize => Void.
}.

function calledWithAggregate externC(arg: Aggregate) => Void := {}.
function callWithAggregate externC() => Void
	:= calledWithAggregate(Aggregate newValue).
';
		generateSSAModule.

	function := ssaModule globalNamed: #callWithAggregate.
	self assert: function isFunction.
	
	self assert: function allInstructionsMnemonics equals: #(
		#(#entry #(#alloca #alloca #alloca #alloca #jump))
		#(#body #(#store #store #call #store #call #load #branch))
		#(#tryUnwind #(#landingpath #extractValue #store #extractValue #store #jump))
		#(#implicitCleanUpAction #(#call #jump))
		#(#implicitCleanUpMerge #(#returnVoid))
		#(#unwindCleanUp #(#load #branch))
		#(#forbiddenExceptionTarget #(#landingpath #extractValue #call #unreachable))
		#(#implicitCleanUpAction #(#call #jump))
		#(#implicitCleanUpMerge #(#load #insertValue #load #insertValue #resumeException))
	).
	
	function := ssaModule globalNamed: #calledWithAggregate.
	self assert: function isFunction.
	
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (jump))
		(#tryScope (returnVoid))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testNonPODAggregatePassingNoExceptions [
	| function |
	self
		disableExceptions;
		evaluateSysmelSource: '
class Aggregate definition: {
	method initialize => Void.
	method finalize => Void.
}.

function calledWithAggregate externC(arg: Aggregate) => Void := {}.
function callWithAggregate externC() => Void
	:= calledWithAggregate(Aggregate newValue).
';
		generateSSAModule.

	function := ssaModule globalNamed: #callWithAggregate.
	self assert: function isFunction.
	
	self assert: function allInstructionsMnemonics equals: #(
		#(#entry #(#alloca #alloca #jump))
		#(#body #(#store #store #call #store #call #load #branch))
		#(#implicitCleanUpAction #(#call #jump))
		#(#implicitCleanUpMerge #(#returnVoid))
	).
	
	function := ssaModule globalNamed: #calledWithAggregate.
	self assert: function isFunction.
	
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (returnVoid))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testNonPODAggregateReturn [
	| function |
	self
		evaluateSysmelSource: '
class Aggregate definition: {
	method initialize => Void.
	method finalize => Void.
}.

function makeAggregate externC() => Aggregate
	:= Aggregate newValue.

function caller externC() => Void
	:= makeAggregate().
'
;
		generateSSAModule.

	function := ssaModule globalNamed: #makeAggregate.
	self assert: function isFunction.
	self assert: function arguments first isStructReturnPointer.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (store call returnVoid))
	).
	
	function := ssaModule globalNamed: #caller.
	self assert: function isFunction.
	self assert: function allInstructionsMnemonics equals: #(
		#(#entry #(#alloca #alloca #alloca #alloca #jump))
		#(#body #(#store #call #store #load #branch))
		#(#tryUnwind #(#landingpath #extractValue #store #extractValue #store #jump))
		#(#implicitCleanUpAction #(#call #jump))
		#(#implicitCleanUpMerge #(#returnVoid))
		#(#unwindCleanUp #(#load #branch))
		#(#forbiddenExceptionTarget #(#landingpath #extractValue #call #unreachable))
		#(#implicitCleanUpAction #(#call #jump))
		#(#implicitCleanUpMerge #(#load #insertValue #load #insertValue #resumeException))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testNonPODAggregateReturn2 [
	| function |
	self
		evaluateSysmelSource: '
class Aggregate definition: { 
	method initialize => Void.
	method finalize => Void.
}.

function makeAggregate externC() => Aggregate := {
	return: Aggregate newValue.
}.

function caller externC() => Void
	:= makeAggregate().
';
		generateSSAModule.

	function := ssaModule globalNamed: #makeAggregate.
	self assert: function isFunction.
	self assert: function arguments first isStructReturnPointer.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (jump))
		(tryScope(store call returnVoid))
	).
	
	function := ssaModule globalNamed: #caller.
	self assert: function isFunction.
	self assert: function allInstructionsMnemonics equals: #(
		#(#entry #(#alloca #alloca #alloca #alloca #jump))
		#(#body #(#store #call #store #load #branch))
		#(#tryUnwind #(#landingpath #extractValue #store #extractValue #store #jump))
		#(#implicitCleanUpAction #(#call #jump))
		#(#implicitCleanUpMerge #(#returnVoid))
		#(#unwindCleanUp #(#load #branch))
		#(#forbiddenExceptionTarget #(#landingpath #extractValue #call #unreachable))
		#(#implicitCleanUpAction #(#call #jump))
		#(#implicitCleanUpMerge #(#load #insertValue #load #insertValue #resumeException))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testNonPODAggregateReturn2NoExceptions [
	| function |
	self
		disableExceptions;
		evaluateSysmelSource: '
class Aggregate definition: { 
	method initialize => Void.
	method finalize => Void.
}.

function makeAggregate externC() => Aggregate := {
	return: Aggregate newValue.
}.

function caller externC() => Void
	:= makeAggregate().
';
		generateSSAModule.

	function := ssaModule globalNamed: #makeAggregate.
	self assert: function isFunction.
	self assert: function arguments first isStructReturnPointer.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (store call returnVoid))
	).
	
	function := ssaModule globalNamed: #caller.
	self assert: function isFunction.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (alloca alloca jump))
		(body (store call store load branch))
		(implicitCleanUpAction (call jump))
		(implicitCleanUpMerge (returnVoid))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testNonPODAggregateReturn3 [
	| function |
	self
		evaluateSysmelSource: '
class Aggregate definition: { 
	method initialize => Void.
	method finalize => Void.
	
	meta method make => SelfType
		:= SelfType newValue.
}.

function caller externC() => Void
	:= Aggregate make.
'
;
		generateSSAModule.

	function := ssaModule globalNamed: #'_ZN10TestModule9Aggregate8..meta..5.makeENS1_E'.
	self assert: function isFunction.
	self assert: function arguments first isStructReturnPointer.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (store call returnVoid))
	).
	
	function := ssaModule globalNamed: #caller.
	self assert: function isFunction.
	self assert: function allInstructionsMnemonics equals: #(
		#(#entry #(#alloca #alloca #alloca #alloca #jump))
		#(#body #(#store #call #store #load #branch))
		#(#tryUnwind #(#landingpath #extractValue #store #extractValue #store #jump))
		#(#implicitCleanUpAction #(#call #jump))
		#(#implicitCleanUpMerge #(#returnVoid))
		#(#unwindCleanUp #(#load #branch))
		#(#forbiddenExceptionTarget #(#landingpath #extractValue #call #unreachable))
		#(#implicitCleanUpAction #(#call #jump))
		#(#implicitCleanUpMerge #(#load #insertValue #load #insertValue #resumeException))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testNonPODAggregateReturn3NoExceptions [
	| function |
	self
		disableExceptions;
		evaluateSysmelSource: '
class Aggregate definition: { 
	method initialize => Void.
	method finalize => Void.
	
	meta method make => SelfType
		:= SelfType newValue.
}.

function caller externC() => Void
	:= Aggregate make.
'
;
		generateSSAModule.

	function := ssaModule globalNamed: #'_ZN10TestModule9Aggregate8..meta..5.makeENS1_E'.
	self assert: function isFunction.
	self assert: function arguments first isStructReturnPointer.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (store call returnVoid))
	).
	
	function := ssaModule globalNamed: #caller.
	self assert: function isFunction.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (alloca alloca jump))
		(body (store call store load branch))
		(implicitCleanUpAction (call jump))
		(implicitCleanUpMerge (returnVoid))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testNonPODAggregateReturn4 [
	| function |
	self
		evaluateSysmelSource: '
class Aggregate definition: {
	method initialize => Void.
	method finalize => Void.
	
	method setFlag => Void.
	
	meta method make => SelfType
		:= SelfType newValue setFlag; yourself.
}.

function caller externC() => Void
	:= Aggregate make.
'
;
		generateSSAModule.

	function := ssaModule globalNamed: #'_ZN10TestModule9Aggregate8..meta..5.makeENS1_E'.
	self assert: function isFunction.
	self assert: function arguments first isStructReturnPointer.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (store call call returnVoid))
	).
	
	function := ssaModule globalNamed: #caller.
	self assert: function isFunction.
	self assert: function allInstructionsMnemonics equals: #(
		#(#entry #(#alloca #alloca #alloca #alloca #jump))
		#(#body #(#store #call #store #load #branch))
		#(#tryUnwind #(#landingpath #extractValue #store #extractValue #store #jump))
		#(#implicitCleanUpAction #(#call #jump))
		#(#implicitCleanUpMerge #(#returnVoid))
		#(#unwindCleanUp #(#load #branch))
		#(#forbiddenExceptionTarget #(#landingpath #extractValue #call #unreachable))
		#(#implicitCleanUpAction #(#call #jump))
		#(#implicitCleanUpMerge #(#load #insertValue #load #insertValue #resumeException))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testNonPODAggregateReturn4NoExceptions [
	| function |
	self
		disableExceptions;
		evaluateSysmelSource: '
class Aggregate definition: {
	method initialize => Void.
	method finalize => Void.
	
	method setFlag => Void.
	
	meta method make => SelfType
		:= SelfType newValue setFlag; yourself.
}.

function caller externC() => Void
	:= Aggregate make.
'
;
		generateSSAModule.

	function := ssaModule globalNamed: #'_ZN10TestModule9Aggregate8..meta..5.makeENS1_E'.
	self assert: function isFunction.
	self assert: function arguments first isStructReturnPointer.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (store call call returnVoid))
	).
	
	function := ssaModule globalNamed: #caller.
	self assert: function isFunction.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (alloca alloca jump))
		(body (store call store load branch))
		(implicitCleanUpAction (call jump))
		(implicitCleanUpMerge (returnVoid))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testNonPODAggregateReturn5 [
	| function |
	self
		evaluateSysmelSource: '
class Aggregate definition: { 
	method initialize => Void.
	method finalize => Void.
	
	meta method make => SelfType
		:= SelfType newValue.
}.

function caller externC() => Aggregate
	:= Aggregate make.
'
;
		generateSSAModule.

	function := ssaModule globalNamed: #'_ZN10TestModule9Aggregate8..meta..5.makeENS1_E'.
	self assert: function isFunction.
	self assert: function arguments first isStructReturnPointer.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (store call returnVoid))
	).
	
	function := ssaModule globalNamed: #caller.
	self assert: function isFunction.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (call returnVoid))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testNonPODAggregateReturn5NoExceptions [
	| function |
	self
		disableExceptions;
		evaluateSysmelSource: '
class Aggregate definition: { 
	method initialize => Void.
	method finalize => Void.
	
	meta method make => SelfType
		:= SelfType newValue.
}.

function caller externC() => Aggregate
	:= Aggregate make.
'
;
		generateSSAModule.

	function := ssaModule globalNamed: #'_ZN10TestModule9Aggregate8..meta..5.makeENS1_E'.
	self assert: function isFunction.
	self assert: function arguments first isStructReturnPointer.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (store call returnVoid))
	).
	
	function := ssaModule globalNamed: #caller.
	self assert: function isFunction.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (call returnVoid))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testNonPODAggregateReturn6 [
	| function |
	self
		evaluateSysmelSource: '
class Aggregate definition: { 
	method initialize => Void.
	method finalize => Void.
}.

function makeAggregate externC() => Aggregate := {
	return: Aggregate newValue.
}.

function caller externC() => Aggregate
	:= makeAggregate().
';
		generateSSAModule.

	function := ssaModule globalNamed: #makeAggregate.
	self assert: function isFunction.
	self assert: function arguments first isStructReturnPointer.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (jump))
		(tryScope (store call returnVoid))
	).
	
	function := ssaModule globalNamed: #caller.
	self assert: function isFunction.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (call returnVoid))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testNonPODAggregateReturnNoExceptions [
	| function |
	self
		disableExceptions;
		evaluateSysmelSource: '
class Aggregate definition: {
	method initialize => Void.
	method finalize => Void.
}.

function makeAggregate externC() => Aggregate
	:= Aggregate newValue.

function caller externC() => Void
	:= makeAggregate().
'
;
		generateSSAModule.

	function := ssaModule globalNamed: #makeAggregate.
	self assert: function isFunction.
	self assert: function arguments first isStructReturnPointer.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (store call returnVoid))
	).
	
	function := ssaModule globalNamed: #caller.
	self assert: function isFunction.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (alloca alloca jump))
		(body (store call store load branch))
		(implicitCleanUpAction (call jump))
		(implicitCleanUpMerge (returnVoid))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testOutputChannelSendInteger [
	| function |
	self
		evaluateMiniObjectModelRuntime;
		evaluateSysmelSource: 'function send externC(outputChannel: Int32 outputChannel, message: Int32) => Void
			:= outputChannel send: message';
		generateSSAModule.

	function := ssaModule globalNamed: #send.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isMessageSend.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testOverloadedCall [
	| function call |
	self
		evaluateSysmelSource: '
function called(x: Float32) => Float32
	:= x + 2.
	
function called(x: Int32) => Int32
	:= x + 1.
	
function call externC(x: Int32) => Int32
	:= called(x).';
		generateSSAModule.

	function := ssaModule globalNamed: #call.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	call := function basicBlocks second firstInstruction.
	self assert: call isCall.
	self assert: call functionValue name equals: #_ZN10TestModule6calledEi.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testOverloadedCallWithLiteral [
	| function call |
	self
		evaluateSysmelSource: '
function called(x: Float32) => Float32
	:= x + 2.
	
function called(x: Int32) => Int32
	:= x + 1.
	
function call externC() => Int32
	:= called(1).';
		generateSSAModule.

	function := ssaModule globalNamed: #call.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	call := function basicBlocks second firstInstruction.
	self assert: call isCall.
	self assert: call functionValue name equals: #_ZN10TestModule6calledEi.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testOverloadedMessageSend [
	| function call |
	self
		evaluateSysmelSource: '
struct TestStruct definition: { 
	method addTo: (x: Float32) ::=> Float32
		:= x + 2.

	method addTo: (x: Int32) ::=> Int32
		:= x + 2.
}.

function call externC(x: Int32) => Int32
	:= TestStruct newValue addTo: x.';
		generateSSAModule.

	function := ssaModule globalNamed: #call.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isStore.
	call := function basicBlocks second firstInstruction nextInstruction.
	self assert: call isCall.
	self assert: call functionValue name equals:  #'_ZN10TestModule10TestStruct7.addTo.ERNS0_Ei'
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testParameterConstRef [
	| function |
	self
		evaluateSysmelSource: '

function called externC(x: Int32 const ref) => Void.

function caller externC(x: Int32) => Void := called(x).
';
		generateSSAModule.

	function := ssaModule globalNamed: #caller.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (alloca jump))
		(body (
			store
			bitcast "Address space cast"
			call
			returnVoid
		))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPlusOne [
	| function |
	self
		evaluateSysmelSource: 'function plusOne externC(x: Int32) => Int32
			:= x + 1';
		generateSSAModule.

	function := ssaModule globalNamed: #plusOne.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks last firstInstruction isBinaryOperation.
	self assert: function basicBlocks last lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerAsReference [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Float32 pointer) => Float32 ref := x _';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerAsReference2 [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Float32 pointer) => Float32 ref := x value';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerAsReference3 [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Float32 pointer ref) => Float32 ref := x value';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isLoad.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerEquality [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32 pointer, y: Int32 pointer) => Boolean8 := x == y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ieq.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerEquality2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32 pointer, y: Int32 pointer) => Boolean8 := x = y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ieq.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerGreater [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32 pointer, y: Int32 pointer) => Boolean8 := x > y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ugt.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerGreaterOrEqual [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32 pointer, y: Int32 pointer) => Boolean8 := x >= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #uge.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerLess [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32 pointer, y: Int32 pointer) => Boolean8 := x < y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ult.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerLessOrEqual [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32 pointer, y: Int32 pointer) => Boolean8 := x <= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ule.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerNotEquality [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32 pointer, y: Int32 pointer) => Boolean8 := x ~~ y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ine.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerNotEquality2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32 pointer, y: Int32 pointer) => Boolean8 := x ~= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ine.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerNull [
	| function |
	self
		evaluateSysmelSource: 'function returnNull externC() => Int32 pointer := nil';
		generateSSAModule.

	function := ssaModule globalNamed: #returnNull.
	self assert: function isFunction.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (return))
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerNull2 [
	| function |
	self
		evaluateSysmelSource: '
		function sideEffect() => Void.
		function returnNull externC() => Int32 pointer := {sideEffect() . nil}';
		generateSSAModule.

	function := ssaModule globalNamed: #returnNull.
	self assert: function isFunction.self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (jump))
		(tryScope (call return))
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerReinterpretCast [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: UInt32 pointer) => Void pointer
			:= x';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBitCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerReinterpretCast2 [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: UInt32 pointer) => Void const pointer
			:= x';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBitCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerReinterpretCast3 [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Void const pointer) => UInt32 const pointer
			:= x castTo: UInt32 const pointer';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBitCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerReinterpretCast4 [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: UInt8 const pointer) => UInt32 const pointer
			:= x reinterpretCastTo: UInt32 const pointer';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBitCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerReinterpretCast5 [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: UInt8 const pointer ref) => UInt32 const pointer
			:= x reinterpretCastTo: UInt32 const pointer';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isLoad.
	self assert: function basicBlocks second firstInstruction nextInstruction isBitCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerToConstPointer [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Void pointer) => Void const pointer := x';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerToIntegerCast [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Void pointer) => IntPointer
			:= x reinterpretCastTo: IntPointer';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isPointerToIntCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerToIntegerCast2 [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Void pointer) => UIntPointer
			:= x reinterpretCastTo: UIntPointer';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isPointerToIntCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerValueMessageChain [
	| function instructions |
	self
		evaluateSysmelSource: '

struct Node definition: { 
	field previous public type: Node pointer.
	field next public type: Node pointer.
}.

function setPreviousAndNext externC(node: Node pointer, previous: Node pointer, next: Node pointer) => Void
	:= node _
		previous: previous;
		next: next.
';
		generateSSAModule.

	function := ssaModule globalNamed: #setPreviousAndNext.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	
	instructions := function basicBlocks second allInstructions.
	self assert: instructions first isGetElementPointer.
	self assert: instructions second isStore.
	self assert: instructions third isGetElementPointer.
	self assert: instructions fourth isStore.
	self assert: instructions fifth isReturnVoid.

]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testRecursiveStructure [
	| function structureType |
	self
		evaluateSysmelSource: '
struct TreeNode definition: {
	public field left type: TreeNode pointer.
	public field right type: TreeNode pointer.
	
	method size => Int32 := { 
		if: self address == nil
			then: (0)
			else: (left _ size + right _ size)
	}.
}.';
		generateSSAModule.

	function := ssaModule globalNamed: #'_ZN10TestModule8TreeNode5.sizeERNS0_E'.
	structureType := function arguments first type baseType.
	self assert: structureType isStructureType.
	self assert: structureType name equals: #'struct.TestModule::TreeNode'.

]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testRecursiveTemplateStructure [
	| function structureType |
	self
		evaluateSysmelSource: '
template TreeNode(KT: Type )
	:= struct definition: {
	compileTime constant KeyType := KT.

	public field left type: SelfType pointer.
	public field right type: SelfType pointer.
	public field key type: KeyType.
	
	method size => Int32 := { 
		if: self address == nil
			then: (0)
			else: (left _ size + right _ size)
	}.
}.

function nullTree externC() => TreeNode(Int32) pointer
	:= nil.
'
;
		generateSSAModule.

	function := ssaModule globalNamed: #nullTree.
	structureType := function functionType returnType baseType.
	self assert: structureType isStructureType.
	self assert: structureType name isNotNil.
	self deny: structureType name equals: #_S8TreeNode.

]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testRefCountedMethods [
	| function |
	self
		evaluateIntrusivePointerClass;
		evaluateSysmelSource: 'RefCountedPtr';
		generateSSAModule.

	function := ssaModule globalNamed: #'_ZN10TestModule16IntrusivePointerINS_10RefCountedEE9.finalizeERNS1_E'.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (jump))
		(tryScope (getElementPointer load ine branch))
		(ifThen (jump))
		(ifMerge (returnVoid))
		(tryScope (getElementPointer load call jump))
	).

	function := ssaModule globalNamed: #'_ZN10TestModule16IntrusivePointerINS_10RefCountedEE16.initializeWith.ERNS1_EPNS2_E'.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (jump))
		(tryScope (getElementPointer store returnVoid))
	).

	function := ssaModule globalNamed: #'_ZN10TestModule16IntrusivePointerINS_10RefCountedEE23.initializeCopyingFrom.ERNS1_ERKNS1_E'.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (jump))
		(tryScope (getElementPointer load getElementPointer store getElementPointer load #ine branch))
		(ifThen (jump))
		(ifMerge (returnVoid))
		(tryScope (getElementPointer load call jump))
	).
	
	function := ssaModule globalNamed: #'_ZN10TestModule16IntrusivePointerINS_10RefCountedEE22.initializeMovingFrom.ERNS1_EONS1_E'.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (jump))
		(tryScope (getElementPointer load getElementPointer store getElementPointer store returnVoid))
	).
	
	function := ssaModule globalNamed: #'_ZN10TestModule16IntrusivePointerINS_10RefCountedEE13.assignValue.ERNS1_ERKNS1_E'.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (jump))
		(tryScope (getElementPointer load ine branch))
		(ifThen (jump))
		(ifMerge (getElementPointer load ine branch))
		(tryScope (call jump))
		(ifThen (jump))
		(ifMerge (getElementPointer store return))
		(tryScope (getElementPointer load call jump))
	).
	
	function := ssaModule globalNamed: #'_ZN10TestModule16IntrusivePointerINS_10RefCountedEE13.assignValue.ERNS1_EONS1_E'.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (jump))
		(tryScope (getElementPointer load getElementPointer store getElementPointer load ine branch))
		(ifThen (jump))
		(ifMerge (getElementPointer store return))
		(tryScope (getElementPointer load call jump))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testRefCountedMethodsNoExceptions [
	| function |
	self
		disableExceptions;
		evaluateIntrusivePointerClass;
		evaluateSysmelSource: 'RefCountedPtr';
		generateSSAModule.

	function := ssaModule globalNamed: #'_ZN10TestModule16IntrusivePointerINS_10RefCountedEE9.finalizeERNS1_E'.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (getElementPointer load ine branch))
		(ifThen (getElementPointer load call jump))
		(ifMerge (returnVoid))
	).

	function := ssaModule globalNamed: #'_ZN10TestModule16IntrusivePointerINS_10RefCountedEE16.initializeWith.ERNS1_EPNS2_E'.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (getElementPointer store returnVoid))
	).

	function := ssaModule globalNamed: #'_ZN10TestModule16IntrusivePointerINS_10RefCountedEE23.initializeCopyingFrom.ERNS1_ERKNS1_E'.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (getElementPointer load getElementPointer store getElementPointer load ine branch))
		(ifThen (getElementPointer load call jump))
		(ifMerge (returnVoid))
	).
	
	function := ssaModule globalNamed: #'_ZN10TestModule16IntrusivePointerINS_10RefCountedEE22.initializeMovingFrom.ERNS1_EONS1_E'.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (getElementPointer load getElementPointer store getElementPointer store returnVoid))
	).
	
	function := ssaModule globalNamed: #'_ZN10TestModule16IntrusivePointerINS_10RefCountedEE13.assignValue.ERNS1_ERKNS1_E'.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (getElementPointer load ine branch))
		(ifThen (call jump))
		(ifMerge (getElementPointer load ine branch))
		(ifThen (getElementPointer load call jump))
		(ifMerge (getElementPointer store return))
	).
	
	function := ssaModule globalNamed: #'_ZN10TestModule16IntrusivePointerINS_10RefCountedEE13.assignValue.ERNS1_EONS1_E'.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (getElementPointer load getElementPointer store getElementPointer load ine branch))
		(ifThen (getElementPointer load call jump))
		(ifMerge (getElementPointer store return))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testRefCountedPointerAssign [
	| function |
	self
		evaluateIntrusivePointerClass;
		evaluateSysmelSource: '
function assignRefCountedPtr externC(variable: RefCountedPtr ref, value: RefCountedPtr ref) => Void
	:= variable := value.
';
		generateSSAModule.

	function := ssaModule globalNamed: #assignRefCountedPtr.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (call returnVoid))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testRefCountedPointerCreate [
	| function |
	self
		evaluateIntrusivePointerClass;
		evaluateSysmelSource: '
function makeRefCountedPtr externC(p: RefCounted pointer) => RefCountedPtr
	:= RefCountedPtr for: p.
';
		generateSSAModule.

	function := ssaModule globalNamed: #'_ZN10TestModule16IntrusivePointerINS_10RefCountedEE8..meta..5.for.ENS3_EPNS2_E'.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (store call returnVoid))
	).

	function := ssaModule globalNamed: #makeRefCountedPtr.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (call returnVoid))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testRefCountedPointerCreate2 [
	| function |
	self
		evaluateIntrusivePointerClass;
		evaluateSysmelSource: '
function makeRefCountedPtr externC(p: RefCounted pointer) => Void
	:= RefCountedPtr for: p.
';
		generateSSAModule.

	function := ssaModule globalNamed: #makeRefCountedPtr.
	self assert: function isFunction.
	self assert: function personalityFunction isNotNil.
	self assert: function allInstructionsMnemonics equals: #(
		#(#entry #(#alloca #alloca #alloca #alloca #jump))
		#(#body #(#store #call #store #load #branch))
		#(#tryUnwind #(#landingpath #extractValue #store #extractValue #store #jump))
		#(#implicitCleanUpAction #(#call #jump))
		#(#implicitCleanUpMerge #(#returnVoid))
		#(#unwindCleanUp #(#load #branch))
		#(#forbiddenExceptionTarget #(#landingpath #extractValue #call #unreachable))
		#(#implicitCleanUpAction #(#call #jump))
		#(#implicitCleanUpMerge #(#load #insertValue #load #insertValue #resumeException))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testRefCountedPointerCreate2NoExceptions [
	| function |
	self
		disableExceptions;
		evaluateIntrusivePointerClass;
		evaluateSysmelSource: '
function makeRefCountedPtr externC(p: RefCounted pointer) => Void
	:= RefCountedPtr for: p.
';
		generateSSAModule.

	function := ssaModule globalNamed: #makeRefCountedPtr.
	self assert: function isFunction.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (alloca alloca jump))
		(body (store call store load branch))
		(implicitCleanUpAction (call jump))
		(implicitCleanUpMerge (returnVoid))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testRefCountedPointerCreate3 [
	| function |
	self
		evaluateIntrusivePointerClass;
		evaluateSysmelSource: '
function makeRefCountedPtr externC(p: RefCounted pointer) => RefCountedPtr := {
	let temp := RefCountedPtr for: p.
	temp
}.
';
		generateSSAModule.

	function := ssaModule globalNamed: #makeRefCountedPtr.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function allInstructionsMnemonics equals: #(
		#(#entry #(#alloca #alloca #alloca #alloca #alloca #jump))
		#(#body #(#store #store #jump))
		#(#tryUnwind #(#landingpath #extractValue #store #extractValue #store #jump))
		#(#tryScope #(#call #store #store #call #store #load #branch))
		#(#implicitCleanUpAction #(#call #jump))
		#(#implicitCleanUpMerge #(#returnVoid))
		#(#unwindCleanUp #(#load #branch))
		#(#forbiddenExceptionTarget #(#landingpath #extractValue #call #unreachable))
		#(#implicitCleanUpAction #(#call #jump))
		#(#implicitCleanUpMerge #(#load #branch))
		#(#implicitCleanUpAction #(#call #jump))
		#(#implicitCleanUpMerge #(#load #insertValue #load #insertValue #resumeException))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testRefCountedPointerCreate3NoExceptions [
	| function |
	self
		disableExceptions;
		evaluateIntrusivePointerClass;
		evaluateSysmelSource: '
function makeRefCountedPtr externC(p: RefCounted pointer) => RefCountedPtr := {
	let temp := RefCountedPtr for: p.
	temp
}.
';
		generateSSAModule.

	function := ssaModule globalNamed: #makeRefCountedPtr.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (alloca alloca jump))
		(body (store call store store call load branch))
		(implicitCleanUpAction (call jump))
		(implicitCleanUpMerge (returnVoid))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testRefCountedPointerCreate4 [
	| function |
	self
		evaluateIntrusivePointerClass;
		evaluateSysmelSource: '
function makeRefCountedPtr externC(p: RefCounted pointer) => Void := {
	let temp := RefCountedPtr for: p.
	temp
}.
';
		generateSSAModule.

	function := ssaModule globalNamed: #makeRefCountedPtr.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (alloca alloca alloca alloca jump))
		(body (store jump))
		(tryUnwind (landingpath extractValue store extractValue store jump))
		(tryScope (call store load branch))
		(implicitCleanUpAction (call jump))
		(implicitCleanUpMerge (returnVoid))
		(unwindCleanUp (load branch))
		(forbiddenExceptionTarget (landingpath extractValue call unreachable))
		(implicitCleanUpAction (call jump))
		(implicitCleanUpMerge (load insertValue load insertValue resumeException))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testRefCountedPointerCreate4NoExceptions [
	| function |
	self
		disableExceptions;
		evaluateIntrusivePointerClass;
		evaluateSysmelSource: '
function makeRefCountedPtr externC(p: RefCounted pointer) => Void := {
	let temp := RefCountedPtr for: p.
	temp
}.
';
		generateSSAModule.

	function := ssaModule globalNamed: #makeRefCountedPtr.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (alloca alloca jump))
		(body (store call store load branch))
		(implicitCleanUpAction (call jump))
		(implicitCleanUpMerge (returnVoid))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testRefCountedPointerMove [
	| function |
	self
		evaluateIntrusivePointerClass;
		evaluateSysmelSource: '
function assignRefCountedPtr externC(variable: RefCountedPtr ref, value: RefCountedPtr tempRef) => Void
	:= variable := value.
';
		generateSSAModule.

	function := ssaModule globalNamed: #assignRefCountedPtr.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (call returnVoid))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testRefCountedPointerReset [
	| function |
	self
		evaluateIntrusivePointerClass;
		evaluateSysmelSource: '
function assignRefCountedPtr externC(variable: RefCountedPtr ref, value: RefCounted pointer) => Void
	:= variable reset: value.
';
		generateSSAModule.

	function := ssaModule globalNamed: #assignRefCountedPtr.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function allInstructionsMnemonics equals: #(
		(entry (jump))
		(body (call returnVoid))
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testReferenceAsPointer [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Float32 ref) => Float32 pointer := x address';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testReferenceAsTempReference [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Float32 ref) => Float32 tempRef := x asMoveReference';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testReferenceLoad [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Float32 ref) => Float32 := x';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isLoad.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testReferenceToConstReference [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Int32 ref) => Int32 const ref := x';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testSelect [
	| function |
	self
		evaluateSysmelSource: 
'function select externC(cond: Boolean8, left: UInt16, right: UInt16) => UInt16
	:= if: cond then: left else: right';
		generateSSAModule.

	function := ssaModule globalNamed: #select.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 5.
	self assert: function basicBlocks second firstInstruction isBranch.
	self assert: function basicBlocks fifth firstInstruction isPhi.
	self assert: function basicBlocks fifth lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testSelect2 [
	| function |
	self
		evaluateSysmelSource: 
'function select externC(cond: Boolean8, left: UInt16 ref, right: UInt16) => UInt16
	:= if: cond then: left else: right';
		generateSSAModule.

	function := ssaModule globalNamed: #select.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 5.
	self assert: function basicBlocks second firstInstruction isBranch.
	self assert: function basicBlocks fifth firstInstruction isPhi.
	self assert: function basicBlocks fifth lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testSelect3 [
	| function |
	self
		evaluateSysmelSource: 
'function select externC(cond: Boolean8, left: UInt16, right: UInt16 ref) => UInt16
	:= if: cond then: left else: right';
		generateSSAModule.

	function := ssaModule globalNamed: #select.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 5.
	self assert: function basicBlocks second firstInstruction isBranch.
	self assert: function basicBlocks fifth firstInstruction isPhi.
	self assert: function basicBlocks fifth lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testSeparateDeclarationDefinition [
	| function |
	self
		evaluateSysmelSource: '
function f externC() => Int32.
function f externC() => Int32 := 1.
';
		generateSSAModule.

	function := ssaModule globalNamed: #f.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testSeparateDeclarationDefinition2 [
	| function |
	self
		evaluateSysmelSource: '
function f externC() => Int32 := 1.
function f externC() => Int32.
';
		generateSSAModule.

	function := ssaModule globalNamed: #f.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testSeparateMessageDeclarationDefinition [
	| function |
	self
		evaluateSysmelSource: '
struct TestStruct definition: {
	method f => Int32.
	method f => Int32 := 1.

}.
';
		generateSSAModule.

	function := ssaModule globalNamed: #'_ZN10TestModule10TestStruct2.fERNS0_E'.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testSeparateMessageDeclarationDefinition2 [
	| function |
	self
		evaluateSysmelSource: '
struct TestStruct definition: {
	method f => Int32 := 1.
	method f => Int32.
}.
';
		generateSSAModule.

	function := ssaModule globalNamed: #'_ZN10TestModule10TestStruct2.fERNS0_E'.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testStaticGlobalVariableCapture [
	| function |
	self
		evaluateSysmelSource: '
let localGlobalVariable := 0.
function returnValue externC() => Int32 := localGlobalVariable';
		generateSSAModule.

	function := ssaModule globalNamed: #returnValue.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function functionType returnType isIntegerType.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isLoad.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testStaticGlobalVariableImmutableLoad [
	| global function |
	self
		evaluateSysmelSource: '
let testGlobal := 42.

function testFunction externC () => Int32 := testGlobal.
';
		generateSSAModule.

	function := ssaModule globalNamed: #testFunction.

	self assert: function isFunction.
	self assert: function basicBlocks second firstInstruction isLoad.

	global := function basicBlocks second firstInstruction variable.
	self assert: global isGlobalVariable.
	self assert: global readOnly.

]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testStaticGlobalVariableMutableCapture [
	| function |
	self
		evaluateSysmelSource: '
let localGlobalVariable mutable := 0.
function returnValue externC() => Int32 := localGlobalVariable';
		generateSSAModule.

	function := ssaModule globalNamed: #returnValue.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function functionType returnType isIntegerType.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isLoad.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testStaticGlobalVariableWithMinimalAlignment [
	| global function |
	self
		evaluateSysmelSource: '
let localGlobalVariable mutable alignment: 4096; type: UIntPointer.
function returnValue externC() => UIntPointer := localGlobalVariable';
		generateSSAModule.

	function := ssaModule globalNamed: #returnValue.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function functionType returnType isIntegerType.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isLoad.
	
	global := function basicBlocks second firstInstruction variable.
	self assert: global minimalAlignment equals: 4096.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testTempReferenceAsReference [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Float32 tempRef) => Float32 ref := x';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testTempReferenceLoad [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Float32 tempRef) => Float32 := x';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isLoad.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testTupleConstExtractElement [
	| function |
	self
		evaluateSysmelSource: '
function tupleFirst externC(argument: (Int32 -- Float32) const) => Int32
	:= argument[0].

';
		generateSSAModule.

	function := ssaModule globalNamed: #tupleFirst.
	self assert: function asFullSExpressionForTesting equals: #(
function tupleFirst cdecl i32
    arguments ((argument (struct nil generic (i32 f32) (element0 element1) ()) ()))
    literals ()
    blocks (
        (()
            (nil jump void () () (block 2 body))
        )
        (()
            (nil extractValue i32 () ((local 0 argument)) (0))
            (nil return void () ((local 2 nil)))
        )
    )
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testTupleConstRefExtractElement [
	| function |
	self
		evaluateSysmelSource: '
function tupleFirst externC(argument: (Int32 -- Float32) const ref) => Int32
	:= argument[0].

';
		generateSSAModule.

	function := ssaModule globalNamed: #tupleFirst.
	self assert: function asFullSExpressionForTesting equals: #(
function tupleFirst cdecl i32
    arguments ((argument (pointer (struct nil generic (i32 f32) (element0 element1) ()) generic) ()))
    literals ()
    blocks (
        (()
            (nil jump void () () (block 2 body))
        )
        (()
            (nil getElementPointer (pointer i32 generic) () ((local 0 argument) (const i32 0) (const i32 0)))
            (nil load i32 () ((local 2 nil)))
            (nil return void () ((local 3 nil)))
        )
    )
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testTupleExtractElement [
	| function |
	self
		evaluateSysmelSource: '
function tupleFirst externC(argument: (Int32 -- Float32)) => Int32
	:= argument[0].

';
		generateSSAModule.

	function := ssaModule globalNamed: #tupleFirst.
	self assert: function asFullSExpressionForTesting equals: #(
function tupleFirst cdecl i32
    arguments ((argument (struct nil generic (i32 f32) (element0 element1) ()) ()))
    literals ()
    blocks (
        (()
            (nil jump void () () (block 2 body))
        )
        (()
            (nil extractValue i32 () ((local 0 argument)) (0))
            (nil return void () ((local 2 nil)))
        )
    )
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testTupleExtractElement2 [
	| function |
	self
		evaluateSysmelSource: '
function tupleFirst externC(argument: (Int32 -- Float32)) => Float32
	:= argument[1].

';
		generateSSAModule.

	function := ssaModule globalNamed: #tupleFirst.
	self assert: function asFullSExpressionForTesting equals: #(
function tupleFirst cdecl f32
    arguments ((argument (struct nil generic (i32 f32) (element0 element1) ()) ()))
    literals ()
    blocks (
        (()
            (nil jump void () () (block 2 body))
        )
        (()
            (nil extractValue f32 () ((local 0 argument)) (1))
            (nil return void () ((local 2 nil)))
        )
    )
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testTupleExtractElement3 [
	| function |
	self
		evaluateSysmelSource: '
function tupleFirst externC(argument: (Int32 -- Float32)) => Int32
	:= argument at: 1.

';
		generateSSAModule.

	function := ssaModule globalNamed: #tupleFirst.
	self assert: function asFullSExpressionForTesting equals: #(
function tupleFirst cdecl i32
    arguments ((argument (struct nil generic (i32 f32) (element0 element1) ()) ()))
    literals ()
    blocks (
        (()
            (nil jump void () () (block 2 body))
        )
        (()
            (nil extractValue i32 () ((local 0 argument)) (0))
            (nil return void () ((local 2 nil)))
        )
    )
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testTupleExtractElement4 [
	| function |
	self
		evaluateSysmelSource: '
function tupleFirst externC(argument: (Int32 -- Float32)) => Float32
	:= argument at: 2.

';
		generateSSAModule.

	function := ssaModule globalNamed: #tupleFirst.
	self assert: function asFullSExpressionForTesting equals: #(
function tupleFirst cdecl f32
    arguments ((argument (struct nil generic (i32 f32) (element0 element1) ()) ()))
    literals ()
    blocks (
        (()
            (nil jump void () () (block 2 body))
        )
        (()
            (nil extractValue f32 () ((local 0 argument)) (1))
            (nil return void () ((local 2 nil)))
        )
    )
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testTupleParameter [
	| function |
	self
		evaluateSysmelSource: '
function called externC(tuple: (Int32 -- Float32)) => Void.

function callWithTuple externC() => Void := {
	called((1, 42.0))
}.

';
		generateSSAModule.

	function := ssaModule globalNamed: #callWithTuple.
	self assert: function allInstructionsMnemonics equals: #(
		#(#entry #(#jump))
		#(#body #(#jump))
		#(#tryScope #(#insertValue #insertValue #call #returnVoid))
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testTupleRefExtractElement [
	| function |
	self
		evaluateSysmelSource: '
function tupleFirst externC(argument: (Int32 -- Float32) ref) => Int32
	:= argument[0].

';
		generateSSAModule.

	function := ssaModule globalNamed: #tupleFirst.
	self assert: function asFullSExpressionForTesting equals: #(
function tupleFirst cdecl i32
    arguments ((argument (pointer (struct nil generic (i32 f32) (element0 element1) ()) generic) ()))
    literals ()
    blocks (
        (()
            (nil jump void () () (block 2 body))
        )
        (()
            (nil getElementPointer (pointer i32 generic) () ((local 0 argument) (const i32 0) (const i32 0)))
            (nil load i32 () ((local 2 nil)))
            (nil return void () ((local 3 nil)))
        )
    )
	)
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testVariantDefinitionFragment [
	self
		evaluateSysmelSource: '
(Int32 | Float32 | Float64) definition: {
	method plusOne => SelfType := self + 1
}.
';
		generateSSAModule.

	self assert: (ssaModule globalNamed: #'_ZN7Float328.plusOneEf') isNotNil.
	self assert: (ssaModule globalNamed: #'_ZN5Int328.plusOneEi') isNotNil.
	self assert: (ssaModule globalNamed: #'_ZN7Float648.plusOneEd') isNotNil.

]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testZeroCFunction [
	| function |
	self
		evaluateSysmelSource: 'function zero externC() => Int32 := 0';
		generateSSAModule.

	function := ssaModule globalNamed: #zero.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks first firstInstruction isJump.
	self assert: function basicBlocks second firstInstruction isReturn.
]
