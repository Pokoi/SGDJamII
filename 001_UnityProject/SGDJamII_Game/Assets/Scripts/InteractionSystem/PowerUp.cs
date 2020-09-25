using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public abstract class PowerUp : MonoBehaviour
{
    public string PowerUpName { get; set; }

    public abstract void OnApply();
}
