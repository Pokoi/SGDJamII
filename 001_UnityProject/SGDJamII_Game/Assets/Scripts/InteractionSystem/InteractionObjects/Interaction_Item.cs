using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Interaction_Item : InteractableBase
{
    [Header("Item Data")]
    [SerializeField] private ItemData itemData;

    private void Awake()
    {
        if (!itemData)
            Debug.LogError(gameObject.name + " object doesnt have item data.");

        ActionName = itemData.ObjectName;
    }

    public override void OnInteract()
    {
        base.OnInteract();

        TakeItem();
    }

    public void TakeItem()
    {
        if (!itemData)
            return;

        // TODO : Añadir item al inventario del jugador.

        DestroyImmediate(transform.parent.gameObject);
    }
}
