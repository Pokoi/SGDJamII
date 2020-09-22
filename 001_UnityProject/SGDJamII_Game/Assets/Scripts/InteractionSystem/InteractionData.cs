using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/*
 *  Esta clase es la encargada de almacenar la información del objeto que puede ser interactuado.
 *  El hecho de que sea un ScriptableObject hace que cualquier clase pueda tener acceso a estos datos de manera simple y rapida.
 * 
 *  ResetData : Hace un clear de los datos del objeto interactuable.
 *  Interact : Metodo que se usa para interactuar con el objeto almacenado.
 */

[CreateAssetMenu(fileName = "Interaction Data", menuName = "InteractionSystem/InteractionData")]
public class InteractionData : ScriptableObject
{
    private InteractableBase m_interactable;

    public InteractableBase Interactable
    {
        get => m_interactable;
        set => m_interactable = value;
    }

    #region Methods

    public void Interact()
    {
        m_interactable.OnInteract();
        ResetData();
    }

    public void ResetData() => m_interactable = null;

    #endregion

    #region Properties

    public bool IsSameInteractable(InteractableBase _newInteractable) => m_interactable == _newInteractable;
    public bool IsEmpty() => m_interactable == null;

    #endregion
}
