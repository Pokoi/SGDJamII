using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : Singleton<Player>
{
    [Header("Power Up")]
    [SerializeField] private PowerUp currentPowerUp;

    #region Properties

    public PowerUp PowerUp
    {
        get => currentPowerUp;
        set => currentPowerUp = value;
    }

    #endregion

    public void ApplyPowerUp()
    {
        if (currentPowerUp)
        {
            Debug.LogWarning("There is no PowerUp in the player.");
            return;
        }

        currentPowerUp.OnApply();
    }
}
