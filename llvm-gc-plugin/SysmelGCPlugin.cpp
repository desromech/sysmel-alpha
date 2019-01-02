#include "llvm/CodeGen/GCStrategy.h"
#include "llvm/CodeGen/GCMetadata.h"
#include "llvm/CodeGen/GCMetadataPrinter.h"
#include "llvm/Support/Compiler.h"

#include "llvm/CodeGen/AsmPrinter.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/TargetLoweringObjectFile.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCSectionELF.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/Target/TargetMachine.h"

#include "llvm/Object/ELF.h"

namespace
{
using namespace llvm;

/**
 * GC collection strategy.
 */
class LLVM_LIBRARY_VISIBILITY SysmelGCStrategy : public GCStrategy {
public:
    SysmelGCStrategy();
};

GCRegistry::Add<SysmelGCStrategy>
X("sysmel", "Sysmel garbage collection plugin.");

SysmelGCStrategy::SysmelGCStrategy()
{
    UsesMetadata = true;

    // The required safe points.
    NeededSafePoints = 1 << GC::PreCall
                   | 1 << GC::PostCall;
}

/**
 * GC metadata printer.
 */
class LLVM_LIBRARY_VISIBILITY SysmelGCPrinter : public GCMetadataPrinter {
public:
    virtual void beginAssembly(Module &M, GCModuleInfo &Info, AsmPrinter &AP) override;

    virtual void finishAssembly(Module &M, GCModuleInfo &Info, AsmPrinter &AP) override;
};

GCMetadataPrinterRegistry::Add<SysmelGCPrinter>
X2("sysmel", "Sysmel garbage collection plugin.");

void SysmelGCPrinter::beginAssembly(Module &M, GCModuleInfo &Info, AsmPrinter &AP)
{
    // Nothing required here.
}

void SysmelGCPrinter::finishAssembly(Module &M, GCModuleInfo &Info, AsmPrinter &AP)
{
    const auto &Out = AP.OutStreamer;
    auto IntPtrSize = AP.getPointerSize();
    auto &Context = AP.getObjFileLowering().getContext();

    // Put this in a custom elf section.
    Out->SwitchSection(
        Context.getELFSection(".sysmel.gc", ELF::SHT_PROGBITS, 0)
    );

    AP.EmitInt32(42);
}

}
