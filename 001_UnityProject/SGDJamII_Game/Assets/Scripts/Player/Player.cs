﻿using MessageSystem;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UIElements;


public class Player : Singleton<Player>
{
    // fmod
    [FMODUnity.EventRef]
    public string powerUp;
    FMOD.Studio.EventInstance powerUpEvent;

    //[Header("Power Up")]
    //[SerializeField] private PowerUp currentPowerUp;
    public PowerUp currentPowerUp = null;

    bool used = false;

    public Sprite image;

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
        if (!used)
        {

            if (!TryGetComponent(out PowerUp p))
            {
                //Debug.LogError("No powerup in player");
                return;
            }
            else
                currentPowerUp = p;

            used = true;
            
            powerUpEvent.start(); //fmod


            float seconds = 1.319f;

            Invoke("StopSoundEffect", seconds);

            currentPowerUp.OnApply();
            GameObject.FindGameObjectWithTag("PowerUpCanvas").GetComponent<UnityEngine.UI.Image>().sprite = image;
        }        
    }

    public void StopSoundEffect()
    {
        powerUpEvent.stop(FMOD.Studio.STOP_MODE.IMMEDIATE);
    }
}

