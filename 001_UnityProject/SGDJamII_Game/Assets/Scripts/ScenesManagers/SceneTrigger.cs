using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.SceneManagement;

public class SceneTrigger : MonoBehaviour
{

    private void OnTriggerEnter(Collider other)
    {
           SceneFader.Instance.PlayFadeOut();
    }
   
}
