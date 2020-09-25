using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PowerUp_SlowEnemy : PowerUp
{
    private void Awake()
    {
        PowerUpName = "Slow Enemy";
    }

    public override void OnApply()
    {
        throw new System.NotImplementedException();
    }

}
