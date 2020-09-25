using ArtificialIntelligence;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : Singleton<GameManager>
{

    private int enemiesCaught = 0;
    private int enemiesSaved = 0;
    private bool gameOver = false;

    [Header("Enemies")]
    public int enemiesNumber = 0;
    public HiveManager hiveManager;
    public GameObject artificialAgent;

    [Header("Game Duration")]
    [Tooltip("Time in seconds")]
    public int gameDuration = 60;
    private float currentTime = 0.0f;

    //GETTERS
    public int GetEnemiesCaught() => enemiesCaught;
    public int GetEnemiesSaved() => enemiesSaved;
    public bool IsGameOver() => gameOver;

    public float SecondsLeft() => gameDuration - currentTime;

    //Returns time left in format mm:ss
    public string TimeLeftText()
    {        
        int seconds = (int)SecondsLeft() % 60;
        int minutes = (int)SecondsLeft() / 60;

        return String.Format("{0:D2}m:{1:D2}s", minutes, seconds);
    }


    private void Start()
    {
        if (enemiesNumber <= 0)
            Debug.LogError("Enemies number not assigned in Game Manager");

        if (hiveManager)
            CreateEnemies();
        else
            Debug.LogException(new Exception("Hive manager not found in Game Manager"));
    }

    private void Update()
    {
        Debug.Log(TimeLeftText());
        if (!gameOver)
        {
            currentTime += Time.deltaTime;
            if (currentTime >= gameDuration)
                PlayerDefeated(true);
        }
    }


    //Instantiates Artificial Intelligent enemies in the scene based on enemies number
    private void CreateEnemies()
    {
        for (int i = 0; i < enemiesNumber; i++)
        {
            GameObject AIAgent = Instantiate(artificialAgent, transform.position, Quaternion.identity);
            AIAgent.transform.parent = hiveManager.transform;
            AIAgent.GetComponent<IntelligentAgent>().Init();
        }

        hiveManager.RandomizeAgentsInitialHiddingPlace();
    }

    //Called by the ghost when they die
    public void EnemyCaught()
    {
        enemiesCaught++;
        if (enemiesCaught >= enemiesNumber)
            PlayerVictory();

    }
    public void EnemySaved()
    {
        enemiesSaved++;
        if (enemiesSaved >= enemiesNumber)
            PlayerDefeated(false);
    }

    private void PlayerVictory()
    {
        gameOver = true;
        string victoryText = String.Format("Victoria!\n enemigos atrapados {0}/{1}", enemiesCaught, enemiesNumber);
        Debug.Log(victoryText);

    }

    private void PlayerDefeated(bool timeOver)
    {
        gameOver = true;
        if (timeOver)
        {
            string defeatText = String.Format("Derrota\n enemigos atrapados {0}/{1}\n enemigos salvados {2}{1}\n. Se ha acabado el tiempo!", 
                enemiesCaught, enemiesNumber, enemiesSaved);
            
            Debug.Log(defeatText);
        }
        else
        {
            string defeatText = String.Format("Derrota\n enemigos atrapados {0}/{1}\n enemigos salvados {2}{1}",
                enemiesCaught, enemiesNumber,enemiesSaved);

            Debug.Log(defeatText);
        }

        ResetGame();
    }
    private void ResetGame()
    {

        SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
    }

}
