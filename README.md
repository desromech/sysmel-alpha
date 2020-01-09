# Sysmel
### A SYStem MEtaprogramming Language
Sysmel is a metaprogramming language whose source code is composed of scripts
that are directly evaluated to construct another program. The direct evaluation
of a sysmel source leave traces in a module (a metamodel instance) which are
further analyzed to perform the following task:

* Type checking.
* Macro expansion.
* Program entities dependency analysis.
* SSA intermediate code generation and optimization.
* LLVM backend for native code generation.
* Spir-V backend for Vulkan shader generation.

## Offline compiler loading and usage
The script **newImage.sh** loads a new image with the Sysmel compiler which can be
invoked through the command with the **sysmelc** bash script. The command line
frontend accepts gcc/clang style command line arguments:

```bash
# Program direct compilation.
./sysmelc -g -O2 -o hello samples/cpu/hello.sysmel

# Program direct compilation without GC support.
./sysmelc -nogc -g -o sampleNativeGame lib/bindings/sdl2/sdl2.sysmel samples/cpu/sampleNativeGame.sysmel

# LLVM IR assembly.
./sysmelc -g -O2 -emit-llvm -S -o hello.ll samples/cpu/hello.sysmel
clang -o hello hello.o -lgc -lm

# Native assembly.
./sysmelc -g -O2 -S -o hello.s samples/cpu/hello.sysmel
clang -o hello hello.o -lgc -lm

# Separate object file and linking.
./sysmelc -g -O2 -c -o hello.o samples/cpu/hello.sysmel
clang -o hello hello.o -lgc -lm

# Spir-V Vulkan shader compilation
./sysmelc -mvulkan -o solidRenderingShaders.spv samples/gpu/solidRenderingShaders.sysmel
```

## Loading in a Pharo image
Sysmel can be loaded on a standard Pharo 7 image. The default baseline includes
the Sysmel compiler, and the SGPU framework for translating standard Pharo block
closures into shaders.

```smalltalk
Metacello new
   baseline: 'Sysmel';
   repository: 'github://ronsaldo/sysmel/tonel';
   load
```

## Compiler invocation in a playground
```smalltalk
"CPU Hello sample"
MbndStandaloneModule llvm_x86_64
	withDebugInformation;
	loadRuntimeCoreLibrary;
	evaluateFileNamedOnce: 'samples/cpu/hello.sysmel';
	finishSemanticAnalysis;
	"writeLLVMAssemblyToFileNamed: 'hello.ll';"
    "writeAssemblyToFileNamed: 'hello.s';"
    writeExecutableToFileNamed: 'hello'

"CPU native sample game"
MbndStandaloneModule llvm_x86_64
	withDebugInformation;
	noGC;
	"optimizationLevel: 2;"
	loadRuntimeCoreLibrary;
	evaluateFileNamedOnce: 'lib/bindings/sdl2/sdl2.sysmel';
	evaluateFileNamedOnce: 'samples/cpu/sampleNativeGame.sysmel';
	finishSemanticAnalysis;
	"writeLLVMAssemblyToFileNamed: 'sampleNativeGame.ll';"
	"writeAssemblyToFileNamed: 'sampleNativeGame.s';"
	writeExecutableToFileNamed: 'sampleNativeGame'

"Sample Vulkan shaders"
MbndStandaloneModule spirv_vulkan
	loadRuntimeCoreLibrary;
	evaluateFileNamedOnce: 'samples/gpu/solidRenderingShaders.sysmel';
	finishSemanticAnalysis;
	writeExecutableToFileNamed: 'solidRenderingShaders.spv'
```

## Syntax overview
The sysmel language syntax is a hybrid between Smalltalk and C++. Some
elements of the syntax are picked with the object of facilitating either
metaprogramming, or numerical computations (e.g. the same operator precedence levels as in C).
Many syntactic elements of the Sysmel syntax are actually syntactic sugar for
message sends. Message sends are analyzed in two phases:

1. Unexpanded messages are looked up through the macro method dictionary and if
a macro with a matching selector is found, the AST nodes for the unexpanded
message send is expanded and analyzed by the matching macro. If macro with a
matching selector is not found, then the unexpanded message send node is
converted into an expanded message send node.
2. Expanded message sends have the same style of lookup mechanism as a standard
Smalltalk message send. Since Sysmel is a statically typed language (but one of
the types, ProtoObject is treated as a generic dynamic object type) messages are
typed, and like in C++ they can be overloaded.

