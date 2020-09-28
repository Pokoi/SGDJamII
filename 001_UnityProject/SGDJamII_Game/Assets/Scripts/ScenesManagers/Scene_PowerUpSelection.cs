using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Scene_PowerUpSelection : MonoBehaviour
{
    [Header("Objects Reference")]
    [SerializeField] private GameObject levelDoor;

    void Start()
    {
        Interaction_PowerUp.OnSelection += OnPowerUpSelection;
    }

    public void OnPowerUpSelection()
    {
        Interaction_PowerUp[] powerUps = FindObjectsOfType<Interaction_PowerUp>();
        foreach (Interaction_PowerUp IO_PowerUp in powerUps)
        {
            IO_PowerUp.IsInteractable = false;
            //IO_PowerUp.gameObject.SetActive(false);
        }

        //levelDoor.SetActive(false);
        //TODO : Eliminar el resto de power ups, o hacerlo no interactuables.
        //TODO : Abrir la puerta.
    }
    private void OnDestroy()
    {
        Interaction_PowerUp.OnSelection -= OnPowerUpSelection;
    }
}