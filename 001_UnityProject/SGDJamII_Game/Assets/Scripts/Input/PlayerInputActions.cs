// GENERATED AUTOMATICALLY FROM 'Assets/Scripts/Input/PlayerInputActions.inputactions'

using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.Utilities;

public class @PlayerInputActions : IInputActionCollection, IDisposable
{
    public InputActionAsset asset { get; }
    public @PlayerInputActions()
    {
        asset = InputActionAsset.FromJson(@"{
    ""name"": ""PlayerInputActions"",
    ""maps"": [
        {
            ""name"": ""PlayerControls"",
            ""id"": ""1af6d13a-e96d-4495-8dda-8e38ad521c1a"",
            ""actions"": [
                {
                    ""name"": ""Move"",
                    ""type"": ""Value"",
                    ""id"": ""7b406d21-7bab-4a7b-913c-0532398993fa"",
                    ""expectedControlType"": ""Stick"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""Use"",
                    ""type"": ""Button"",
                    ""id"": ""f3d0c0a0-d576-4508-bd1c-a529d17221ca"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""PickUpRelease"",
                    ""type"": ""Button"",
                    ""id"": ""b926e40c-2c3d-4046-b49b-3076bc839512"",
                    ""expectedControlType"": """",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""Run"",
                    ""type"": ""Button"",
                    ""id"": ""d5fffd84-70d2-4c19-8fa7-bc62fd64a92f"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""Look"",
                    ""type"": ""Value"",
                    ""id"": ""b0e44fd2-7898-437a-bb20-88cd09369d70"",
                    ""expectedControlType"": """",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""QuitGame"",
                    ""type"": ""Button"",
                    ""id"": ""45beac25-9b7b-41d1-8f37-accaadd18f80"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                }
            ],
            ""bindings"": [
                {
                    ""name"": ""WASD"",
                    ""id"": ""b436e486-f860-48c4-a814-0a77886077e0"",
                    ""path"": ""2DVector"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Move"",
                    ""isComposite"": true,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": ""up"",
                    ""id"": ""79bf674a-951b-4cd3-9412-ea37b7201b92"",
                    ""path"": ""<Keyboard>/w"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""Keyboard"",
                    ""action"": ""Move"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""down"",
                    ""id"": ""f0052275-8cf9-455a-ac4b-7e3a2ded0564"",
                    ""path"": ""<Keyboard>/s"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""Keyboard"",
                    ""action"": ""Move"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""left"",
                    ""id"": ""aadc6dda-62f9-412c-bdfb-37190c415c93"",
                    ""path"": ""<Keyboard>/a"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""Keyboard"",
                    ""action"": ""Move"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""right"",
                    ""id"": ""97b721ab-a4a7-48e8-9414-83fa0d504b48"",
                    ""path"": ""<Keyboard>/d"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""Keyboard"",
                    ""action"": ""Move"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": """",
                    ""id"": ""fa0d32e2-ee8a-48ab-8b48-1583f518605a"",
                    ""path"": ""<Gamepad>/leftStick"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""GamePad"",
                    ""action"": ""Move"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""e821de8b-892f-4ae3-933b-ec61daca75e5"",
                    ""path"": ""<Keyboard>/space"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""Keyboard"",
                    ""action"": ""Use"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""70319215-5965-41de-9a81-6486888495f0"",
                    ""path"": ""<Gamepad>/buttonSouth"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""GamePad"",
                    ""action"": ""PickUpRelease"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""e64bf52d-aa4f-4034-8b98-063eac5086f9"",
                    ""path"": ""<Keyboard>/e"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""Keyboard"",
                    ""action"": ""PickUpRelease"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""d55879e6-6dd8-469d-b30c-b2dea3ada717"",
                    ""path"": ""<Keyboard>/leftShift"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""Keyboard"",
                    ""action"": ""Run"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""c31ac165-0004-482a-836c-ae52a1fabc7c"",
                    ""path"": ""<Gamepad>/leftTrigger"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""GamePad"",
                    ""action"": ""Run"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""dba800ca-19fe-4e09-8b53-594fb1aed85c"",
                    ""path"": ""<Gamepad>/rightStick"",
                    ""interactions"": """",
                    ""processors"": ""StickDeadzone(min=0.3)"",
                    ""groups"": ""GamePad"",
                    ""action"": ""Look"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""4e2c094e-5378-4936-a137-b3f9c7743174"",
                    ""path"": ""<Mouse>/delta"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Look"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""c31232b2-1f27-4ebe-a7ec-3ff069dfa057"",
                    ""path"": ""<Gamepad>/rightTrigger"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""GamePad"",
                    ""action"": ""Use"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""90fa4cfc-b27b-43ff-b811-e1a5ca8f8721"",
                    ""path"": ""<Keyboard>/escape"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""Keyboard"",
                    ""action"": ""QuitGame"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""ff80c49a-a20c-4b1c-a647-d60551869b19"",
                    ""path"": ""<Gamepad>/start"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""GamePad"",
                    ""action"": ""QuitGame"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                }
            ]
        },
        {
            ""name"": ""MenuPlayerControls"",
            ""id"": ""c44b3dc9-05b1-41c4-9522-cccd553d5921"",
            ""actions"": [
                {
                    ""name"": ""Move"",
                    ""type"": ""Value"",
                    ""id"": ""4ce9e743-c33e-4a45-a10b-6c30909db497"",
                    ""expectedControlType"": ""Stick"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""Use"",
                    ""type"": ""Button"",
                    ""id"": ""c239b4ee-7d01-4c6d-ab19-885b6a0fe9a8"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                }
            ],
            ""bindings"": [
                {
                    ""name"": ""WASD"",
                    ""id"": ""38d057b4-17d6-4711-a2ed-f4234351e644"",
                    ""path"": ""2DVector"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Move"",
                    ""isComposite"": true,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": ""up"",
                    ""id"": ""04fa1a3a-b878-4fbc-8191-fa7f0a70606f"",
                    ""path"": ""<Keyboard>/w"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""Keyboard"",
                    ""action"": ""Move"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""down"",
                    ""id"": ""e9fd2448-05ad-4663-85f7-d493785a4bfd"",
                    ""path"": ""<Keyboard>/s"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""Keyboard"",
                    ""action"": ""Move"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""left"",
                    ""id"": ""f920731e-d45f-4709-8dda-f6e9ae910c4b"",
                    ""path"": ""<Keyboard>/a"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""Keyboard"",
                    ""action"": ""Move"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""right"",
                    ""id"": ""801c61b8-1ae6-4c9f-b3ea-6e3eb0a7b4a9"",
                    ""path"": ""<Keyboard>/d"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""Keyboard"",
                    ""action"": ""Move"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": """",
                    ""id"": ""2e46192c-656e-4b2d-80c6-f7b9c7fcd109"",
                    ""path"": ""<Gamepad>/leftStick"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""GamePad"",
                    ""action"": ""Move"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""f673d414-a4a9-4381-8196-366621ba4e87"",
                    ""path"": ""<Keyboard>/space"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""Keyboard"",
                    ""action"": ""Use"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""bb274e71-1cd1-4628-8beb-dda02fcfbf1b"",
                    ""path"": ""<Gamepad>/buttonSouth"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""GamePad"",
                    ""action"": ""Use"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""33dd77ea-5287-4ec1-8e67-13e8d92c41d4"",
                    ""path"": ""<Keyboard>/e"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""Keyboard"",
                    ""action"": ""Use"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                }
            ]
        },
        {
            ""name"": ""MainMenuController"",
            ""id"": ""085b3b67-e963-4f2e-b0de-e1b3fc4f52c7"",
            ""actions"": [
                {
                    ""name"": ""StartGame"",
                    ""type"": ""Button"",
                    ""id"": ""df026530-0fce-4bf5-8f0b-d33762a78e46"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""ExitGame"",
                    ""type"": ""Button"",
                    ""id"": ""2ef6c90d-2eb6-4c15-b2ff-6640f1767ae7"",
                    ""expectedControlType"": """",
                    ""processors"": """",
                    ""interactions"": """"
                }
            ],
            ""bindings"": [
                {
                    ""name"": """",
                    ""id"": ""fcda2d78-6b9f-4245-835a-11dbd87d00d7"",
                    ""path"": ""<Keyboard>/e"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""Keyboard"",
                    ""action"": ""StartGame"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""d8304d52-fcda-46ff-a5a4-1941b1ca48f0"",
                    ""path"": ""<Gamepad>/buttonSouth"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""GamePad"",
                    ""action"": ""StartGame"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""42118ff4-bcbc-47fb-9d9e-f62143f2df07"",
                    ""path"": ""<Keyboard>/escape"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""Keyboard"",
                    ""action"": ""ExitGame"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""f150dc8d-5c7c-45d9-81d5-51a5557ef808"",
                    ""path"": ""<Gamepad>/start"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""GamePad"",
                    ""action"": ""ExitGame"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                }
            ]
        }
    ],
    ""controlSchemes"": [
        {
            ""name"": ""Keyboard"",
            ""bindingGroup"": ""Keyboard"",
            ""devices"": [
                {
                    ""devicePath"": ""<Keyboard>"",
                    ""isOptional"": false,
                    ""isOR"": false
                },
                {
                    ""devicePath"": ""<Mouse>"",
                    ""isOptional"": false,
                    ""isOR"": false
                }
            ]
        },
        {
            ""name"": ""GamePad"",
            ""bindingGroup"": ""GamePad"",
            ""devices"": [
                {
                    ""devicePath"": ""<Gamepad>"",
                    ""isOptional"": false,
                    ""isOR"": false
                }
            ]
        }
    ]
}");
        // PlayerControls
        m_PlayerControls = asset.FindActionMap("PlayerControls", throwIfNotFound: true);
        m_PlayerControls_Move = m_PlayerControls.FindAction("Move", throwIfNotFound: true);
        m_PlayerControls_Use = m_PlayerControls.FindAction("Use", throwIfNotFound: true);
        m_PlayerControls_PickUpRelease = m_PlayerControls.FindAction("PickUpRelease", throwIfNotFound: true);
        m_PlayerControls_Run = m_PlayerControls.FindAction("Run", throwIfNotFound: true);
        m_PlayerControls_Look = m_PlayerControls.FindAction("Look", throwIfNotFound: true);
        m_PlayerControls_QuitGame = m_PlayerControls.FindAction("QuitGame", throwIfNotFound: true);
        // MenuPlayerControls
        m_MenuPlayerControls = asset.FindActionMap("MenuPlayerControls", throwIfNotFound: true);
        m_MenuPlayerControls_Move = m_MenuPlayerControls.FindAction("Move", throwIfNotFound: true);
        m_MenuPlayerControls_Use = m_MenuPlayerControls.FindAction("Use", throwIfNotFound: true);
        // MainMenuController
        m_MainMenuController = asset.FindActionMap("MainMenuController", throwIfNotFound: true);
        m_MainMenuController_StartGame = m_MainMenuController.FindAction("StartGame", throwIfNotFound: true);
        m_MainMenuController_ExitGame = m_MainMenuController.FindAction("ExitGame", throwIfNotFound: true);
    }

    public void Dispose()
    {
        UnityEngine.Object.Destroy(asset);
    }

    public InputBinding? bindingMask
    {
        get => asset.bindingMask;
        set => asset.bindingMask = value;
    }

    public ReadOnlyArray<InputDevice>? devices
    {
        get => asset.devices;
        set => asset.devices = value;
    }

    public ReadOnlyArray<InputControlScheme> controlSchemes => asset.controlSchemes;

    public bool Contains(InputAction action)
    {
        return asset.Contains(action);
    }

    public IEnumerator<InputAction> GetEnumerator()
    {
        return asset.GetEnumerator();
    }

    IEnumerator IEnumerable.GetEnumerator()
    {
        return GetEnumerator();
    }

    public void Enable()
    {
        asset.Enable();
    }

    public void Disable()
    {
        asset.Disable();
    }

    // PlayerControls
    private readonly InputActionMap m_PlayerControls;
    private IPlayerControlsActions m_PlayerControlsActionsCallbackInterface;
    private readonly InputAction m_PlayerControls_Move;
    private readonly InputAction m_PlayerControls_Use;
    private readonly InputAction m_PlayerControls_PickUpRelease;
    private readonly InputAction m_PlayerControls_Run;
    private readonly InputAction m_PlayerControls_Look;
    private readonly InputAction m_PlayerControls_QuitGame;
    public struct PlayerControlsActions
    {
        private @PlayerInputActions m_Wrapper;
        public PlayerControlsActions(@PlayerInputActions wrapper) { m_Wrapper = wrapper; }
        public InputAction @Move => m_Wrapper.m_PlayerControls_Move;
        public InputAction @Use => m_Wrapper.m_PlayerControls_Use;
        public InputAction @PickUpRelease => m_Wrapper.m_PlayerControls_PickUpRelease;
        public InputAction @Run => m_Wrapper.m_PlayerControls_Run;
        public InputAction @Look => m_Wrapper.m_PlayerControls_Look;
        public InputAction @QuitGame => m_Wrapper.m_PlayerControls_QuitGame;
        public InputActionMap Get() { return m_Wrapper.m_PlayerControls; }
        public void Enable() { Get().Enable(); }
        public void Disable() { Get().Disable(); }
        public bool enabled => Get().enabled;
        public static implicit operator InputActionMap(PlayerControlsActions set) { return set.Get(); }
        public void SetCallbacks(IPlayerControlsActions instance)
        {
            if (m_Wrapper.m_PlayerControlsActionsCallbackInterface != null)
            {
                @Move.started -= m_Wrapper.m_PlayerControlsActionsCallbackInterface.OnMove;
                @Move.performed -= m_Wrapper.m_PlayerControlsActionsCallbackInterface.OnMove;
                @Move.canceled -= m_Wrapper.m_PlayerControlsActionsCallbackInterface.OnMove;
                @Use.started -= m_Wrapper.m_PlayerControlsActionsCallbackInterface.OnUse;
                @Use.performed -= m_Wrapper.m_PlayerControlsActionsCallbackInterface.OnUse;
                @Use.canceled -= m_Wrapper.m_PlayerControlsActionsCallbackInterface.OnUse;
                @PickUpRelease.started -= m_Wrapper.m_PlayerControlsActionsCallbackInterface.OnPickUpRelease;
                @PickUpRelease.performed -= m_Wrapper.m_PlayerControlsActionsCallbackInterface.OnPickUpRelease;
                @PickUpRelease.canceled -= m_Wrapper.m_PlayerControlsActionsCallbackInterface.OnPickUpRelease;
                @Run.started -= m_Wrapper.m_PlayerControlsActionsCallbackInterface.OnRun;
                @Run.performed -= m_Wrapper.m_PlayerControlsActionsCallbackInterface.OnRun;
                @Run.canceled -= m_Wrapper.m_PlayerControlsActionsCallbackInterface.OnRun;
                @Look.started -= m_Wrapper.m_PlayerControlsActionsCallbackInterface.OnLook;
                @Look.performed -= m_Wrapper.m_PlayerControlsActionsCallbackInterface.OnLook;
                @Look.canceled -= m_Wrapper.m_PlayerControlsActionsCallbackInterface.OnLook;
                @QuitGame.started -= m_Wrapper.m_PlayerControlsActionsCallbackInterface.OnQuitGame;
                @QuitGame.performed -= m_Wrapper.m_PlayerControlsActionsCallbackInterface.OnQuitGame;
                @QuitGame.canceled -= m_Wrapper.m_PlayerControlsActionsCallbackInterface.OnQuitGame;
            }
            m_Wrapper.m_PlayerControlsActionsCallbackInterface = instance;
            if (instance != null)
            {
                @Move.started += instance.OnMove;
                @Move.performed += instance.OnMove;
                @Move.canceled += instance.OnMove;
                @Use.started += instance.OnUse;
                @Use.performed += instance.OnUse;
                @Use.canceled += instance.OnUse;
                @PickUpRelease.started += instance.OnPickUpRelease;
                @PickUpRelease.performed += instance.OnPickUpRelease;
                @PickUpRelease.canceled += instance.OnPickUpRelease;
                @Run.started += instance.OnRun;
                @Run.performed += instance.OnRun;
                @Run.canceled += instance.OnRun;
                @Look.started += instance.OnLook;
                @Look.performed += instance.OnLook;
                @Look.canceled += instance.OnLook;
                @QuitGame.started += instance.OnQuitGame;
                @QuitGame.performed += instance.OnQuitGame;
                @QuitGame.canceled += instance.OnQuitGame;
            }
        }
    }
    public PlayerControlsActions @PlayerControls => new PlayerControlsActions(this);

    // MenuPlayerControls
    private readonly InputActionMap m_MenuPlayerControls;
    private IMenuPlayerControlsActions m_MenuPlayerControlsActionsCallbackInterface;
    private readonly InputAction m_MenuPlayerControls_Move;
    private readonly InputAction m_MenuPlayerControls_Use;
    public struct MenuPlayerControlsActions
    {
        private @PlayerInputActions m_Wrapper;
        public MenuPlayerControlsActions(@PlayerInputActions wrapper) { m_Wrapper = wrapper; }
        public InputAction @Move => m_Wrapper.m_MenuPlayerControls_Move;
        public InputAction @Use => m_Wrapper.m_MenuPlayerControls_Use;
        public InputActionMap Get() { return m_Wrapper.m_MenuPlayerControls; }
        public void Enable() { Get().Enable(); }
        public void Disable() { Get().Disable(); }
        public bool enabled => Get().enabled;
        public static implicit operator InputActionMap(MenuPlayerControlsActions set) { return set.Get(); }
        public void SetCallbacks(IMenuPlayerControlsActions instance)
        {
            if (m_Wrapper.m_MenuPlayerControlsActionsCallbackInterface != null)
            {
                @Move.started -= m_Wrapper.m_MenuPlayerControlsActionsCallbackInterface.OnMove;
                @Move.performed -= m_Wrapper.m_MenuPlayerControlsActionsCallbackInterface.OnMove;
                @Move.canceled -= m_Wrapper.m_MenuPlayerControlsActionsCallbackInterface.OnMove;
                @Use.started -= m_Wrapper.m_MenuPlayerControlsActionsCallbackInterface.OnUse;
                @Use.performed -= m_Wrapper.m_MenuPlayerControlsActionsCallbackInterface.OnUse;
                @Use.canceled -= m_Wrapper.m_MenuPlayerControlsActionsCallbackInterface.OnUse;
            }
            m_Wrapper.m_MenuPlayerControlsActionsCallbackInterface = instance;
            if (instance != null)
            {
                @Move.started += instance.OnMove;
                @Move.performed += instance.OnMove;
                @Move.canceled += instance.OnMove;
                @Use.started += instance.OnUse;
                @Use.performed += instance.OnUse;
                @Use.canceled += instance.OnUse;
            }
        }
    }
    public MenuPlayerControlsActions @MenuPlayerControls => new MenuPlayerControlsActions(this);

    // MainMenuController
    private readonly InputActionMap m_MainMenuController;
    private IMainMenuControllerActions m_MainMenuControllerActionsCallbackInterface;
    private readonly InputAction m_MainMenuController_StartGame;
    private readonly InputAction m_MainMenuController_ExitGame;
    public struct MainMenuControllerActions
    {
        private @PlayerInputActions m_Wrapper;
        public MainMenuControllerActions(@PlayerInputActions wrapper) { m_Wrapper = wrapper; }
        public InputAction @StartGame => m_Wrapper.m_MainMenuController_StartGame;
        public InputAction @ExitGame => m_Wrapper.m_MainMenuController_ExitGame;
        public InputActionMap Get() { return m_Wrapper.m_MainMenuController; }
        public void Enable() { Get().Enable(); }
        public void Disable() { Get().Disable(); }
        public bool enabled => Get().enabled;
        public static implicit operator InputActionMap(MainMenuControllerActions set) { return set.Get(); }
        public void SetCallbacks(IMainMenuControllerActions instance)
        {
            if (m_Wrapper.m_MainMenuControllerActionsCallbackInterface != null)
            {
                @StartGame.started -= m_Wrapper.m_MainMenuControllerActionsCallbackInterface.OnStartGame;
                @StartGame.performed -= m_Wrapper.m_MainMenuControllerActionsCallbackInterface.OnStartGame;
                @StartGame.canceled -= m_Wrapper.m_MainMenuControllerActionsCallbackInterface.OnStartGame;
                @ExitGame.started -= m_Wrapper.m_MainMenuControllerActionsCallbackInterface.OnExitGame;
                @ExitGame.performed -= m_Wrapper.m_MainMenuControllerActionsCallbackInterface.OnExitGame;
                @ExitGame.canceled -= m_Wrapper.m_MainMenuControllerActionsCallbackInterface.OnExitGame;
            }
            m_Wrapper.m_MainMenuControllerActionsCallbackInterface = instance;
            if (instance != null)
            {
                @StartGame.started += instance.OnStartGame;
                @StartGame.performed += instance.OnStartGame;
                @StartGame.canceled += instance.OnStartGame;
                @ExitGame.started += instance.OnExitGame;
                @ExitGame.performed += instance.OnExitGame;
                @ExitGame.canceled += instance.OnExitGame;
            }
        }
    }
    public MainMenuControllerActions @MainMenuController => new MainMenuControllerActions(this);
    private int m_KeyboardSchemeIndex = -1;
    public InputControlScheme KeyboardScheme
    {
        get
        {
            if (m_KeyboardSchemeIndex == -1) m_KeyboardSchemeIndex = asset.FindControlSchemeIndex("Keyboard");
            return asset.controlSchemes[m_KeyboardSchemeIndex];
        }
    }
    private int m_GamePadSchemeIndex = -1;
    public InputControlScheme GamePadScheme
    {
        get
        {
            if (m_GamePadSchemeIndex == -1) m_GamePadSchemeIndex = asset.FindControlSchemeIndex("GamePad");
            return asset.controlSchemes[m_GamePadSchemeIndex];
        }
    }
    public interface IPlayerControlsActions
    {
        void OnMove(InputAction.CallbackContext context);
        void OnUse(InputAction.CallbackContext context);
        void OnPickUpRelease(InputAction.CallbackContext context);
        void OnRun(InputAction.CallbackContext context);
        void OnLook(InputAction.CallbackContext context);
        void OnQuitGame(InputAction.CallbackContext context);
    }
    public interface IMenuPlayerControlsActions
    {
        void OnMove(InputAction.CallbackContext context);
        void OnUse(InputAction.CallbackContext context);
    }
    public interface IMainMenuControllerActions
    {
        void OnStartGame(InputAction.CallbackContext context);
        void OnExitGame(InputAction.CallbackContext context);
    }
}
