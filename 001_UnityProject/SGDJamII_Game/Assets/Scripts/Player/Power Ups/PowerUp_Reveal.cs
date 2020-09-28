using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

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
            Vector3 center = Player.Instance.transform.position;
            int amount = 0;

            Collider[] hitColliders = Physics.OverlapSphere(center, radius);
            foreach (var hitCollider in hitColliders)
            {
                if (hitCollider.gameObject.TryGetComponent(out ArtificialIntelligence.IntelligentAgent agent))
                {
                    ++amount;
                }
            }

            used = true;
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
