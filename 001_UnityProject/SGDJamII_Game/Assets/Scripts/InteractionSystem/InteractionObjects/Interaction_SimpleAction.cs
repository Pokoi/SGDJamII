using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class Interaction_SimpleAction : InteractableBase
{
    [Header("Action Properties")]
    [SerializeField] protected UnityEvent actionToPerform;

    public override void OnInteract()
    {
        base.OnInteract();

        actionToPerform?.Invoke();
    }
}
