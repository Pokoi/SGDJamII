using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PowerUp_SneakyEntry : PowerUp
{
    private void Awake()
    {
        PowerUpName = "Sneaky Entry";
    }

    public override void OnApply()
    {
        MessageSystem.Dispatcher.singletonInstance.Send("sneakyEntry");
    }
}
