using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using ArtificialIntelligence;

public class PowerUp_Reveal : PowerUp
{
    float radius = 4.0f;
    bool used = false;

    private void Awake()
    {
        PowerUpName = "Reveal";
    }

    public override void OnApply()
    {
        if (!used)
        {
            int amount = 0;

            Vector3 center = Player.Instance.transform.position;

            var agents = HiveManager.singletonInstance.GetAgents();

            foreach (var agent in agents)
            {
                if (!agent.GetDead()  && Vector3.Distance(agent.transform.position, center) <= 4.0f) ++amount;  
            }            
            
            // Amount has the value of the number of enemies inside this radius
            //TODO:
            GameObject.FindGameObjectWithTag("RevealedCanvas").GetComponent<TextMeshProUGUI>().text = "Near Ghosts: " + amount;
            Invoke("DisableCanvas", 5f);

        }
    }
    private void DisableCanvas()
    {
        GameObject.FindGameObjectWithTag("RevealedCanvas").gameObject.SetActive(false);
    }
}
