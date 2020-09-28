using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StartCanvas : MonoBehaviour
{
    public int timeToStart = 3;
    private PlayerMovement player;

    public CanvasUI canvas;

    // Start is called before the first frame update
    void Start()
    {
       StartCoroutine(disablePlayerMovement());
    }

    IEnumerator disablePlayerMovement()
    {
        while (!player)
        {
            player = FindObjectOfType<PlayerMovement>();
            yield return null;
        }

        player.enabled = false;
        yield return new WaitForSeconds(2f);
        StartCoroutine(timer());
    }

    IEnumerator timer()
    {

        while (timeToStart-- > 0)
        {
            canvas.timeToStart.text = (timeToStart + 1).ToString();
           
            yield return new WaitForSeconds(1);
        }

        canvas.timeToStart.text = "GO!";

        yield return new WaitForSeconds(1);
        
        player.enabled = true;
        
        Destroy(canvas.timeToStart);
        Destroy(this);

    }

}
