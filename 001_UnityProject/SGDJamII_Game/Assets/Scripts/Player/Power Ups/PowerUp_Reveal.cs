using System.Collections;
using System.Collections.Generic;
using UnityEngine;

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
        }
    }
}
