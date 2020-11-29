#include <windows.h>
#include <windows.foundation.h>
#include <unknwn.h>
#include <windows.ui.core.h>
#include <winrt/Windows.Foundation.h>
#include <winrt/Windows.Foundation.Collections.h>
#include <winrt/Windows.ApplicationModel.Core.h>
#include <winrt/Windows.UI.Core.h>
#include <winrt/Windows.UI.Composition.h>
#include <winrt/Windows.UI.Input.h>
#include <winrt/Windows.Graphics.Display.h>
#include <winrt/Windows.Gaming.Input.h>
#include <Gamingdeviceinformation.h>
#include <mutex>

namespace abi {
    using namespace ABI::Windows::Foundation;
    using namespace ABI::Windows::UI::Core;
}

using namespace winrt;

using namespace Windows;
using namespace Windows::ApplicationModel::Core;
using namespace Windows::ApplicationModel::Activation;
using namespace Windows::Foundation::Numerics;
using namespace Windows::UI;
using namespace Windows::UI::Core;
using namespace Windows::UI::Composition;
using namespace Windows::Graphics::Display;
using namespace Windows::Gaming::Input;

extern "C" void sysmel_uwp_disableDummyApp();

enum class GameControllerAxis : int8_t {
    LeftX = 0,
    LeftY,
    RightX,
    RightY,
    TriggerLeft,
    TriggerRight,
};

enum class GameControllerButton : int8_t {
    ButtonDown = 0,
    ButtonRight,
    ButtonLeft,
    ButtonUp,
    Back,
    Guide,
    Start,
    LeftStick,
    RightStick,
    LeftShoulder,
    RightShoulder,
    DPadUp,
    DPadDown,
    DPadLeft,
    DPadRight,
};

struct SysmelUWPWindowSystemCallbacks
{
    // The order of these methods must match the corresponding sysmel class.
    virtual void onInitialize() = 0;
    virtual void onLoad() = 0;
    virtual void onRun() = 0;
    virtual void onSetWindow(abi::ICoreWindow *windowHandle) = 0;
    virtual void onUnitialize() = 0;

    virtual void onActivated() = 0;
    virtual void onSuspending() = 0;
    virtual void onResuming() = 0;

    virtual void onGamepadAdded(uint32_t gamepadIndex) = 0;
    virtual void onGamepadRemoved(uint32_t gamepadIndex) = 0;
    virtual void onGamepadButtonPressed(uint32_t gamepadIndex, GameControllerButton button) = 0;
    virtual void onGamepadButtonReleased(uint32_t gamepadIndex, GameControllerButton button) = 0;
    virtual void onGamepadAxisMotion(uint32_t gamepadIndex, GameControllerAxis axis, float value) = 0;

    virtual void onPointerPressed(float x, float y) = 0;
    virtual void onPointerReleased(float x, float y) = 0;
    virtual void onPointerMoved(float x, float y) = 0;
};

static uint32_t currentWindowWidth;
static uint32_t currentWindowHeight;

extern "C" bool sysmel_uwp_getExtent(abi::ICoreWindow * windowHandle, uint32_t * outWidth, uint32_t * outHeight)
{
    if (outWidth)
        *outWidth = currentWindowWidth;
    if (outHeight)
        *outHeight = currentWindowHeight;
    return true;
}

static struct SysmelUWPApp* sysmelUWPAppSingleton;
static constexpr size_t MaxNumberOfGamepads = 4;

/**
 * I am an application that redirects events through a callback.
 */
struct SysmelUWPApp : implements<SysmelUWPApp, IFrameworkViewSource, IFrameworkView>
{
    std::vector<Gamepad> gamepads;
    std::array< GamepadReading, MaxNumberOfGamepads> gamepadReadings;
    std::array<bool, MaxNumberOfGamepads> hasValidGamepadReadings;

    std::mutex gamepadsMutex;
    SysmelUWPWindowSystemCallbacks *callbacks;
    float dpi;
    float dpiScaleFactor;

    SysmelUWPApp(SysmelUWPWindowSystemCallbacks *ccallbacks)
        : callbacks(ccallbacks)
    {
        sysmelUWPAppSingleton = this;
    }

    IFrameworkView CreateView()
    {
        return *this;
    }

    void Initialize(CoreApplicationView const &applicationView)
    {
        applicationView.Activated({ this, &SysmelUWPApp::OnActivated });

        gamepads.resize(MaxNumberOfGamepads, nullptr);
        Gamepad::GamepadAdded({ this, &SysmelUWPApp::OnGamepadAdded });
        Gamepad::GamepadRemoved({ this, &SysmelUWPApp::OnGamepadRemoved });

        callbacks->onInitialize();
    }

    void Load(hstring const&)
    {
        callbacks->onLoad();
    }

    void Uninitialize()
    {
        callbacks->onUnitialize();
    }

