using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneFader : Singleton<SceneFader>
{
    public Animator animator;
    public void PlayFadeOut()
    {
        animator.SetBool("FadeOut", true);
    }

    public void StartGame()
    {
        SceneManager.LoadScene(1);
    }

    public void StartCountdown()
    {

    }

    public void PlayFadeIn()
    {
        animator.SetBool("FadeIn", true);
    }
}
