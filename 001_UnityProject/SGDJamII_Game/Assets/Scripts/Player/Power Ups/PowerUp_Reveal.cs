using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PowerUp_Reveal : PowerUp
{
    float radius = 4.0f;

    private void Awake()
    {
        PowerUpName = "Reveal";
    }

    public override void OnApply()
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

        // Amount has the value of the number of enemies inside this radius
    }
}
