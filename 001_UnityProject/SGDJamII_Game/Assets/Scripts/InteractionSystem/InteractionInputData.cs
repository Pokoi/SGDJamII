using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "InteractionInputData", menuName = "InteractionSystem/InputData")]
public class InteractionInputData : ScriptableObject
{
    private bool m_interactedClicked;
    private bool m_interactedRelease;

    private bool m_inspectClicked;
    private bool m_inspectRelease;

    public bool InteractedClicked
    {
        get => m_interactedClicked;
        set => m_interactedClicked = value;
    }
    public bool InteractedRelease
    {
        get => m_interactedRelease;
        set => m_interactedRelease = value;
    }

    public bool InspectClicked
    {
        get => m_inspectClicked;
        set => m_inspectClicked = value;
    }
    public bool InspectRelease
    {
        get => m_inspectRelease;
        set => m_inspectRelease = value;
    }

    public void ResetInput()
    {
        m_interactedClicked = false;
        m_interactedRelease = false;

        m_inspectClicked = false;
        m_inspectRelease = false;
    }
}
