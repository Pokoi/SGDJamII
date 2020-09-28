using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PowerUp_SneakyEntry : PowerUp
{
    bool used = false;

    private void Awake()
    {
        PowerUpName = "Sneaky Entry";
    }

    public override void OnApply()
    {
        if (!used)
        { 
            MessageSystem.Dispatcher.singletonInstance.Send("sneakyEntry");
            used = true;
        }
    }
}
