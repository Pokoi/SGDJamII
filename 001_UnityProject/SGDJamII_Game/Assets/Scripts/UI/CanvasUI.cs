using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class CanvasUI : MonoBehaviour
{
    public TextMeshProUGUI Timetext, caughtGhosts, savedGhosts, timeToStart;

    private void DrawCanvasTime()
    {
        Timetext.text = "Time: " + GameManager.Instance.TimeLeftText();
    }

    private void DrawGhosts()
    {
        caughtGhosts.text = "Ghosts caught: " + GameManager.Instance.GetEnemiesCaught();
        savedGhosts.text = "Ghosts saved: " + GameManager.Instance.GetEnemiesSaved();
    }

    private void Update()
    {
        DrawCanvasTime();
        DrawGhosts();
    }
}
