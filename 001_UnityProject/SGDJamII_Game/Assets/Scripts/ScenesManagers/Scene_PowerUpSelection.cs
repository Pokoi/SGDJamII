using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Scene_PowerUpSelection : MonoBehaviour
{
    void Start()
    {
        Interaction_PowerUp.OnSelection += OnPowerUpSelection;
    }

    public void OnPowerUpSelection()
    {
        Debug.Log("Selección Realizada.");

        //TODO : Eliminar el resto de power ups, o hacerlo no interactuables.
        //TODO : Abrir la puerta.
    }
}