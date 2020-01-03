# Metabuilders included in the Sysmel core language

## Type declaration and definition
### **struct**
```sysmel
## Declaration.
struct TestStruct.

## Definition.
struct TestStruct definition: {  
    public field intField type: Int32.
}.
```

--------------------------------------------------------------------------------
### **union**
```sysmel
## Declaration.
union TestUnion.

## Definition.
union TestUnion definition: {
    public field intField type: Int32.
    public field floatField type: Float32.
}.
```

--------------------------------------------------------------------------------
### **enum**
```sysmel
## Declaration.
enum TestEnum.

## Definition.
enum TestEnum valueType: UInt32; values: #{
    None: 0.
    First: None + 1.
    Second:.
    Third:.
}.
```

--------------------------------------------------------------------------------
### **class**
```sysmel
## Declaration.
class SuperClass.

## Definition.
class SuperClass definition: {
    public field intField type: Int32.
}.

class SubClass superclass: SuperClass; definition: {
}.
```

--------------------------------------------------------------------------------
### **gcclass**
```sysmel
## Declaration.
gcclass SuperClass.

## Definition.
gcclass SuperClass definition: {
    public field intField type: Int32.
    public field objectField.
}.

gcclass SubClass superclass: SuperClass; definition: {
}.

### NOTE: This requires the GC runtime support to work.
```

--------------------------------------------------------------------------------
### **interface**
Declaration of virtual methods. This is analog to a C++ class with only pure virtual
methods.

```sysmel
## Declaration.
interface SomeInterface.

## Definition.
interface SomeTrait definition: {
    ## Fields are forbidden in interfaces.
    ##field someField type: UInt32.

    method SomeInterface => Boolean8.
}.

## Definition.
class ClassImplementingInterface uses: SomeInterface; definition: {
    override method isSomething => Boolean8
        := true.
}.

### NOTE: This is not yet completely implemented.
```

--------------------------------------------------------------------------------
### **trait**
Type definition mix-in.

```sysmel
## Declaration.
trait SomeTrait.

## Definition.
trait SomeTrait definition: {
    ..
}.

## Definition.
class ClassUsingTrait uses: SomeTrait; definition: {
}.

### NOTE: This is not yet completely implemented.
```

--------------------------------------------------------------------------------
## Flag metabuilder
Flags metabuilders are used for setting definition flags for the usage of other
metabuilders. These metabuilders work by the delegating its job to another
defined metabuilder.

### **const**
Make self immutable.

```sysmel
const method size => UIntPointer
    := size_.
```

--------------------------------------------------------------------------------
### **inline**
Make the method inlineable. This implies the method is also sealed.

```sysmel
inline method size => UIntPointer
    := size_.
```

--------------------------------------------------------------------------------
### **virtual**
Make a vtable entry for the method.

```sysmel
virtual method isSomething => Boolean8
    := false.
```

--------------------------------------------------------------------------------
### **override**
Overrides a virtual method defined in a super class or in an interface.

```sysmel
override method isSomething => Boolean8
    := false.
```

--------------------------------------------------------------------------------
### **private**
Hide fields from subclasses.

--------------------------------------------------------------------------------
### **public**
Creates public getters and setter accessing macros for the field.

--------------------------------------------------------------------------------
### **sealed**
Mark the method as a non-virtual or dynamic message overriding is allowed. This
facilitates direct calling by avoiding vtable or dynamic message lookup.

--------------------------------------------------------------------------------
### **static**
Mark the method as not belonging to the instance side or the class side. This
removes the implicit self argument. This is useful for interfacing with the
external libraries with an exact method/function signature.

--------------------------------------------------------------------------------
## Function and message definition
### **function**
Function declaration and definition. This is used for defining a C style
function or a C++/C#/Java style method. This can also be used for defining
anonymous functions and closures.

```sysmel
function main externC(argc: Int32, argv, Char8 const pointer) => Int32 := {
    LibC printf("Hello World\n").
    0
}.

```

--------------------------------------------------------------------------------
### **method**
Message method declaration and definition. This is used for defining a Smalltalk
style message responding method.

```sysmel
method add: (a: Float32) with: (b: Float32) ::=> Float32
    := a + b.

## The :: means low precedence binary operator, its purpose its to avoid
## adding an explicit parentheses. The following is equivalent to the previous
## definition:

(method add: (a: Float32) with: (b: Float32)) => Float32
    := a + b.

```
--------------------------------------------------------------------------------
### **macro method**
Macro message method definition. This is used for defining a macro with a
Smalltalk style message send invocation method.

--------------------------------------------------------------------------------
## Variable definition
### **compileTimeConstant**
Definition of compile time constants. This act almost like copying the textual
value and allow passing literal types.

```sysmel
compileTimeConstant theAnswer := 42.
compileTimeConstant SizeT := UIntPointer.
```

--------------------------------------------------------------------------------
### **let**
Local variable definition/declaration.

```sysmel
## Immutable local variable definition.
let x := 42.
let x type: Int32 := 42.

## Mutable local variable declaration.
let x mutable := 42.
let x mutable type: Int32 := 42.

## Local variable aliasing another variable
let y ref := x. ## Infers a reference type
```

In global evaluation environments, `let` is converted into `static global`.

--------------------------------------------------------------------------------
### **global**
Global variable definition. Static global are global variables that are only
bound into the local lexical scope (i.e. they are not bound to the enclosing
namespace/type local symbol dictionary).

--------------------------------------------------------------------------------
### **field**
Aggregate field definition.

--------------------------------------------------------------------------------
## Other program entities

### **namespace**
Namespace definition or extension.

```sysmel
namespace TestNamespace definition: {
    global x mutable := 42.
}.

## Usage example
TestNamespace x ## Evaluates to a x reference
```

--------------------------------------------------------------------------------
### **template**
Templates are used for defining C++ style generics. In the case of Sysmel,
templates are treated as if they were macros whose evaluation value is cached
with additional support for recursive definitions.

#### Type template
```sysmel
template Pair(FT: Type, ST: Type)
    := struct definition: {
    compileTimeConstant FirstType := FT.
    compileTimeConstant SecondType := ST.

    public field first type: FirstType.
    public field first type: SecondType.
}.

global pairIntFloat type: Pair(Int32, Float32).
```

#### Method/function template
Like in C++,method and function template can perform pattern matching on their
arguments to automatically infer matching types.

```sysmel
template (VT: Type)
function pointerToReference(pointer: VT pointer) => VT ref
    := pointer value.

### NOTE: This is not yet implemented. This was implemented in an older version of sysmel.
```
