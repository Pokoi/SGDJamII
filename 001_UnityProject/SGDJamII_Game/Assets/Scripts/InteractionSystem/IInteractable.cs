using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/*
 *  Esta interfaz será la usada para hacer una clase supsceptible a la interacción. 
 * 
 *  Cada clase podrá utilizar valores predeterminados distintos de las variables para hacer distintas configuraciones de interacción.
 * 
 */

public interface IInteractable
{
    string ActionName { get; }
    bool MultipleUse { get; }
    bool IsInteractable { get; }


    void OnInteract();
}
