using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/*
 *  Controlador de la interacción de la cámara. 
 *  
 *  A cada frame comprueba.
 *      CheckForInteractable: Si hay algún objeto interactuable hacia la dirección de un Raycast (al frente del jugador ahora mismo).
 *      CheckForInteractableInput: Comprueba si el botón de interacción es pulsado para interactuar con el objeto almacenado en InteractionData, si lo hubiera.
 */

public class InteractionController : MonoBehaviour
{

    #region Variables
    [Header("Data")]
    [SerializeField] InteractionData interactionData;

    [Space]
    [Header("Ray Settings")]
    public float rayDistance;
    public float raySphereRadius;
    public LayerMask interactableLayer;

    [Space]
    [SerializeField] Transform rayPositionOffset;

    [Header("Debug")]
    public float holdPercentage = 0f;
    #endregion

    #region Private

    bool m_interacting;
    bool m_firstInteractingInput = true;

    bool m_hitSomething;
    Ray m_ray;

    float m_holdTimer = 0f;
    #endregion

    #region Built In Methods

    private void Update()
    {
        CheckForInteractable();
        CheckForInteractableInput();
    }

    private void OnDrawGizmos()
    {
        DrawInteractionRay();
    }
    #endregion

    #region Custom Methods
    void CheckForInteractable()
    {
        //Ray to the direction : Front of player.
        m_ray = new Ray(rayPositionOffset.position, gameObject.transform.forward);

        RaycastHit _hitInfo;

        m_hitSomething = Physics.SphereCast(m_ray, raySphereRadius, out _hitInfo, rayDistance, interactableLayer);

        if (m_hitSomething)
        {
            InteractableBase _interactable = _hitInfo.transform.GetComponent<InteractableBase>();

            if (_interactable == null)
                _interactable = _hitInfo.transform.GetComponentInChildren<InteractableBase>();

            if (_interactable != null)
            {
                //Fill Interaction Data
                if (interactionData.IsEmpty())
                {
                    interactionData.Interactable = _interactable;
                }
                else
                {
                    if (!interactionData.IsSameInteractable(_interactable))
                        interactionData.Interactable = _interactable;
                }
            }
        }
        else
        {
            //Reset interaction Data
            interactionData.ResetData();
        }
    }
    
    void CheckForInteractableInput()
    {

        if (interactionData.IsEmpty())
            return;

        if (m_interacting && m_firstInteractingInput)
        {

            if (!interactionData.Interactable.IsInteractable)
                return;

            if (interactionData.Interactable.HoldInteract)
            {
                m_holdTimer += Time.deltaTime;

                double _holdP = Mathf.Clamp(m_holdTimer / interactionData.Interactable.HoldDuration, 0f, 1f);
                holdPercentage = (float) Math.Round(_holdP, 2);
                                            
                if (m_holdTimer >= interactionData.Interactable.HoldDuration)
                {
                    Interact();
                }
            }
            else
            {
                Interact();
            }
        }
    }

    void Interact()
    {
        interactionData.Interact();
        m_interacting = false;
        m_firstInteractingInput = false;
        holdPercentage = 0f;
    }

    #region Input

    public void OnInteractionPress()
    {
        m_interacting = true;

        if (m_firstInteractingInput)
            m_holdTimer = 0f;
    }

    public void OnInteractionUnpress()
    {
        m_interacting = false;
        m_firstInteractingInput = true;
        m_holdTimer = 0f;
        holdPercentage = 0f;
    }

    #endregion

    #region Debug

    void DrawInteractionRay()
    {
        // Debug.DrawRay(gameObject.transform.position + rayPositionOffset, gameObject.transform.forward * rayDistance, m_hitSomething ? Color.green : Color.red);        
        Debug.DrawRay(rayPositionOffset.position, gameObject.transform.forward, m_hitSomething ? Color.green : Color.red);
    }

    #endregion

    #endregion
}
