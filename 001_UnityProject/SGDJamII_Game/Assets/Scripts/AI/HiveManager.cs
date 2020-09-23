using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace ArtificialIntelligence
{        
    public class HiveManager : MonoBehaviour
    {
        private List<ArtificialIntelligence.IntelligentAgent> agents;
        public static ArtificialIntelligence.HiveManager singletonInstance;

        private void Awake() 
        {
            if(singletonInstance == null)
            {
                singletonInstance = this;
            }
            else
            {
                Destroy(this);
            }    
        }
        
        public void AddAgent(ArtificialIntelligence.IntelligentAgent agent) => agents.Add(agent);
        public List<ArtificialIntelligence.IntelligentAgent> GetAgents() => agents;
    }

}