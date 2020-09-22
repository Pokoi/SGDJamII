using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;
using UnityEngine.InputSystem;

public class CameraMovement : MonoBehaviour
{

    [Range(0f, 10f)] public float LookSpeed = 1f;
    public bool InvertY = true;
    private CinemachineFreeLook _freeLookComponent;
    private Vector2 lookMovement;
    
    private PlayerInputActions inputActions;


    public void Awake()
    {
        _freeLookComponent = GetComponent<CinemachineFreeLook>();

        if (inputActions == null)
            inputActions = new PlayerInputActions();
    }

    void OnEnable()
    {
        inputActions.Enable();

        inputActions.PlayerControls.Look.performed += LookPerformed;
        inputActions.PlayerControls.Look.canceled += LookCancelled;

    }

    void OnDisable()
    {
        inputActions.Enable();

        inputActions.PlayerControls.Look.performed -= LookPerformed;
        inputActions.PlayerControls.Look.canceled -= LookCancelled;
    }

    public void Update()
    {
        //Ajust axis values using look speed and Time.deltaTime so the look doesn't go faster if there is more FPS
        _freeLookComponent.m_XAxis.Value += lookMovement.x * LookSpeed * Time.deltaTime;
        _freeLookComponent.m_YAxis.Value += lookMovement.y * LookSpeed * Time.deltaTime;
    }
    // Update the look movement each time the event is trigger
    public void LookPerformed(InputAction.CallbackContext context)
    {
        //Normalize the vector to have an uniform vector in whichever form it came from (I.E Gamepad, mouse, etc)
        lookMovement = context.ReadValue<Vector2>().normalized;
        lookMovement.y = InvertY ? -lookMovement.y : lookMovement.y;

        // This is because X axis is only contains between -180 and 180 instead of 0 and 1 like the Y axis
        lookMovement.x = lookMovement.x * 180f;

    }
    public void LookCancelled(InputAction.CallbackContext context)
    {
        lookMovement = Vector2.zero;
    }
}
