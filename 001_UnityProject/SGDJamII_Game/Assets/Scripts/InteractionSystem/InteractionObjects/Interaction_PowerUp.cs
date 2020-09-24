using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class Interaction_PowerUp : InteractableBase
{
    [Header("Power Up Settings")]
    [SerializeField] private PowerUp powerUp;

    private Player m_player;

    public delegate void SelectionAction();
    public static event SelectionAction OnSelection;

    #region Built-In Methods

    private void Awake()
    {
        if (powerUp == null)
        {
            Debug.LogError(gameObject.name + " object doesnt have PowerUp");
            return;
        }

        ActionName = powerUp.PowerUpName;
    }

    private void Start()
    {
        m_player = GameObject.FindObjectOfType<Player>();

        if (!m_player)
            Debug.LogError("Player not found.");
    }

    #endregion

    
    public override void OnInteract()
    {
        base.OnInteract();

        ApplyPowerUp();
    }

    void ApplyPowerUp()
    {
        /*
        if (powerUp == null)
            return;
        */

        m_player.PowerUp = powerUp;
        powerUp?.OnApply();

        OnSelection();

        DestroyImmediate(transform.gameObject);
    }
}
