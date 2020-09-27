using MessageSystem;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : Singleton<Player>
{
    // fmod
    [FMODUnity.EventRef]
    public string powerUp;
    FMOD.Studio.EventInstance powerUpEvent;

    [Header("Power Up")]
    [SerializeField] private PowerUp currentPowerUp;

    #region Properties

    public PowerUp PowerUp
    {
        get => currentPowerUp;
        set => currentPowerUp = value;
    }

    #endregion

    private void Start()
    {
        powerUpEvent = FMODUnity.RuntimeManager.CreateInstance(powerUp);
        FMODUnity.RuntimeManager.AttachInstanceToGameObject(powerUpEvent, transform, GetComponent<Rigidbody>());
    }

    public void ApplyPowerUp()
    {
        powerUpEvent.start(); //fmod
        if (currentPowerUp)
        {
            Debug.LogWarning("There is no PowerUp in the player.");
            return;
        }

        currentPowerUp.OnApply();
    }
}

