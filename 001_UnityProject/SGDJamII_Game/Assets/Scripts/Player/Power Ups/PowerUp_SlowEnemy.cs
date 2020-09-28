using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PowerUp_SlowEnemy : PowerUp
{
    bool used = false;

    private void Awake()
    {
        PowerUpName = "Slow Enemy";
    }

    public override void OnApply()
    {
        if (!used)
        { 
            Slow();
            Invoke("Restore", 5.0f);
            used = true;
        }
    }

    public void Slow() => MessageSystem.Dispatcher.singletonInstance.Send("slowEnemy");

    public void Restore() => MessageSystem.Dispatcher.singletonInstance.Send("speedUpEnemy");


}
