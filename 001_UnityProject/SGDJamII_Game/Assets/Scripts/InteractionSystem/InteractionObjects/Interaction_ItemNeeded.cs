using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class Interaction_ItemNeeded : InteractableBase
{
    [Header("Item Needed")]
    [SerializeField] private ItemData itemNeeded;

    [Space]
    [Header("Succesfull Use")]
    [SerializeField] private UnityEvent succesfullEvent;
    [Header("Failed Use")]
    [SerializeField] private UnityEvent failedEvent;

    public override void OnInteract()
    {
        base.OnInteract();

        /*
        if // TODO : Verificar uso de item.
        {
            succesfullEvent?.Invoke();
            isInteractable = false;
        }
        else
            failedEvent?.Invoke();
        */
    }
}
