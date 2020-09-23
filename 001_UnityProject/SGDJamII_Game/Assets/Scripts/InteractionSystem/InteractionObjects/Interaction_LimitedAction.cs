using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Interaction_LimitedAction : Interaction_SimpleAction
{
    [Header("Limitation")]
    [SerializeField] protected int usesBeforeDisabling = 5;

    private int uses;

    public override void OnInteract()
    {
        base.OnInteract();

        uses++;

        if (uses >= usesBeforeDisabling)
            IsInteractable = false;
    }
}
