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
        Slow();

        Invoke("Restore", 3.0f);
    }

    public void Slow() => MessageSystem.Dispatcher.singletonInstance.Send("slowEnemy");

    public void Restore() => MessageSystem.Dispatcher.singletonInstance.Send("speedUpEnemy");


}
