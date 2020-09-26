/*
 * File: Locomotion.cs
 * File Created: Tuesday, 22nd September 2020 4:48:10 pm
 * ––––––––––––––––––––––––
 * Author: Jesus Fermin, 'Pokoi', Villar  (hello@pokoidev.com)
 * ––––––––––––––––––––––––
 * MIT License
 * 
 * Copyright (c) 2020 Pokoidev
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is furnished to do
 * so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */


using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace ArtificialIntelligence
{
    [RequireComponent (typeof(UnityEngine.AI.NavMeshAgent))]
    public class Locomotion : MonoBehaviour
    {
        private UnityEngine.AI.NavMeshAgent agent;
        private Vector3 destination;
        private Transform cachedTransform;
        private ArtificialIntelligence.IntelligentAgent intelligentAgent;

        public void Init() 
        {
            agent = GetComponent<UnityEngine.AI.NavMeshAgent>();
            intelligentAgent = GetComponent<ArtificialIntelligence.IntelligentAgent>();

            cachedTransform = transform;  
        }

        public UnityEngine.AI.NavMeshAgent  GetNavMeshAgent() => agent;

        public void SetDestination(Vector3 destination) => this.destination = new Vector3(destination.x, 0.0f, destination.z);
        public void Activate() => StartCoroutine(LocomotionTask());
        public void Inactivate() => StopCoroutine(LocomotionTask());
        
        public void Slow() => agent.speed = 1.5f;
        public void SpeedUp() => agent.speed = 3.5f;

        public IEnumerator LocomotionTask()
        {
            while(true)
            {
                yield return new WaitForEndOfFrame();                

                if(Vector3.Distance (destination, new Vector3(cachedTransform.position.x, 0.0f, cachedTransform.position.z)) > 0.1f)
                {
                    agent.destination = destination; 
                    intelligentAgent.Unhide();              
                }

                else
                {
                    switch(intelligentAgent.GetThinker().GetCurrentAction())
                    {
                        case ArtificialIntelligence.DecisionMaker.ActionTypes.CHANGE_HIDDING_PLACE:
                        intelligentAgent.Hide();
                        break;

                        case ArtificialIntelligence.DecisionMaker.ActionTypes.CHANGE_ROOM:                        
                        break;

                        case ArtificialIntelligence.DecisionMaker.ActionTypes.CHOOSE_HIDDING_PLACE:
                        intelligentAgent.Hide();
                        break;

                        case ArtificialIntelligence.DecisionMaker.ActionTypes.GOAL:
                        intelligentAgent.AtGoal();
                        Inactivate();
                        break;

                        case ArtificialIntelligence.DecisionMaker.ActionTypes.WAIT:
                        break;
                    }

                    var destiny = intelligentAgent.GetThinker().MakeADecision();   
                    
                    float seconds = intelligentAgent.GetThinker().GetCurrentAction() == ArtificialIntelligence.DecisionMaker.ActionTypes.GOAL ||
                                    intelligentAgent.GetThinker().GetCurrentAction() == ArtificialIntelligence.DecisionMaker.ActionTypes.CHOOSE_HIDDING_PLACE
                                    ?                                    
                                    0.1f :
                                    Random.Range(6.0f, 12.0f);
                   

                    yield return new WaitForSeconds(seconds);
                    
                    SetDestination (destiny);                        

                }
            }
        }

    }

}