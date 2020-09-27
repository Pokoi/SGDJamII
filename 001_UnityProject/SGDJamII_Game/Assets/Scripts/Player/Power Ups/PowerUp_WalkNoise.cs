using ArtificialIntelligence;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PowerUp_WalkNoise : PowerUp
{
    private void Awake()
    {
        PowerUpName = "Walk Noise";
    }

    public override void OnApply()
    {
        TurnOnEmitters();
        Invoke("TurnOffEmitters", 5.0f);
    }

    public void TurnOnEmitters()
    {
        var agents = HiveManager.singletonInstance.GetAgents();

        foreach (ArtificialIntelligence.IntelligentAgent agent in agents)
        {
            if (agent.gameObject.activeSelf)
            {
                agent.GetComponent<Locomotion>().Emitt();
            }
        }
    }

    public void TurnOffEmitters()
    {
        var agents = HiveManager.singletonInstance.GetAgents();

        foreach (ArtificialIntelligence.IntelligentAgent agent in agents)
        {
            if (agent.gameObject.activeSelf)
            {
                agent.GetComponent<Locomotion>().Silence();
            }
        }
    }
}
