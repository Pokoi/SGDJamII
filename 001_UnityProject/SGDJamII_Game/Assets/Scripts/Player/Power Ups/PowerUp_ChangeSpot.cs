using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PowerUp_ChangeSpot : PowerUp
{
    private void Awake()
    {
        PowerUpName = "Change Spot";    
    }

    public override void OnApply()
    {
        MessageSystem.Dispatcher.singletonInstance.Send("changeSpot");
    }

}
