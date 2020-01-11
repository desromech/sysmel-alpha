#include "llvm/CodeGen/GCStrategy.h"
#include "llvm/CodeGen/GCMetadata.h"
#include "llvm/CodeGen/GCMetadataPrinter.h"
#include "llvm/Support/Compiler.h"

#include "llvm/CodeGen/AsmPrinter.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/Target/TargetLoweringObjectFile.h"
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
    NeededSafePoints = true;
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
        Context.getELFSection(".data.sysmel.gc", ELF::SHT_PROGBITS, 0)
    );

    auto StartSymbol = Context.getOrCreateSymbol("__sysmel_gc_section_start");
    Out->EmitLabel(StartSymbol);

    // Align to pointer size.
    AP.EmitAlignment(IntPtrSize == 4 ? 2 : 3);

    // Iterate on the functions.
    for(auto fit = Info.funcinfo_begin(); fit != Info.funcinfo_end(); ++fit)
    {
        auto &FunctionInfo = *fit;
        auto SafePointCount = FunctionInfo->size();
        auto RootCount = FunctionInfo->roots_size();
        auto StackFrameSize = FunctionInfo->getFrameSize();

        AP.emitInt32(StackFrameSize / IntPtrSize); // In words.
        AP.emitInt32(0); // Reserved.

        AP.emitInt32(SafePointCount);
        AP.emitInt32(RootCount);

        // TODO: Here goes the compiled method object.
        if(IntPtrSize == 4)
        {
            AP.emitInt32(0);
        }
        else
        {
            AP.emitInt32(0);
            AP.emitInt32(0);
        }

        // Emit the safe points.
        for(auto &SafePoint : *FunctionInfo)
        {
            AP.EmitLabelPlusOffset(SafePoint.Label, 0, IntPtrSize);
        }

        // Emit all of the the roots.
        for(auto rit = FunctionInfo->roots_begin(); rit != FunctionInfo->roots_end(); ++rit)
        {
            auto &Root = *rit;
            AP.emitInt32(Root.StackOffset);
        }

        // Padding member
        if(IntPtrSize != 4 && (RootCount & 1))
        {
            AP.emitInt32(0);
        }
    }

    auto EndSymbol = Context.getOrCreateSymbol("__sysmel_gc_section_end");
    Out->EmitLabel(EndSymbol);
}

}