    void SetWindow(CoreWindow const & window)
    {
        fetchWindowExtent(window);

        auto navigation = SystemNavigationManager::GetForCurrentView();

        // Snippet from: https://walbourn.github.io/directx-and-uwp-on-xbox-one/
        // UWP on Xbox One triggers a back request whenever the B button is pressed which can result in the app being suspended if unhandled
        navigation.BackRequested([](const winrt::Windows::Foundation::IInspectable&, const BackRequestedEventArgs& args) {
            args.Handled(true);
        });

        window.PointerPressed({ this, &SysmelUWPApp::OnPointerPressed });
        window.PointerReleased({ this, &SysmelUWPApp::OnPointerReleased });
        window.PointerMoved({ this, &SysmelUWPApp::OnPointerMoved });

        // Retrieve the COM ICoreWindow pointer and pass it through a callback into Sysmel.
        com_ptr<abi::ICoreWindow> icoreWindow{ window.as<abi::ICoreWindow>() };
        callbacks->onSetWindow(icoreWindow.get());
    }

    void OnGamepadAdded(IInspectable const&, Gamepad const& gamepad)
    {
        int32_t gamepadIndex = -1;
        {
            std::unique_lock<std::mutex> l(gamepadsMutex);
            for(size_t i = 0; i < gamepads.size(); ++i)
            {
                auto& storedGamepad = gamepads[i];
                if (!storedGamepad)
                {
                    storedGamepad = gamepad;
                    gamepadIndex = int32_t(i);
                    break;
                }
            }
        }

        if (gamepadIndex >= 0)
            callbacks->onGamepadAdded(uint32_t(gamepadIndex));
    }

    void OnGamepadRemoved(IInspectable const&, Gamepad const& gamepad)
    {
        int32_t gamepadIndex = -1;
        {
            std::unique_lock<std::mutex> l(gamepadsMutex);
            for (size_t i = 0; i < gamepads.size(); ++i)
            {
                auto& storedGamepad = gamepads[i];
                if (storedGamepad == gamepad)
                {
                    storedGamepad = nullptr;
                    gamepadIndex = int32_t(i);
                    break;
                }
            }
        }

        if (gamepadIndex >= 0)
            callbacks->onGamepadRemoved(uint32_t(gamepadIndex));
    }

    void PollGamepads()
    {
        std::array<GamepadReading, MaxNumberOfGamepads> oldReadings = {};
        std::array<bool, MaxNumberOfGamepads> oldHasValidGamepadReadings = {};
        std::array<GamepadReading, MaxNumberOfGamepads> newReadings = {};
        std::array<bool, MaxNumberOfGamepads> newHasValidGamepadReadings = {};

        // Get a copy of the new readings.
        {
            std::unique_lock<std::mutex> l(gamepadsMutex);
            oldHasValidGamepadReadings = hasValidGamepadReadings;
            oldReadings = gamepadReadings;
            for (size_t i = 0; i < gamepads.size(); ++i)
            {
                auto& gamepad = gamepads[i];
                if (gamepad)
                {
                    newReadings[i] = gamepad.GetCurrentReading();
                    newHasValidGamepadReadings[i] = true;
                }
            }

            hasValidGamepadReadings = newHasValidGamepadReadings;
            gamepadReadings = newReadings;
        }

        // Dispatch the events.
        for (size_t i = 0; i < MaxNumberOfGamepads; ++i)
        {
            if (oldHasValidGamepadReadings[i] || newHasValidGamepadReadings[i])
                DispatchGamepadEvents(i, oldReadings[i], newReadings[i]);
        }
    }

    void DispatchGamepadEvents(uint32_t gamepadId, const GamepadReading& oldReading, const GamepadReading& newReading)
    {
        auto changedButtons = oldReading.Buttons ^ newReading.Buttons;

#define checkButton(xinputButton, sysmelButton) \
    if((changedButtons & xinputButton) != GamepadButtons::None) \
        DispatchButtonChangeEvent(gamepadId, sysmelButton, (newReading.Buttons & xinputButton) != GamepadButtons::None)

        checkButton(GamepadButtons::A, GameControllerButton::ButtonDown);
        checkButton(GamepadButtons::B, GameControllerButton::ButtonRight);
        checkButton(GamepadButtons::X, GameControllerButton::ButtonLeft);
        checkButton(GamepadButtons::Y, GameControllerButton::ButtonUp);
        checkButton(GamepadButtons::View, GameControllerButton::Back);
        checkButton(GamepadButtons::Menu, GameControllerButton::Start);
        checkButton(GamepadButtons::LeftThumbstick, GameControllerButton::LeftStick);
        checkButton(GamepadButtons::RightThumbstick, GameControllerButton::RightStick);
        checkButton(GamepadButtons::LeftShoulder, GameControllerButton::LeftShoulder);
        checkButton(GamepadButtons::RightShoulder, GameControllerButton::RightShoulder);
        checkButton(GamepadButtons::DPadUp, GameControllerButton::DPadUp);
        checkButton(GamepadButtons::DPadDown, GameControllerButton::DPadDown);
        checkButton(GamepadButtons::DPadLeft, GameControllerButton::DPadLeft);
        checkButton(GamepadButtons::DPadRight, GameControllerButton::DPadRight);
#undef checkButton

#define checkAxis(axisFieldName, sysmelAxis, sign) { \
            auto oldAxisValue = FilterAxisValue(oldReading.axisFieldName*sign); \
            auto newAxisValue = FilterAxisValue(newReading.axisFieldName*sign); \
            if (oldAxisValue != newAxisValue) \
                callbacks->onGamepadAxisMotion(gamepadId, sysmelAxis, newAxisValue); \
        }

