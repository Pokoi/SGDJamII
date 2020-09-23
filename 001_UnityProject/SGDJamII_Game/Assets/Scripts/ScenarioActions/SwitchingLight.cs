using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SwitchingLight : MonoBehaviour
{
    [SerializeField]
    private Light light;

    public void TurnLight()
    {
        bool _state = light.enabled;
        light.enabled = !_state;
    }
}
