#include <windows.h>
#include <winrt/Windows.Foundation.h>
#include <winrt/Windows.Foundation.Collections.h>
#include <winrt/Windows.ApplicationModel.Core.h>
#include <winrt/Windows.UI.Core.h>
#include <winrt/Windows.UI.Composition.h>
#include <winrt/Windows.UI.Input.h>

using namespace winrt;

using namespace Windows;
using namespace Windows::ApplicationModel::Core;
using namespace Windows::Foundation::Numerics;
using namespace Windows::UI;
using namespace Windows::UI::Core;
using namespace Windows::UI::Composition;

struct SysmelMainArgs
{
    size_t count;
    const char **elements;
};

extern "C" int sysmel_main(SysmelMainArgs args);

struct SysmelUWPApp : implements<SysmelUWPApp, IFrameworkViewSource, IFrameworkView>
{
    IFrameworkView CreateView()
    {
        return *this;
    }

    void Initialize(CoreApplicationView const &)
    {
    }

    void Load(hstring const&)
    {
    }

    void Uninitialize()
    {
    }

    void SetWindow(CoreWindow const & window)
    {
    }

    void Run()
    {
        SysmelMainArgs args = {};
        sysmel_main(args);
    }
};

extern "C" void sysmel_connectOutputToWin32DebugStream();
int __stdcall wWinMain(HINSTANCE, HINSTANCE, PWSTR, int)
{
    sysmel_connectOutputToWin32DebugStream();
    CoreApplication::Run(make<SysmelUWPApp>());
}

int __stdcall wmain(int, wchar_t*)
{
    CoreApplication::Run(make<SysmelUWPApp>());
}
