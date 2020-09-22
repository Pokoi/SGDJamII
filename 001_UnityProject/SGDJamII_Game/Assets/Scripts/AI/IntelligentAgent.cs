﻿/*
 * File: IntelligentAgent.cs
 * File Created: Tuesday, 22nd September 2020 3:22:10 pm
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
    [RequireComponent (typeof(ArtificialIntelligence.Locomotion))]
    public class IntelligentAgent : MonoBehaviour
    {

        ArtificialIntelligence.Room suspicionLocation;
        ArtificialIntelligence.Room currentRoom;
        ArtificialIntelligence.HiddingPlace currentHiddingPlace;
        ArtificialIntelligence.Locomotion locomotor;
        ArtificialIntelligence.DecisionMaker thinker;   

        public struct Psychology
        {
            public float changeRoomWeight;
            public float changeHiddingPlaceWeight;
            public float waitingWeight;
            public float searchingHiddingPlaceWeight;
        }

        private IntelligentAgent.Psychology psychology;    


        private void Start() 
        {
            locomotor = GetComponent<ArtificialIntelligence.Locomotion>();
            thinker = GetComponent<ArtificialIntelligence.DecisionMaker>();

            psychology.changeRoomWeight = Random.Range(0.0f, 1.0f);
            psychology.changeHiddingPlaceWeight = Random.Range(0.0f, 1.0f);
            psychology.waitingWeight = Random.Range(0.0f, 1.0f);
            psychology.searchingHiddingPlaceWeight = Random.Range(0.0f, 1.0f);         


        }        

        public void SetSuspicionLocation(ArtificialIntelligence.Room room) => suspicionLocation = room;
        public ArtificialIntelligence.Room GetSuspicionLocation() => suspicionLocation;

        public void SetCurrentRoom(ArtificialIntelligence.Room room) => currentRoom = room;

        public ArtificialIntelligence.Room GetCurrentRoom() => currentRoom;

        public void SetCurrentHiddingPlace(ArtificialIntelligence.HiddingPlace hp) => currentHiddingPlace = hp;

        public ArtificialIntelligence.HiddingPlace GetCurrentHiddingPlace() => currentHiddingPlace;        

        public IntelligentAgent.Psychology GetPsychology() => psychology;
    
    }

}
