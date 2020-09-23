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

        private void Start() 
        {
            agent = GetComponent<UnityEngine.AI.NavMeshAgent>();
            intelligentAgent = GetComponent<ArtificialIntelligence.IntelligentAgent>();

            cachedTransform = transform;  
        }

        private void Update() 
        {
            if(Vector3.Distance (destination, cachedTransform.position) > 1.0f)
            {
                agent.destination = destination;
            }

            SetDestination (intelligentAgent.GetThinker().MakeADecision());            
        }

        public void SetDestination(Vector3 destination) => this.destination = destination;

    }

}