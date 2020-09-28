using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class CanvasUI : MonoBehaviour
{
    public TextMeshProUGUI Timetext, caughtGhosts, savedGhosts, timeToStart;
    public GameObject gatcha;

    private void DrawCanvasTime()
    {
        Timetext.text = "Time: " + GameManager.Instance.TimeLeftText();
    }

    private void DrawGhosts()
    {
        caughtGhosts.text = "Ghosts caught: " + GameManager.Instance.GetEnemiesCaught();
        savedGhosts.text = "Ghosts saved: " + GameManager.Instance.GetEnemiesSaved();
    }

    public void enableGatcha()
    {
        gatcha.SetActive(true);
        Invoke("disableGatcha", 1);

    }

    private void disableGatcha()
    {
        gatcha.SetActive(false);
    }

    private void Update()
    {
        DrawCanvasTime();
        DrawGhosts();
    }
}
