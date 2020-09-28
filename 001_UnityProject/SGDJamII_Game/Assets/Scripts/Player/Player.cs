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

    //[Header("Power Up")]
    //[SerializeField] private PowerUp currentPowerUp;
    public PowerUp currentPowerUp = null;

    // public void SetPowerUp(PowerUp p) => currentPowerUp = p;

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

        if (!TryGetComponent(out PowerUp p))
        {
            Debug.LogError("No powerup in player");
            return;
        }
        else
            currentPowerUp = p;

        currentPowerUp.OnApply();
    }
}

