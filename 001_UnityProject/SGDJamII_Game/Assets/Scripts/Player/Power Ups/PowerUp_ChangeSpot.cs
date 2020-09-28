using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PowerUp_ChangeSpot : PowerUp
{

    bool used = false;

    private void Awake()
    {
        PowerUpName = "Change Spot";    
    }

    public override void OnApply()
    {
        if (!used)
        { 
            MessageSystem.Dispatcher.singletonInstance.Send("changeSpot");
            used = true;        
        }
    }

}
