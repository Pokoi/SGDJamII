using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

/*
 *  Clase base para la interacción. Cualquier objeto que herede esta clase será automaticamente interactuable.
 * 
 *  IMPORTANTE : Todos los objetos interactuables deben estar siempre en el layer "Interactable" para ser interpretados como tales.
 *  
 */

[RequireComponent(typeof(Collider))]
public class InteractableBase : MonoBehaviour, IInteractable
{
    #region Variables
    [Header("Interactable Settings")]
    [SerializeField] private string actionName;

    [Space]
    [SerializeField] private bool multipleUse = true;
    [SerializeField] private bool isInteractable = true;

    [Space]
    [Header("Hold Settings")]
    [SerializeField] private bool holdInteract;
    [SerializeField] private float holdDuration;

    List<ParticleSystem> particles = new List<ParticleSystem>();

    bool emittingParticles;


    #endregion

    #region Properties
    public bool MultipleUse => multipleUse;
    public bool IsInteractable
    {
        get => isInteractable;
        set => isInteractable = value;
    }
    public string ActionName
    {
        get => actionName;
        set => actionName = value;
    }
    public float HoldDuration => holdDuration;
    public bool HoldInteract => holdInteract;
    #endregion

    #region Methods

    #region Built-In Methods

    private void Start()
    {
        if (actionName == null)
            actionName = gameObject.name;
    }

    #endregion

    public virtual void OnInteract()
    {
        Debug.Log("INTERACTED : " + gameObject.name);

        if (!multipleUse)
        {
            isInteractable = false;
        }
    }

    public void PlayParticles()
    {
        if (!emittingParticles)
        { 
            if(particles.Count == 0)
            {
                particles = transform.GetComponentsInChildren<ParticleSystem>().ToList<ParticleSystem>();
            }

            foreach (ParticleSystem p in particles)
            {
                p.Play();
            }

            emittingParticles = true;
        }
    }

    public void StopParticles()
    {
        emittingParticles = false;

        foreach (ParticleSystem p in particles)
        {
            p.Clear();
            p.Stop();
        }
    }

    #endregion
}
