using ArtificialIntelligence;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : Singleton<GameManager>
{
    // FMOD
    [FMODUnity.EventRef]
    public string backgroundMusic;
    [FMODUnity.EventRef]
    public string endgame;
    //[FMODUnity.EventRef]
    //public string levitate;

    FMOD.Studio.EventInstance musicEvent;
    FMOD.Studio.EventInstance endgameEvent;
    //FMOD.Studio.EventInstance levitateEvent;


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

    private Type powerUpType;

    private bool hiveInitialized = false;

    public GameObject mainDoor;

    public Type powerUp { get { return powerUpType; } set { powerUpType = value; } }
    public bool GameScene = false;

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
        musicEvent = FMODUnity.RuntimeManager.CreateInstance(backgroundMusic);
        endgameEvent = FMODUnity.RuntimeManager.CreateInstance(endgame);

        if (enemiesNumber <= 0)
            Debug.LogError("Enemies number not assigned in Game Manager");


        musicEvent.start();
        mainDoor.SetActive(false);
    }

    private void Update()
    {
        FMODUnity.RuntimeManager.AttachInstanceToGameObject(musicEvent, Player.Instance.transform, Player.Instance.GetComponent<Rigidbody>());   

        if (GameScene && !gameOver)
        {
            currentTime += Time.deltaTime;
            if (currentTime >= gameDuration)
                PlayerDefeated(true);
        }

        if (hiveManager && !hiveInitialized)
        {
            SceneFader.Instance.PlayFadeIn();
            GameScene = true;
            CreateEnemies();
            hiveInitialized = true;
            Player.Instance.gameObject.AddComponent(powerUpType);
            
            
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
        musicEvent.stop(FMOD.Studio.STOP_MODE.IMMEDIATE);
        FMODUnity.RuntimeManager.AttachInstanceToGameObject(endgameEvent, Player.Instance.transform, Player.Instance.GetComponent<Rigidbody>());
        endgameEvent.setParameterByName("WinParam", 1.0f);
        endgameEvent.start(); //fmod
        

        gameOver = true;
        string victoryText = String.Format("Victoria!\n enemigos atrapados {0}/{1}", enemiesCaught, enemiesNumber);
        Debug.Log(victoryText);
    }

    private void PlayerDefeated(bool timeOver)
    {
        musicEvent.stop(FMOD.Studio.STOP_MODE.IMMEDIATE);
        FMODUnity.RuntimeManager.AttachInstanceToGameObject(endgameEvent, Player.Instance.transform, Player.Instance.GetComponent<Rigidbody>());
        endgameEvent.setParameterByName("WinParam", 0.0f);
        endgameEvent.start(); //fmod


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

        SceneManager.LoadScene(0);
    }

}
