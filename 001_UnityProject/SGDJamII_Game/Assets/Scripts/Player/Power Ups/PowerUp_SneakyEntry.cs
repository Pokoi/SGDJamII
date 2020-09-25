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
        throw new System.NotImplementedException();
    }
}