        checkAxis(LeftThumbstickX, GameControllerAxis::LeftX, 1.0f);
        checkAxis(LeftThumbstickY, GameControllerAxis::LeftY, -1.0f);
        checkAxis(RightThumbstickX, GameControllerAxis::RightX, 1.0f);
        checkAxis(RightThumbstickY, GameControllerAxis::RightY, -1.0f);
        checkAxis(LeftTrigger, GameControllerAxis::TriggerLeft, 1.0f);
        checkAxis(RightTrigger, GameControllerAxis::TriggerRight, 1.0f);
    }

    float FilterAxisValue(float axis)
    {
        const float Threshold = 0.2f;
        if (axis >= Threshold)
            return (axis - Threshold) / (1.0 - Threshold);
        else if (axis <= -Threshold)
            return (axis + Threshold) / (1.0 - Threshold);
        return 0.0f;
    }

    void DispatchButtonChangeEvent(uint32_t gamepadIndex, GameControllerButton sysmelButton, bool pressed)
    {
        if(pressed)
            callbacks->onGamepadButtonPressed(gamepadIndex, sysmelButton);
        else
            callbacks->onGamepadButtonReleased(gamepadIndex, sysmelButton);
    }

    void OnPointerPressed(IInspectable const&, PointerEventArgs const& args)
    {
        auto point = args.CurrentPoint().Position()*dpiScaleFactor;
        callbacks->onPointerPressed(point.x, point.y);
    }

    void OnPointerReleased(IInspectable const&, PointerEventArgs const& args)
    {
        auto point = args.CurrentPoint().Position() * dpiScaleFactor;
        callbacks->onPointerReleased(point.x, point.y);
    }

    void OnPointerMoved(IInspectable const&, PointerEventArgs const& args)
    {
        auto point = args.CurrentPoint().Position() * dpiScaleFactor;
        callbacks->onPointerMoved(point.x, point.y);
    }

    void fetchWindowExtent(CoreWindow const& window)
    {
        auto bounds = window.Bounds();
        dpi = DisplayInformation::GetForCurrentView().LogicalDpi();
        dpiScaleFactor = dpi / 96;
        currentWindowWidth = uint32_t(bounds.Width * dpiScaleFactor);
        currentWindowHeight = uint32_t(bounds.Height * dpiScaleFactor);

        GAMING_DEVICE_MODEL_INFORMATION info = {};
        GetGamingDeviceModelInformation(&info);
        if (info.vendorId == GAMING_DEVICE_VENDOR_ID_MICROSOFT)
        {
            switch (info.deviceId)
            {
            case GAMING_DEVICE_DEVICE_ID_XBOX_ONE:
            case GAMING_DEVICE_DEVICE_ID_XBOX_ONE_S:
                // Keep swapchain at 1920 x 1080
                break;

            case GAMING_DEVICE_DEVICE_ID_XBOX_ONE_X:
            case GAMING_DEVICE_DEVICE_ID_XBOX_ONE_X_DEVKIT:
            default: // Forward compatibility
                // If we are on the Xbox One X, return a 4k resolution
                currentWindowWidth = 3840;
                currentWindowHeight = 2160;
                break;
            }
        }
    }

    void Run()
    {
        callbacks->onRun();
    }

    void OnActivated(IInspectable const&, IActivatedEventArgs const&)
    {
        callbacks->onActivated();
    }
};

extern "C" void sysmel_uwp_activateCoreWindow()
{
    CoreWindow::GetForCurrentThread().Activate();
}

extern "C" void sysmel_uwp_pumpEvents()
{
    CoreWindow::GetForCurrentThread().Dispatcher().ProcessEvents(CoreProcessEventsOption::ProcessAllIfPresent);
    if (sysmelUWPAppSingleton)
        sysmelUWPAppSingleton->PollGamepads();
}

extern "C" void sysmel_uwp_waitForEvents()
{
    CoreWindow::GetForCurrentThread().Dispatcher().ProcessEvents(CoreProcessEventsOption::ProcessOneAndAllPending);
    if (sysmelUWPAppSingleton)
        sysmelUWPAppSingleton->PollGamepads();
}

extern "C" int sysmel_uwp_runMainLoop(SysmelUWPWindowSystemCallbacks *callbacks)
{
    sysmel_uwp_disableDummyApp();
    CoreApplication::Run(make<SysmelUWPApp> (callbacks));
    return 0;
}