Unlike in Smalltak, in Sysmel there can be message sends without a receiver. These
messages are bound to the namespace and they are looked through the lexical
scoping chain. Messages without receiver are typically used for implementing
macros that are expanded into AST nodes without syntactic correlation (i.e. they
do not appear in the Sysmel grammar). The following are some examples of messages
without receiver:

```sysmel
loadFileOnce: "test.sysmel". ## Invoke the sysmel compiler to compile the specified file.

## If selection expression.
if: a >= 0 then: 1 else: -1.

## While loop iterating through linked list
let position mutable type: LinkedListNode pointer := firstNode.
while: position ~~ nil do: {
    ## ... Do something with the list nodes.
} continueWith: { position := position _ next }.
```

Complex syntactically looking constructs are implemented through the concept
of a metabuilder (in analogy to the builder design pattern, but for syntactical
elements). Metabuilders are object whose message sends are evaluated in compile
time for altering and construct new AST node elements. They are used to give the
illusion of a complex language syntax, but they are just unexpanded message sends.
For example, the **let** meta builder is used to introduce a local variable:

```sysmel
let someInteger := 42.
let someMutableInteger mutable := 42.
let someMutableInteger mutable type: Int32 := 42.

let _ := 42. ## Anonymous variable.

```
**let** is not keyword, but a symbol that is bound to metabuilder factory. When a
metabuilder factory is analyzed, the identifier reference node is expanded into a
metabuilder instance. In the case of **let**, the selector of the first unary message
that the metabuilder object receives is used for naming the variable. The
remaining messages that the metabuilder receives are delegated to the underlying
Smalltalk object that represents the metabuilder instance living in the
compiler. When a metabuilder receives a message that does not understand, or
decides that it does not want to receive any more messages, the metabuilder
instance node is replaced by an actual AST node that is decided by the
metabuilder after gathering all of the data that it needs for building that node.

To avoid potential compiler mistakes, when new symbols are defined with the same
name of a metabuilder present in the lexical scope of the symbol definition, a
warning is displayed by the Sysmel compiler.

A more complex example of metabuilders are the metabuilders for defining
functions and methods. For example:

```sysmel

## Define the function square(). This is invoked as
function square(x: Int32) => Int32
    := x*x.

## Function application is a syntactic sugar for #applyWithArguments: (tuple).
## The above is equivalent to the following definition.
((function square) applyWithArguments: (x: Int32,)) => Int32
    := x*x.

## Define the message method #square:
method square: (x: Int32) ::=> Int32
    := x*x.

## The colons :: means that follows a low precedence binary operator. Syntactically
## the above is equivalent to the following definition:
(method square: (x: Int32)) => Int32
    := x*x.

## The (x: Int32) syntactically is parsed as the message #x: without a receiver
## whose first argument is Int32. These parsed message send nodes are transformed
## by the metabuilder into argument definition nodes.
```

Some metabuilders are used for adding a flag to another metabuilder instance. These
metabuilder work by delegating their work to another metabuilder.

Types are specified by arbitrary expressions whose values are evaluated in
compile-time into an object representing a type. For this reason the syntax for
specifying types is highly flexible.

## BlockClosure to GPU block compilation

```smalltalk
"For cleaning up, you can do the following:
SGPUCompilationEnvironment reset.
SGPUExecutionDriver reset.
"

Transcript show: 'GPU scheduling, memory allocation and block conversion time ';
    show: [
"Generate the input data."
n := 10000000.
data := (1 to: n) asGPUFloat32Array.

"Map the data"
mapBlock := [ :x | (x + 10) * 2 ] gpuType: #(Float32 => Float32).
mappedData := data collect: mapBlock.

"Then reduce it"
sumBlock := [ :x :y | x + y ] gpuType: #((Float32, Float32) => Float32).
reducedData := mappedData binaryReductionWith: sumBlock.

"Inspect the results. By doing the following:
reducedData inspect.
mappedData inspect
"
] timeToRun asMilliSeconds; cr.

"Computation results are delayed until they are actually needed. They are done
automatically when inspecting the result. The pending computations can be
finished by doing the following: SGPUExecutionDriver current finishPendingComputations
"

Transcript show: 'GPU execution time: ';
    show: [SGPUExecutionDriver current finishPendingComputations] timeToRun asMilliSeconds;
    cr.

"Compare with the following CPU only example"
Transcript show: 'CPU execution time: ';
    show: [((1 to: n) collect: [ :x | (x + 10) * 2 ]) sum ] timeToRun asMilliSeconds;
    cr.
```
