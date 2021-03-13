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
    const char **elements;
    size_t size;
};

extern "C" int sysmel_main(const SysmelMainArgs &args);

static bool shouldRunDummyApp = true;

extern "C" void sysmel_uwp_disableDummyApp()
{
    shouldRunDummyApp = false;
}
/**
 * I am a dummy application. I am used when the sysmel program does not install its own version of an application.
 */
struct SysmelUWPDummyApp : implements<SysmelUWPDummyApp, IFrameworkViewSource, IFrameworkView>
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
    }
};

static void runSysmelApplication()
{
    init_apartment();

    SysmelMainArgs args = {};
    sysmel_main(args);

    // We always need to run app to avoid an error message.
    if(shouldRunDummyApp)
        CoreApplication::Run(make<SysmelUWPDummyApp>());
}

extern "C" void sysmel_connectOutputToWin32DebugStream();
int __stdcall wWinMain(HINSTANCE, HINSTANCE, PWSTR, int)
{
    sysmel_connectOutputToWin32DebugStream();
    runSysmelApplication();
}

int __stdcall wmain(int, wchar_t*)
{
    runSysmelApplication();
}
