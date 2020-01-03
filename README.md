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
./sysmelc -nogc -g -O2 -o helloSDL2 samples/cpu/helloSDL2.sysmel

# LLVM IR assembly.
./sysmelc -g -O2 -S -o hello.ll samples/cpu/hello.sysmel
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
